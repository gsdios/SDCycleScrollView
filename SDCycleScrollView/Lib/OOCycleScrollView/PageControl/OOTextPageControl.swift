//
//  TATextPageControl.h
//  SDCycleScrollView
//
//  Created by lee on 16/7/18.
//  Copyright © 2016年 GSD. All rights reserved.
//
import UIKit
class OOTextPageControl: UIControl {
    /**
     *  Number of pages for control. Default is 0.
     */
    var numberOfPages: Int = 0
    /**
     *  Current page on which control is active. Default is 0.
     */
    var currentPage: Int = 0 {
        didSet {
            self.textPage.textAlignment = numberOfPages > 9 ? .right : .center
            let info: NSMutableAttributedString = NSMutableAttributedString(string: String(format: "%-2ld", Int(currentPage) + 1), attributes: [NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 10)!])
//            info.appendAttributedString(String("/\(Int(numberOfPages))"))
            info.append(NSAttributedString(string: "/\(numberOfPages)"))
            self.textPage.attributedText = info
        }
    }

    weak var delegate: OOPageControlDelegate?


    init() {
        super.init(frame:CGRect.zero)
        
        self.initialization()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialization()
    }

    func initialization() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        self.layer.masksToBounds = true
        self.textPage = UILabel(frame: CGRect(x: 13.5, y: 0, width: 25, height: 20))
        self.textPage.textAlignment = .left
        self.textPage.font = UIFont.systemFont(ofSize: 8)
        self.textPage.textColor = UIColor.white
        self.addSubview(textPage)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.height / 2
    }

    var textPage: UILabel!
}
//
//  TATextPageControl.m
//  SDCycleScrollView
//
//  Created by lee on 16/7/18.
//  Copyright © 2016年 GSD. All rights reserved.
//
