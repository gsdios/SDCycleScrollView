//
//  SDCycleScrollView.h
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//
/*
 
 *********************************************************************************
 *
 *  新建SDCycleScrollView交流QQ群：185534916 
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */
/*
 * 当前版本为1.62
 * 更新日期：2016.04.21
 */
import UIKit
import Kingfisher

let kCycleScrollViewInitialPageControlDotSize = CGSize(width: 10, height: 10)
let ID: String = "cycleCell"
@objc public enum OOCycleScrollViewPageContolAliment : Int {
    case right
    case center
}

@objc public enum OOCycleScrollViewPageContolStyle : Int {
    case classic
    // 系统自带经典样式
    case animated
    // 动画效果pagecontrol
    case text
    // 文字
    case none
}

@objc public protocol OOCycleScrollViewDelegate : NSObjectProtocol {
    /** 点击图片回调 */
    @objc optional func cycleScrollView(_ cycleScrollView: OOCycleScrollView, didSelectItemAtIndex index: Int)
    /** 图片滚动回调 */

    @objc optional func cycleScrollView(_ cycleScrollView: OOCycleScrollView, didScrollToIndex index: Int)
}
open class OOCycleScrollView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    /** 初始轮播图（推荐使用） */
    open class func cycleScrollViewWithFrame(_ frame: CGRect, delegate: OOCycleScrollViewDelegate, placeholderImage: UIImage) -> OOCycleScrollView {
        let cycleScrollView = OOCycleScrollView(frame: frame)
        cycleScrollView.delegate = delegate
        cycleScrollView.placeholderImage = placeholderImage
        return cycleScrollView
    }

    open class func cycleScrollViewWithFrame(_ frame: CGRect, imageURLStringsGroup imageURLsGroup: [AnyObject]) -> OOCycleScrollView {
        let cycleScrollView = OOCycleScrollView(frame: frame)
        cycleScrollView.imageURLStringsGroup = [AnyObject](imageURLsGroup)
        return cycleScrollView
    }
    /** 本地图片轮播初始化方式 */

    open class func cycleScrollViewWithFrame(_ frame: CGRect, imageNamesGroup: [AnyObject]) -> OOCycleScrollView {
        let cycleScrollView = OOCycleScrollView(frame: frame)
        cycleScrollView.localizationImageNamesGroup = [AnyObject](imageNamesGroup)
        return cycleScrollView
    }
    /** 本地图片轮播初始化方式2,infiniteLoop:是否无限循环 */

    open class func cycleScrollViewWithFrame(_ frame: CGRect, shouldInfiniteLoop infiniteLoop: Bool, imageNamesGroup: [AnyObject]) -> OOCycleScrollView {
        let cycleScrollView = OOCycleScrollView(frame: frame)
        cycleScrollView.infiniteLoop = infiniteLoop
        cycleScrollView.localizationImageNamesGroup = [AnyObject](imageNamesGroup)
        return cycleScrollView
    }
    //////////////////////  数据源接口  //////////////////////
    /** 网络图片 url string 数组 */
    open var imageURLStringsGroup: [AnyObject]? {
        didSet {
            if let imageURLStringsGroup = imageURLStringsGroup {
                self.imagePathsGroup = imageURLStringsGroup.map {
                    $0 is String ? $0 as! String : ($0 as! URL).absoluteString
                }.filter { !$0.isEmpty }.map{ $0 as AnyObject }
            }
        }
    }

    /** 每张图片对应要显示的文字数组 */
    open var titlesGroup: [AnyObject]? {
        didSet {
            
            if let titlesGroup = titlesGroup , self.onlyDisplayText {
                self.backgroundColor = UIColor.clear
                self.imageURLStringsGroup = [String](repeating: "",count: titlesGroup.count) as [AnyObject]
            }
        }
    }

    /** 本地图片数组 */
    open var localizationImageNamesGroup: [AnyObject]? {
        didSet {
            self.imagePathsGroup = localizationImageNamesGroup
        }
    }

    //////////////////////  滚动控制接口 //////////////////////
    /** 自动滚动间隔时间,默认2s */
    open var autoScrollTimeInterval: TimeInterval = 2 {
        didSet {
            self.autoScroll = (self.autoScroll);
        }
    }

    /** 是否无限循环,默认Yes */
    open var infiniteLoop: Bool = true {
        didSet {
            if self.imagePathsGroup != nil {
                self.imagePathsGroup = (self.imagePathsGroup)
            }
        }
    }

    /** 是否自动滚动,默认Yes */
    open var autoScroll: Bool = true {
        didSet {
            self.invalidateTimer()
            if autoScroll {
                self.setupTimer()
            }
        }
    }

    /** 图片滚动方向，默认为水平滚动 */
    open var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            self.flowLayout.scrollDirection = scrollDirection
        }
    }

    open weak var delegate: OOCycleScrollViewDelegate?
    /** block方式监听点击 */
    open var clickItemOperationBlock: ((Int)->Void)?
    /** block方式监听滚动 */
    open var itemDidScrollOperationBlock: ((Int)->Void)?
    /** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
    
    open weak var mainView: UICollectionView!
    // 显示图片的collectionView
    open weak var flowLayout: UICollectionViewFlowLayout!
    open var imagePathsGroup: [AnyObject]? {
        didSet {
            self.invalidateTimer()
            if let imagePathsGroup = imagePathsGroup {
                self.totalItemsCount = self.infiniteLoop ? imagePathsGroup.count * 100 : imagePathsGroup.count
                if imagePathsGroup.count != 1 {
                    self.mainView.isScrollEnabled = true
                    self.autoScroll = (self.autoScroll)
                }
                else {
                    self.mainView.isScrollEnabled = false
                }
            }
            self.setupPageControl()
            self.mainView.reloadData()
        }
    }
    
    weak var timer: Timer?
    var totalItemsCount: Int = 0
    weak var pageControl: UIControl?
    var backgroundImageView: UIImageView?
    
    func adjustWhenControllerViewWillAppera() {
        let targetIndex: Int = self.currentIndex()
        if targetIndex < totalItemsCount {
            mainView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: UICollectionViewScrollPosition(), animated: false)
        }
    }
    //////////////////////  自定义样式接口  //////////////////////
    /** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
    open var bannerImageViewContentMode: UIViewContentMode = .scaleToFill
    /** 占位图，用于网络未加载到图片时 */
    open var placeholderImage: UIImage? {
        didSet {
            if self.backgroundImageView == nil {
                let bgImageView: UIImageView = UIImageView()
                bgImageView.contentMode = .scaleAspectFit
                self.insertSubview(bgImageView, belowSubview: self.mainView)
                self.backgroundImageView = bgImageView
            }
            self.backgroundImageView!.image = placeholderImage
        }
    }

    /** 是否显示分页控件 */
    open var showPageControl: Bool = true {
        didSet {
            self.pageControl?.isHidden = !showPageControl
        }
    }

    /** 是否在只有一张图时隐藏pagecontrol，默认为YES */
    open var hidesForSinglePage = true
    /** 只展示文字轮播 */
    open var onlyDisplayText = false
    /** pagecontrol 样式，默认为动画样式 */
    open var pageControlStyle: OOCycleScrollViewPageContolStyle = .classic {
        didSet {
            self.setupPageControl()
        }
    }

    /** 分页控件位置 */
    open var pageControlAliment: OOCycleScrollViewPageContolAliment = .center
    /** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
    open var pageControlBottomOffset: CGFloat = 0
    /** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
    open var pageControlRightOffset: CGFloat = 0
    /** 分页控件小圆标大小 */
    open var pageControlDotSize: CGSize = CGSize(width: 8, height: 8) {
        didSet {
            self.setupPageControl()
            if let pageControl = pageControl as? OOPageControl {
                pageControl.dotSize = pageControlDotSize
            }
        }
    }

    /** 当前分页控件小圆标颜色 */
    open var currentPageDotColor = UIColor.white {
        didSet {
            if let pageControl = pageControl as? OOPageControl {
                pageControl.dotColor = currentPageDotColor
            }
            else if let pageControl = pageControl as? UIPageControl {
                pageControl.currentPageIndicatorTintColor = currentPageDotColor
            }
        }
    }

    /** 其他分页控件小圆标颜色 */
    open var pageDotColor = UIColor.lightGray {
        didSet {
            if let pageControl = pageControl as? UIPageControl {
                pageControl.pageIndicatorTintColor = pageDotColor
            }
        }
    }

    /** 当前分页控件小圆标图片 */
    open var currentPageDotImage: UIImage? {
        didSet {
            if self.pageControlStyle != .animated {
                self.pageControlStyle = .animated
            }
            self.setCustomPageControlDotImage(currentPageDotImage!, isCurrentPageDot: true)
        }
    }

    /** 其他分页控件小圆标图片 */
    open var pageDotImage: UIImage? {
        didSet {
            if self.pageControlStyle != .animated {
                self.pageControlStyle = .animated
            }
            self.setCustomPageControlDotImage(pageDotImage!, isCurrentPageDot: false)
        }
    }

    /** 轮播文字label字体颜色 */
    open var titleLabelTextColor: UIColor = UIColor.white
    /** 轮播文字label字体大小 */
    open var titleLabelTextFont: UIFont = UIFont.systemFont(ofSize: 14)
    /** 轮播文字label背景颜色 */
    open var titleLabelBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    /** 轮播文字label高度 */
    open var titleLabelHeight: CGFloat = 30
    //////////////////////  清除缓存接口  //////////////////////
    /** 清除图片缓存（此次升级后统一使用OOWebImage管理图片加载和缓存）  */

    open class func clearImagesCache() {
        //ImageCache.defaultCache.clearDiskCache()
        ImageCache.default.clearDiskCache()
    }
    /** 清除图片缓存（兼容旧版本方法） */

    open func clearCache() {
        OOCycleScrollView.clearImagesCache()
    }


    override public init(frame: CGRect) {
        super.init(frame: frame)

        self.initialization()
        self.setupMainView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func awakeFromNib() {
        self.initialization()
        self.setupMainView()
    }

    func initialization() {
        self.pageControlAliment = .center
        self.autoScrollTimeInterval = 2.0
        self.titleLabelTextColor = UIColor.white
        self.titleLabelTextFont = UIFont.systemFont(ofSize: 14)
        self.titleLabelBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.titleLabelHeight = 30
        self.autoScroll = true
        self.infiniteLoop = true
        self.showPageControl = true
        self.pageControlDotSize = kCycleScrollViewInitialPageControlDotSize
        self.pageControlBottomOffset = 0
        self.pageControlRightOffset = 0
        self.pageControlStyle = .classic
        self.hidesForSinglePage = true
        self.currentPageDotColor = UIColor.white
        self.pageDotColor = UIColor.lightGray
        self.bannerImageViewContentMode = .scaleToFill
        self.backgroundColor = UIColor.lightGray
    }
    // 设置显示图片的collectionView

    func setupMainView() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.flowLayout = flowLayout
        let mainView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clear
        mainView.isPagingEnabled = true
        mainView.showsHorizontalScrollIndicator = false
        mainView.showsVerticalScrollIndicator = false
        mainView.register(OOCollectionViewCell.self, forCellWithReuseIdentifier: ID)
        mainView.dataSource = self
        mainView.delegate = self
        mainView.scrollsToTop = false
        self.addSubview(mainView)
        self.mainView = mainView
    }

