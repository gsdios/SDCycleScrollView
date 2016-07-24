//
//  TAAbstractDotView.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//
import UIKit
class OOAbstractDotView: UIView {
    /**
     *  A method call let view know which state appearance it should take. Active meaning it's current page. Inactive not the current page.
     *
     *  @param active BOOL to tell if view is active or not
     */
    func changeActivityState(active: Bool) {
//        NSException.exceptionWithName(NSInternalInconsistencyException, reason: "You must override \(NSStringFromSelector(cmd)) in \(self.self)", userInfo: nil)
    }
    
    init() {
        super.init(frame: CGRectZero)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}
//
//  TAAbstractDotView.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-22.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//