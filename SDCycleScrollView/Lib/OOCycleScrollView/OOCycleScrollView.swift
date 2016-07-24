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

let kCycleScrollViewInitialPageControlDotSize = CGSizeMake(10, 10)
let ID: String = "cycleCell"
public enum OOCycleScrollViewPageContolAliment : Int {
    case Right
    case Center
}

public enum OOCycleScrollViewPageContolStyle : Int {
    case Classic
    // 系统自带经典样式
    case Animated
    // 动画效果pagecontrol
    case Text
    // 文字
    case None
}

@objc public protocol OOCycleScrollViewDelegate : NSObjectProtocol {
    /** 点击图片回调 */
    optional func cycleScrollView(cycleScrollView: OOCycleScrollView, didSelectItemAtIndex index: Int)
    /** 图片滚动回调 */

    optional func cycleScrollView(cycleScrollView: OOCycleScrollView, didScrollToIndex index: Int)
}
public class OOCycleScrollView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    /** 初始轮播图（推荐使用） */
    public class func cycleScrollViewWithFrame(frame: CGRect, delegate: OOCycleScrollViewDelegate, placeholderImage: UIImage) -> OOCycleScrollView {
        let cycleScrollView = OOCycleScrollView(frame: frame)
        cycleScrollView.delegate = delegate
        cycleScrollView.placeholderImage = placeholderImage
        return cycleScrollView
    }

    public class func cycleScrollViewWithFrame(frame: CGRect, imageURLStringsGroup imageURLsGroup: [AnyObject]) -> OOCycleScrollView {
        let cycleScrollView = OOCycleScrollView(frame: frame)
        cycleScrollView.imageURLStringsGroup = [AnyObject](imageURLsGroup)
        return cycleScrollView
    }
    /** 本地图片轮播初始化方式 */

    public class func cycleScrollViewWithFrame(frame: CGRect, imageNamesGroup: [AnyObject]) -> OOCycleScrollView {
        let cycleScrollView = OOCycleScrollView(frame: frame)
        cycleScrollView.localizationImageNamesGroup = [AnyObject](imageNamesGroup)
        return cycleScrollView
    }
    /** 本地图片轮播初始化方式2,infiniteLoop:是否无限循环 */

    public class func cycleScrollViewWithFrame(frame: CGRect, shouldInfiniteLoop infiniteLoop: Bool, imageNamesGroup: [AnyObject]) -> OOCycleScrollView {
        let cycleScrollView = OOCycleScrollView(frame: frame)
        cycleScrollView.infiniteLoop = infiniteLoop
        cycleScrollView.localizationImageNamesGroup = [AnyObject](imageNamesGroup)
        return cycleScrollView
    }
    //////////////////////  数据源接口  //////////////////////
    /** 网络图片 url string 数组 */
    public var imageURLStringsGroup: [AnyObject]? {
        didSet {
            if let imageURLStringsGroup = imageURLStringsGroup {
                self.imagePathsGroup = imageURLStringsGroup.map {
                    $0 is String ? $0 as! String : ($0 as! NSURL).absoluteString
                }.filter { !$0.isEmpty }
            }
        }
    }

    /** 每张图片对应要显示的文字数组 */
    public var titlesGroup: [AnyObject]? {
        didSet {
            if let titlesGroup = titlesGroup where self.onlyDisplayText {
                self.backgroundColor = UIColor.clearColor()
                self.imageURLStringsGroup = [AnyObject](count: titlesGroup.count,repeatedValue:"")
            }
        }
    }

    /** 本地图片数组 */
    public var localizationImageNamesGroup: [AnyObject]? {
        didSet {
            self.imagePathsGroup = localizationImageNamesGroup
        }
    }

    //////////////////////  滚动控制接口 //////////////////////
    /** 自动滚动间隔时间,默认2s */
    public var autoScrollTimeInterval: NSTimeInterval = 2 {
        didSet {
            self.autoScroll = (self.autoScroll);
        }
    }

    /** 是否无限循环,默认Yes */
    public var infiniteLoop: Bool = true {
        didSet {
            if self.imagePathsGroup != nil {
                self.imagePathsGroup = (self.imagePathsGroup)
            }
        }
    }

    /** 是否自动滚动,默认Yes */
    public var autoScroll: Bool = true {
        didSet {
            self.invalidateTimer()
            if autoScroll {
                self.setupTimer()
            }
        }
    }

    /** 图片滚动方向，默认为水平滚动 */
    public var scrollDirection: UICollectionViewScrollDirection = .Horizontal {
        didSet {
            self.flowLayout.scrollDirection = scrollDirection
        }
    }

    public weak var delegate: OOCycleScrollViewDelegate?
    /** block方式监听点击 */
    var clickItemOperationBlock: ((Int)->Void)?
    /** block方式监听滚动 */
    public var itemDidScrollOperationBlock: ((Int)->Void)?
    /** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
    
    public weak var mainView: UICollectionView!
    // 显示图片的collectionView
    public weak var flowLayout: UICollectionViewFlowLayout!
    public var imagePathsGroup: [AnyObject]? {
        didSet {
            self.invalidateTimer()
            if let imagePathsGroup = imagePathsGroup {
                self.totalItemsCount = self.infiniteLoop ? imagePathsGroup.count * 100 : imagePathsGroup.count
                if imagePathsGroup.count != 1 {
                    self.mainView.scrollEnabled = true
                    self.autoScroll = (self.autoScroll)
                }
                else {
                    self.mainView.scrollEnabled = false
                }
            }
            self.setupPageControl()
            self.mainView.reloadData()
        }
    }
    
    weak var timer: NSTimer?
    var totalItemsCount: Int = 0
    weak var pageControl: UIControl?
    var backgroundImageView: UIImageView?
    
    func adjustWhenControllerViewWillAppera() {
        let targetIndex: Int = self.currentIndex()
        if targetIndex < totalItemsCount {
            mainView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: false)
        }
    }
    //////////////////////  自定义样式接口  //////////////////////
    /** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
    public var bannerImageViewContentMode: UIViewContentMode = .ScaleToFill
    /** 占位图，用于网络未加载到图片时 */
    public var placeholderImage: UIImage? {
        didSet {
            if self.backgroundImageView == nil {
                let bgImageView: UIImageView = UIImageView()
                bgImageView.contentMode = .ScaleAspectFit
                self.insertSubview(bgImageView, belowSubview: self.mainView)
                self.backgroundImageView = bgImageView
            }
            self.backgroundImageView!.image = placeholderImage
        }
    }

    /** 是否显示分页控件 */
    public var showPageControl: Bool = true {
        didSet {
            self.pageControl?.hidden = !showPageControl
        }
    }

    /** 是否在只有一张图时隐藏pagecontrol，默认为YES */
    public var hidesForSinglePage = true
    /** 只展示文字轮播 */
    public var onlyDisplayText = false
    /** pagecontrol 样式，默认为动画样式 */
    public var pageControlStyle: OOCycleScrollViewPageContolStyle = .Classic {
        didSet {
            self.setupPageControl()
        }
    }

    /** 分页控件位置 */
    public var pageControlAliment: OOCycleScrollViewPageContolAliment = .Center
    /** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
    public var pageControlBottomOffset: CGFloat = 0
    /** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
    public var pageControlRightOffset: CGFloat = 0
    /** 分页控件小圆标大小 */
    public var pageControlDotSize: CGSize = CGSizeMake(8, 8) {
        didSet {
            self.setupPageControl()
            if let pageControl = pageControl as? OOPageControl {
                pageControl.dotSize = pageControlDotSize
            }
        }
    }

    /** 当前分页控件小圆标颜色 */
    public var currentPageDotColor = UIColor.whiteColor() {
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
    public var pageDotColor = UIColor.lightGrayColor() {
        didSet {
            if let pageControl = pageControl as? UIPageControl {
                pageControl.pageIndicatorTintColor = pageDotColor
            }
        }
    }

    /** 当前分页控件小圆标图片 */
    public var currentPageDotImage: UIImage? {
        didSet {
            if self.pageControlStyle != .Animated {
                self.pageControlStyle = .Animated
            }
            self.setCustomPageControlDotImage(currentPageDotImage!, isCurrentPageDot: true)
        }
    }

    /** 其他分页控件小圆标图片 */
    public var pageDotImage: UIImage? {
        didSet {
            if self.pageControlStyle != .Animated {
                self.pageControlStyle = .Animated
            }
            self.setCustomPageControlDotImage(pageDotImage!, isCurrentPageDot: false)
        }
    }

    /** 轮播文字label字体颜色 */
    public var titleLabelTextColor: UIColor = UIColor.whiteColor()
    /** 轮播文字label字体大小 */
    public var titleLabelTextFont: UIFont = UIFont.systemFontOfSize(14)
    /** 轮播文字label背景颜色 */
    public var titleLabelBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    /** 轮播文字label高度 */
    public var titleLabelHeight: CGFloat = 30
    //////////////////////  清除缓存接口  //////////////////////
    /** 清除图片缓存（此次升级后统一使用OOWebImage管理图片加载和缓存）  */

    public class func clearImagesCache() {
        ImageCache.defaultCache.clearDiskCache()
    }
    /** 清除图片缓存（兼容旧版本方法） */

    public func clearCache() {
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

    override public func awakeFromNib() {
        self.initialization()
        self.setupMainView()
    }

    func initialization() {
        self.pageControlAliment = .Center
        self.autoScrollTimeInterval = 2.0
        self.titleLabelTextColor = UIColor.whiteColor()
        self.titleLabelTextFont = UIFont.systemFontOfSize(14)
        self.titleLabelBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.titleLabelHeight = 30
        self.autoScroll = true
        self.infiniteLoop = true
        self.showPageControl = true
        self.pageControlDotSize = kCycleScrollViewInitialPageControlDotSize
        self.pageControlBottomOffset = 0
        self.pageControlRightOffset = 0
        self.pageControlStyle = .Classic
        self.hidesForSinglePage = true
        self.currentPageDotColor = UIColor.whiteColor()
        self.pageDotColor = UIColor.lightGrayColor()
        self.bannerImageViewContentMode = .ScaleToFill
        self.backgroundColor = UIColor.lightGrayColor()
    }
    // 设置显示图片的collectionView

    func setupMainView() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        self.flowLayout = flowLayout
        let mainView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clearColor()
        mainView.pagingEnabled = true
        mainView.showsHorizontalScrollIndicator = false
        mainView.showsVerticalScrollIndicator = false
        mainView.registerClass(OOCollectionViewCell.self, forCellWithReuseIdentifier: ID)
        mainView.dataSource = self
        mainView.delegate = self
        mainView.scrollsToTop = false
        self.addSubview(mainView)
        self.mainView = mainView
    }

// MARK: - properties


    func setCustomPageControlDotImage(image: UIImage, isCurrentPageDot: Bool) {
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
        let timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(self.autoScrollTimeInterval, target: self, selector: #selector(self.automaticScroll), userInfo: nil, repeats: true)
        self.timer = timer
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
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
                case .Text:
                    let pageControl: OOTextPageControl = OOTextPageControl()
                    pageControl.numberOfPages = imagePathsGroup.count
                    pageControl.userInteractionEnabled = false
                    pageControl.currentPage = indexOnPageControl
                    self.addSubview(pageControl)
                    self.pageControl = pageControl

                case .Animated:
                    let pageControl: OOPageControl = OOPageControl()
                    pageControl.numberOfPages = imagePathsGroup.count
                    pageControl.dotColor = self.currentPageDotColor
                    pageControl.userInteractionEnabled = false
                    pageControl.currentPage = indexOnPageControl
                    self.addSubview(pageControl)
                    self.pageControl = pageControl

                case .Classic:
                    let pageControl: UIPageControl = UIPageControl()
                    pageControl.numberOfPages = imagePathsGroup.count
                    pageControl.currentPageIndicatorTintColor = self.currentPageDotColor
                    pageControl.pageIndicatorTintColor = self.pageDotColor
                    pageControl.userInteractionEnabled = false
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
        if 0 == totalItemsCount {
            return
        }
        let currentIndex: Int = self.currentIndex()
        let targetIndex: Int = currentIndex + 1
        self.scrollToIndex(targetIndex)
    }

    func scrollToIndex(targetIndex: Int) {
        var targetIndex = targetIndex
        if targetIndex >= totalItemsCount {
            if self.infiniteLoop {
                targetIndex = Int(Double(totalItemsCount) * 0.5)
                mainView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: false)
            }
            return
        }
        mainView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: true)
    }

    func currentIndex() -> Int {
        if mainView.sd_width == 0 || mainView.sd_height == 0 {
            return 0
        }
        var index: Int = 0
        if flowLayout.scrollDirection == .Horizontal {
            index = Int((mainView.contentOffset.x + flowLayout.itemSize.width * 0.5) / flowLayout.itemSize.width)
        }
        else {
            index = Int((mainView.contentOffset.y + flowLayout.itemSize.height * 0.5) / flowLayout.itemSize.height)
        }
        return max(0, index)
    }

    func pageControlIndexWithCurrentCellIndex(index: Int) -> Int {
        guard let imagePathsGroup = imagePathsGroup else {
            return 0
        }
        return Int(index) % imagePathsGroup.count
    }