// MARK: - properties


    func setCustomPageControlDotImage(_ image: UIImage, isCurrentPageDot: Bool) {
        if self.pageControl == nil {
            return
        }
        if let pageControl = pageControl as? OOPageControl {
            if isCurrentPageDot {
                pageControl.currentDotImage = image
            }
            else {
                pageControl.dotImage = image
            }
        }
    }

// MARK: - actions


    func setupTimer() {
        let timer: Timer = Timer.scheduledTimer(timeInterval: self.autoScrollTimeInterval, target: self, selector: #selector(self.automaticScroll), userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }

    func invalidateTimer() {
        timer?.invalidate()
        self.timer = nil
    }

    func setupPageControl() {
        if pageControl != nil {
            pageControl!.removeFromSuperview()
        }
        
        if let imagePathsGroup = imagePathsGroup {
            // 重新加载数据时调整
            if imagePathsGroup.count == 0 || self.onlyDisplayText {
                return
            }
            if (imagePathsGroup.count == 1) && self.hidesForSinglePage {
                return
            }
            let indexOnPageControl: Int = self.pageControlIndexWithCurrentCellIndex(self.currentIndex())
            switch self.pageControlStyle {
                case .text:
                    let pageControl: OOTextPageControl = OOTextPageControl()
                    pageControl.numberOfPages = imagePathsGroup.count
                    pageControl.isUserInteractionEnabled = false
                    pageControl.currentPage = indexOnPageControl
                    self.addSubview(pageControl)
                    self.pageControl = pageControl

                case .animated:
                    let pageControl: OOPageControl = OOPageControl()
                    pageControl.numberOfPages = imagePathsGroup.count
                    pageControl.dotColor = self.currentPageDotColor
                    pageControl.isUserInteractionEnabled = false
                    pageControl.currentPage = indexOnPageControl
                    self.addSubview(pageControl)
                    self.pageControl = pageControl

                case .classic:
                    let pageControl: UIPageControl = UIPageControl()
                    pageControl.numberOfPages = imagePathsGroup.count
                    pageControl.currentPageIndicatorTintColor = self.currentPageDotColor
                    pageControl.pageIndicatorTintColor = self.pageDotColor
                    pageControl.isUserInteractionEnabled = false
                    pageControl.currentPage = indexOnPageControl
                    self.addSubview(pageControl)
                    self.pageControl = pageControl

                default:
                    break
            }
        }

        // 重设pagecontroldot图片
        if currentPageDotImage != nil {
            self.currentPageDotImage = (self.currentPageDotImage)
        }
        if (self.pageDotImage != nil) {
            self.pageDotImage = (self.pageDotImage)
        }
    }

    func automaticScroll() {
        if 0 == totalItemsCount || self.imagePathsGroup?.count < 2 {
            return
        }
        let currentIndex: Int = self.currentIndex()
        let targetIndex: Int = currentIndex + 1
        self.scrollToIndex(targetIndex)
    }

    func scrollToIndex(_ targetIndex: Int) {
        var targetIndex = targetIndex
        if targetIndex >= totalItemsCount {
            if self.infiniteLoop {
                targetIndex = Int(Double(totalItemsCount) * 0.5)
                mainView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: UICollectionViewScrollPosition(), animated: false)
            }
            return
        }
        mainView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: UICollectionViewScrollPosition(), animated: true)
    }

    func currentIndex() -> Int {
        if mainView.sd_width == 0 || mainView.sd_height == 0 {
            return 0
        }
        var index: Int = 0
        if flowLayout.scrollDirection == .horizontal {
            index = Int((mainView.contentOffset.x + flowLayout.itemSize.width * 0.5) / flowLayout.itemSize.width)
        }
        else {
            index = Int((mainView.contentOffset.y + flowLayout.itemSize.height * 0.5) / flowLayout.itemSize.height)
        }
        return max(0, index)
    }

    func pageControlIndexWithCurrentCellIndex(_ index: Int) -> Int {
        guard let imagePathsGroup = imagePathsGroup else {
            return 0
        }
        return Int(index) % imagePathsGroup.count
    }

