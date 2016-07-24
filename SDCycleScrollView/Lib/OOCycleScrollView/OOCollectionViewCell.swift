//
//  SDCollectionViewCell.h
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
import UIKit
class OOCollectionViewCell: UICollectionViewCell {
    weak var imageView: UIImageView!
    var title: String = "" {
        didSet {
            self.titleLabel.text = "   \(title)"
            if titleLabel.hidden {
                self.titleLabel.hidden = false
            }
        }
    }

    var titleLabelTextColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.titleLabel.textColor = titleLabelTextColor
        }
    }

    var titleLabelTextFont: UIFont = UIFont.boldSystemFontOfSize(14){
        didSet {
            self.titleLabel.font = titleLabelTextFont
        }
    }

    var titleLabelBackgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            self.titleLabel.backgroundColor = titleLabelBackgroundColor
        }
    }

    var titleLabelHeight: CGFloat!
    var hasConfigured: Bool = false
    /** 只展示文字轮播 */
    var onlyDisplayText: Bool = false
    var titleLabel: UILabel!



    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupImageView()
        self.setupTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupImageView() {
        let imageView = UIImageView()
        self.imageView = imageView
        self.contentView.addSubview(imageView)
    }

    func setupTitleLabel() {
        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        self.titleLabel.hidden = true
        self.contentView.addSubview(titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.onlyDisplayText {
            self.titleLabel.frame = self.bounds
        }
        else {
            self.imageView.frame = self.bounds
            let titleLabelW: CGFloat = self.sd_width
            let titleLabelH: CGFloat = titleLabelHeight
            let titleLabelX: CGFloat = 0
            let titleLabelY: CGFloat = self.sd_height - titleLabelH
            self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)
        }
    }
}