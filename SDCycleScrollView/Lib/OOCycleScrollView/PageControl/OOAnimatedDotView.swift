//
//  TAAnimatedDotView.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

let kAnimateDuration: NSTimeInterval = 1

class OOAnimatedDotView: OOAbstractDotView {
    var dotColor: UIColor {
        get {
            return self.dotColor
        }
        set(dotColor) {
            self.dotColor = dotColor
            self.layer.borderColor = dotColor.CGColor
        }
    }


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
        self.dotColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2
    }

    override func changeActivityState(active: Bool) {
        if active {
            self.animateToActiveState()
        }
        else {
            self.animateToDeactiveState()
        }
    }

    func animateToActiveState() {
        UIView.animateWithDuration(kAnimateDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -20, options: .CurveLinear, animations: {() -> Void in
            self.backgroundColor = self.dotColor
            self.transform = CGAffineTransformMakeScale(1.4, 1.4)
        }, completion: { _ in })
    }

    func animateToDeactiveState() {
        UIView.animateWithDuration(kAnimateDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .CurveLinear, animations: {() -> Void in
            self.backgroundColor = UIColor.clearColor()
            self.transform = CGAffineTransformIdentity
        }, completion: { _ in })
    }
}