// MARK: - life circles


    override open func layoutSubviews() {
        super.layoutSubviews()
        self.flowLayout.itemSize = self.frame.size
        self.mainView.frame = self.bounds
        if mainView.contentOffset.x == 0 && totalItemsCount != 0 {
            var targetIndex: Int = 0
            if self.infiniteLoop {
                targetIndex = Int(Double(totalItemsCount) * 0.5)
            }
            else {
                targetIndex = 0
            }
            mainView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: UICollectionViewScrollPosition(), animated: false)
        }
        var size: CGSize = CGSize.zero
        let imagePathsGroupCount = imagePathsGroup?.count ?? 0
        if let pageControl = pageControl as? OOPageControl {
            if let _ = self.pageDotImage,let _ = self.currentPageDotImage , kCycleScrollViewInitialPageControlDotSize.equalTo(self.pageControlDotSize) {
                pageControl.dotSize = self.pageControlDotSize
            }
            size = pageControl.sizeForNumberOfPages(imagePathsGroupCount)
        }
        else if (self.pageControl is OOTextPageControl) {
            size = CGSize(width: 52, height: 20)
        }
        else {
            size = CGSize(width: CGFloat(imagePathsGroupCount) * self.pageControlDotSize.width * 1.5, height: self.pageControlDotSize.height)
        }

        var x: CGFloat = (self.sd_width - size.width) * 0.5
        if self.pageControlAliment == .right {
            x = self.mainView.sd_width - size.width - 10
        }
        let y: CGFloat = self.mainView.sd_height - size.height - 10
        if let pageControl = pageControl as? OOPageControl {
            pageControl.sizeToFit()
        }
        var pageControlFrame: CGRect = CGRect(x: x, y: y, width: size.width, height: size.height)
        pageControlFrame.origin.y -= self.pageControlBottomOffset
        pageControlFrame.origin.x -= self.pageControlRightOffset
        self.pageControl?.frame = pageControlFrame
        self.pageControl?.isHidden = !showPageControl
        if (self.backgroundImageView != nil) {
            self.backgroundImageView!.frame = self.bounds
        }
    }
    //解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题

    override open func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            self.invalidateTimer()
        }
    }
    //解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃

    deinit {
        self.mainView.delegate = nil
        self.mainView.dataSource = nil
    }