// MARK: - life circles


    override public func layoutSubviews() {
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
            mainView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: false)
        }
        var size: CGSize = CGSizeZero
        let imagePathsGroupCount = imagePathsGroup?.count ?? 0
        if let pageControl = pageControl as? OOPageControl {
            if let _ = self.pageDotImage,_ = self.currentPageDotImage where CGSizeEqualToSize(kCycleScrollViewInitialPageControlDotSize, self.pageControlDotSize) {
                pageControl.dotSize = self.pageControlDotSize
            }
            size = pageControl.sizeForNumberOfPages(imagePathsGroupCount)
        }
        else if (self.pageControl is OOTextPageControl) {
            size = CGSizeMake(52, 20)
        }
        else {
            size = CGSizeMake(CGFloat(imagePathsGroupCount) * self.pageControlDotSize.width * 1.5, self.pageControlDotSize.height)
        }

        var x: CGFloat = (self.sd_width - size.width) * 0.5
        if self.pageControlAliment == .Right {
            x = self.mainView.sd_width - size.width - 10
        }
        let y: CGFloat = self.mainView.sd_height - size.height - 10
        if let pageControl = pageControl as? OOPageControl {
            pageControl.sizeToFit()
        }
        var pageControlFrame: CGRect = CGRectMake(x, y, size.width, size.height)
        pageControlFrame.origin.y -= self.pageControlBottomOffset
        pageControlFrame.origin.x -= self.pageControlRightOffset
        self.pageControl?.frame = pageControlFrame
        self.pageControl?.hidden = !showPageControl
        if (self.backgroundImageView != nil) {
            self.backgroundImageView!.frame = self.bounds
        }
    }
    //解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题

    override public func willMoveToSuperview(newSuperview: UIView?) {
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


    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as! OOCollectionViewCell
        let itemIndex: Int = self.pageControlIndexWithCurrentCellIndex(indexPath.item)
        let imagePath = self.imagePathsGroup?[itemIndex]
        if let imagePath = imagePath as? String where !self.onlyDisplayText {
            if imagePath.hasPrefix("http") {
                cell.imageView!.kf_setImageWithURL(NSURL(string: imagePath)!, placeholderImage: self.placeholderImage)
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

        if let titlesGroup = titlesGroup where titlesGroup.count > 0 && itemIndex < titlesGroup.count {
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

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.delegate?.cycleScrollView?(self, didSelectItemAtIndex: self.pageControlIndexWithCurrentCellIndex(indexPath.item)) {
            
        } else if let block = self.clickItemOperationBlock {
            block(self.pageControlIndexWithCurrentCellIndex(indexPath.item))
        }
    }

// MARK: - UIScrollViewDelegate


    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if let imagePathsGroup = imagePathsGroup where imagePathsGroup.count == 0 {
            return
        }
            // 解决清除timer时偶尔会出现的问题
        let itemIndex: Int = self.currentIndex()
        let indexOnPageControl: Int = self.pageControlIndexWithCurrentCellIndex(itemIndex)
        if let pageControl = pageControl as? OOPageControl {
            pageControl.currentPage = indexOnPageControl
        }
        else if let pageControl = pageControl as? OOTextPageControl {
            pageControl.currentPage = indexOnPageControl
        }
        else {
            let pageControl: UIPageControl = self.pageControl as! UIPageControl
            pageControl.currentPage = indexOnPageControl
        }

    }

    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.autoScroll {
            self.invalidateTimer()
        }
    }

    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            self.setupTimer()
        }
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(self.mainView)
    }

    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if let imagePathsGroup = imagePathsGroup where imagePathsGroup.count == 0 {
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
