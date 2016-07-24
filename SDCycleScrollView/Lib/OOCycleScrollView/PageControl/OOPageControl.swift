//
//  TAPageControl.h
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-21.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//
import UIKit

//
/**
 *  Default number of pages for initialization
 */
let kDefaultNumberOfPages: Int = 0

/**
 *  Default current page for initialization
 */
let kDefaultCurrentPage: Int = 0

/**
 *  Default setting for hide for single page feature. For initialization
 */
let kDefaultHideForSinglePage: Bool = false

/**
 *  Default setting for shouldResizeFromCenter. For initialiation
 */
let kDefaultShouldResizeFromCenter: Bool = true

/**
 *  Default spacing between dots
 */
let kDefaultSpacingBetweenDots: Int = 8

/**
 *  Default dot size
 */
let kDefaultDotSize: CGSize = CGSizeMake(8, 8)

@objc protocol OOPageControlDelegate : NSObjectProtocol {
    optional func pageControl(pageControl: OOPageControl , didSelectPageAtIndex index: Int)
}
class OOPageControl : UIControl {
    
    /**
     * Dot view customization properties
     */
    /**
     *  The Class of your custom UIView, make sure to respect the TAAbstractDotView class.
     */
    var dotViewClass: AnyClass? = OOAbstractDotView.self {
        didSet {
            self.dotSize = CGSizeZero
            self.resetDotViews()
        }
    }

    /**
     *  UIImage to represent a dot.
     */
    var dotImage: UIImage? {
        didSet {
            self.resetDotViews()
            self.dotViewClass = nil
        }
    }

    /**
     *  UIImage to represent current page dot.
     */
    var currentDotImage: UIImage? {
        didSet {
            self.resetDotViews()
            self.dotViewClass = nil
        }
    }

    /**
     *  Dot size for dot views. Default is 8 by 8.
     */
    var _dotSize = kDefaultDotSize
    var dotSize: CGSize {
        get {
            // Dot size logic depending on the source of the dot view
            if self.dotImage != nil && CGSizeEqualToSize(self._dotSize, CGSizeZero) {
                self._dotSize = self.dotImage!.size
            }
            else if self.dotViewClass != nil && CGSizeEqualToSize(self._dotSize, CGSizeZero) {
                self._dotSize = kDefaultDotSize
                return self._dotSize
            }
    
            return self._dotSize
        }
        set {
            self._dotSize = newValue
        }
    }

    var dotColor = UIColor.whiteColor()
    /**
     *  Spacing between two dot views. Default is 8.
     */
    var spacingBetweenDots: Int = kDefaultSpacingBetweenDots{
        didSet {
            self.resetDotViews()
        }
    }

    /**
     * Page control setup properties
     */
    /**
     * Delegate for TAPageControl
     */
    weak var delegate: OOPageControlDelegate?
    /**
     *  Number of pages for control. Default is 0.
     */
    var numberOfPages: Int = kDefaultNumberOfPages{
        didSet {
            // Update dot position to fit new number of pages
            self.resetDotViews()
        }
    }

    /**
     *  Current page on which control is active. Default is 0.
     */
    var currentPage: Int = kDefaultCurrentPage {
        willSet {
            // If no pages, no current page to treat.
            if self.numberOfPages == 0 || currentPage == newValue {
                return
            }
            self.changeActivity(false, atIndex: currentPage)
        }
        didSet {
            self.changeActivity(true, atIndex: currentPage)
        }
    }

    /**
     *  Hide the control if there is only one page. Default is NO.
     */
    var hidesForSinglePage: Bool = kDefaultHideForSinglePage
    /**
     *  Let the control know if should grow bigger by keeping center, or just get longer (right side expanding). By default YES.
     */
    var shouldResizeFromCenter: Bool = kDefaultShouldResizeFromCenter
    
    /**
     *  Array of dot views for reusability and touch events.
     */
    var dots = [UIView]()
    
    /**
     *  Return the minimum size required to display control properly for the given page count.
     *
     *  @param pageCount Number of dots that will require display
     *
     *  @return The CGSize being the minimum size required.
     */

    func sizeForNumberOfPages(pageCount: Int) -> CGSize {
        return CGSizeMake((self.dotSize.width + CGFloat(self.spacingBetweenDots)) * CGFloat(pageCount) - CGFloat(self.spacingBetweenDots), self.dotSize.height)
    }


// MARK: - Lifecycle