// MARK: - public actions


// MARK: - UICollectionViewDataSource


    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! OOCollectionViewCell
        let itemIndex: Int = self.pageControlIndexWithCurrentCellIndex((indexPath as NSIndexPath).item)
        let imagePath = self.imagePathsGroup?[itemIndex]
        if let imagePath = imagePath as? String , !self.onlyDisplayText {
            if imagePath.hasPrefix("http") {
                //cell.imageView!.kf_setImageWithURL(URL(string: imagePath)!, placeholderImage: self.placeholderImage)
//                cell.imageView.kf.setImage(with: URL(string: imagePath),placeholder: self.placeholderImage)
                cell.loadImage(url: URL(string: imagePath)!, placeholderImage: placeholderImage)
            }
            else {
                var image = UIImage(named: imagePath)
                if image == nil {
                    image = UIImage(contentsOfFile: imagePath)
                }
                cell.imageView.image = image
            }
        }
        else if !self.onlyDisplayText && (imagePath is UIImage) {
            cell.imageView.image = (imagePath as! UIImage)
        }

        if let titlesGroup = titlesGroup , titlesGroup.count > 0 && itemIndex < titlesGroup.count {
            cell.title = titlesGroup[itemIndex] as! String
        }
        if !cell.hasConfigured {
            cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor
            cell.titleLabelHeight = self.titleLabelHeight
            cell.titleLabelTextColor = self.titleLabelTextColor
            cell.titleLabelTextFont = self.titleLabelTextFont
            cell.hasConfigured = true
            cell.imageView.contentMode = self.bannerImageViewContentMode
            cell.clipsToBounds = true
            cell.onlyDisplayText = self.onlyDisplayText
        }
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = self.delegate?.cycleScrollView?(self, didSelectItemAtIndex: self.pageControlIndexWithCurrentCellIndex((indexPath as NSIndexPath).item)) {
            
        } else if let block = self.clickItemOperationBlock {
            block(self.pageControlIndexWithCurrentCellIndex((indexPath as NSIndexPath).item))
        }
    }

