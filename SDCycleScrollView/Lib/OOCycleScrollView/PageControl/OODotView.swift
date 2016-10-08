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
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
    }

    override func changeActivityState(_ active: Bool) {
        if active {
            self.backgroundColor = UIColor.white
        }
        else {
            self.backgroundColor = UIColor.clear
        }
    }
}
