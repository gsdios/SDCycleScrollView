//
//  TAAnimatedDotView.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

import UIKit

let kAnimateDuration: TimeInterval = 1

class OOAnimatedDotView: OOAbstractDotView {
    var dotColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = dotColor.cgColor
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
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    }

    override func changeActivityState(_ active: Bool) {
        if active {
            self.animateToActiveState()
        }
        else {
            self.animateToDeactiveState()
        }
    }

    func animateToActiveState() {
        UIView.animate(withDuration: kAnimateDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -20, options: .curveLinear, animations: {() -> Void in
            self.backgroundColor = self.dotColor
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: { _ in })
    }

    func animateToDeactiveState() {
        UIView.animate(withDuration: kAnimateDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear, animations: {() -> Void in
            self.backgroundColor = UIColor.clear
            self.transform = CGAffineTransform.identity
        }, completion: { _ in })
    }
}