    init() {
        super.init(frame: CGRectZero)
        
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
    /**
     *  Default setup when initiating control
     */

    func initialization() {
        self.dotViewClass = OOAnimatedDotView.self
        self.spacingBetweenDots = kDefaultSpacingBetweenDots
        self.numberOfPages = kDefaultNumberOfPages
        self.currentPage = kDefaultCurrentPage
    }

// MARK: - Touch event


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        if touch.view != self {
            let index: Int = self.dots.indexOf(touch.view!)!
            self.delegate?.pageControl?(self, didSelectPageAtIndex: index)
        }
    }

// MARK: - Layout

    /**
     *  Resizes and moves the receiver view so it just encloses its subviews.
     */

    override func sizeToFit() {
        self.updateFrame(true)
    }
    /**
     *  Will update dots display and frame. Reuse existing views or instantiate one if required. Update their position in case frame changed.
     */

    func updateDots() {
        if self.numberOfPages == 0 {
            return
        }
        for i in 0..<self.numberOfPages {
            var dot: UIView
            if i < self.dots.count {
                dot = self.dots[i]
            }
            else {
                dot = self.generateDotView()
            }
            self.updateDotFrame(dot, atIndex: i)
        }
        self.changeActivity(true, atIndex: self.currentPage)
        self.hideForSinglePage()
    }
    /**
     *  Update frame control to fit current number of pages. It will apply required size if authorize and required.
     *
     *  @param overrideExistingFrame BOOL to allow frame to be overriden. Meaning the required size will be apply no mattter what.
     */

    func updateFrame(overrideExistingFrame: Bool) {
        let center: CGPoint = self.center
        let requiredSize: CGSize = self.sizeForNumberOfPages(self.numberOfPages)
        // We apply requiredSize only if authorize to and necessary
        if overrideExistingFrame || ((CGRectGetWidth(self.frame) < requiredSize.width || CGRectGetHeight(self.frame) < requiredSize.height) && !overrideExistingFrame) {
            self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), requiredSize.width, requiredSize.height)
            if self.shouldResizeFromCenter {
                self.center = center
            }
        }
        self.resetDotViews()
    }
    /**
     *  Update the frame of a specific dot at a specific index
     *
     *  @param dot   Dot view
     *  @param index Page index of dot
     */

    func updateDotFrame(dot: UIView, atIndex index: Int) {
            // Dots are always centered within view
        let x: CGFloat = (self.dotSize.width + CGFloat(self.spacingBetweenDots)) * CGFloat(index) + ((CGRectGetWidth(self.frame) - self.sizeForNumberOfPages(self.numberOfPages).width) / 2)
        let y: CGFloat = (CGRectGetHeight(self.frame) - self.dotSize.height) / 2
        dot.frame = CGRectMake(x, y, self.dotSize.width, self.dotSize.height)
    }

// MARK: - Utils

    /**
     *  Generate a dot view and add it to the collection
     *
     *  @return The UIView object representing a dot
     */

    func generateDotView() -> UIView {
        var dotView: UIView
        if let dotViewClass = dotViewClass {
            dotView = (dotViewClass as! UIView.Type).init(frame: CGRectMake(0, 0, dotSize.width, dotSize.height))
            if dotView is OOAnimatedDotView {
                (dotView as! OOAnimatedDotView).dotColor = dotColor
            }
        }
        else {
            dotView = UIImageView(image: self.dotImage)
            dotView.frame = CGRectMake(0, 0, self.dotSize.width, self.dotSize.height)
        }
//        if dotView != nil {
        self.addSubview(dotView)
        self.dots.append(dotView)
//        }
        dotView.userInteractionEnabled = true
        return dotView
    }
    /**
     *  Change activity state of a dot view. Current/not currrent.
     *
     *  @param active Active state to apply
     *  @param index  Index of dot for state update
     */

    func changeActivity(active: Bool, atIndex index: Int) {
        if let abstractDotView = self.dots[index] as? OOAbstractDotView {
            if abstractDotView.respondsToSelector(#selector(OOAbstractDotView.changeActivityState)) {
                abstractDotView.changeActivityState(active)
            }
            else {
                print("Custom view : \(self.dotViewClass) must implement an 'changeActivityState' method or you can subclass \(OOAbstractDotView.self) to help you.")
            }
        }
        else if let dotImage = self.dotImage , currentDotImage = self.currentDotImage {
            let dotView: UIImageView = (self.dots[index] as! UIImageView)
            dotView.image = (active) ? currentDotImage : dotImage
        }

    }

    func resetDotViews() {
        for dotView: UIView in self.dots {
            dotView.removeFromSuperview()
        }
        self.dots.removeAll()
        self.updateDots()
    }

    func hideForSinglePage() {
        if self.dots.count == 1 && self.hidesForSinglePage {
            self.hidden = true
        }
        else {
            self.hidden = false
        }
    }


}