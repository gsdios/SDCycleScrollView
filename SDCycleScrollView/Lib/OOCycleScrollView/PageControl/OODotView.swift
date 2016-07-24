//
//  TADotView.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//
import UIKit

class OODotView: OOAbstractDotView {


    override init() {
        super.init()
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
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2
    }

    override func changeActivityState(active: Bool) {
        if active {
            self.backgroundColor = UIColor.whiteColor()
        }
        else {
            self.backgroundColor = UIColor.clearColor()
        }
    }
}