// MARK: - UIScrollViewDelegate


    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let imagePathsGroup = imagePathsGroup,let pageControl = pageControl else { return }
        if imagePathsGroup.isEmpty { return }
        
            // 解决清除timer时偶尔会出现的问题
        let itemIndex: Int = self.currentIndex()
        let indexOnPageControl: Int = self.pageControlIndexWithCurrentCellIndex(itemIndex)
        if let pageControl = pageControl as? OOPageControl {
            pageControl.currentPage = indexOnPageControl
        }
        else if let pageControl = pageControl as? OOTextPageControl {
            pageControl.currentPage = indexOnPageControl
        }
        else if let pageControl = pageControl as? UIPageControl{
            pageControl.currentPage = indexOnPageControl
        }

    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.autoScroll {
            self.invalidateTimer()
        }
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            self.setupTimer()
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(self.mainView)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let imagePathsGroup = imagePathsGroup , imagePathsGroup.count == 0 {
            return
        }
            // 解决清除timer时偶尔会出现的问题
        let itemIndex: Int = self.currentIndex()
        let indexOnPageControl: Int = self.pageControlIndexWithCurrentCellIndex(itemIndex)
        if let _ = self.delegate?.cycleScrollView?(self, didScrollToIndex: indexOnPageControl) {
            
        } else if let block = self.itemDidScrollOperationBlock {
            block(indexOnPageControl)
        }

    }

}
