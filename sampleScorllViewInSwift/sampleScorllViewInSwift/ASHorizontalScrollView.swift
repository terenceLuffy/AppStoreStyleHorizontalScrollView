/* ---------------------------------------------------------
 * ASHorizontalScrollView.swift
 * The MIT License (MIT)
 * Copyright (C) 2014-Current WEIWEI CHEN
 * ---------------------------------------------------------
 *  History
 *  Created by WEIWEI CHEN on 14-6-8.
 *  Edit by WEIWEI CHEN 14-9-21: fix problems to work on xcode 6.0.1
 *  Edit by WEIWEI CHEN 15-12-09: change to adapt Swift 2.1, add comments on functions, remove scale when calculating margin, it seems that the behaviour in iOS 9 change the way of align views
 *  Edit by WEIWEI CHEN 16-05-17: change C style code to swift 3 format, fix removeItemAtIndex last index crash bug
 *  Edit by WEIWEI CHEN 16-09-15: Change to adapt Swift 3 with Xcode 8, add support to nib, just change the class on nib file to ASHorizontalScrollView
 *  Edit by WEIWEI CHEN 16-12-02: When current item scroll to more than specified width, auto scroll to next item (mimic App Store behaviour which is about 1/3); add support to all apple screen sizes, now you can specified different mini margin, mini appear width and left margin for all sorts of screen sizes.
 *  Edit by WEIWEI CHEN 17-01-24: Introduce new properties to allow set number of items per screen for multiple screen sizes instead of setting minimum margins, as well as new properties to center subviews when items are not wide enough to use whole screen width
 *  Edit by WEIWEI CHEN 17-03-03: check items size before removing all items
 *  Edit by WEIWEI CHEN 18-10-17: migrate to Swift 4.2 and add settings for iPhone X, Xs, XR and Xs Max landscape support, thanks to Anton Dryakhlykh help on the migration.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * -------------------------------------------------------*/

import UIKit


/// settings for margins
public struct MarginSettings {
    /// the margin between left border and first item
    public var leftMargin:CGFloat = 5.0
    
    /// the mini margin between items, it is the seed to calculate the actual margin which is not less than
    public var miniMarginBetweenItems:CGFloat  = 10.0
    
    /// the mini width appear for last item of current screen, set it 0 if you don't want any part of the last item appear on the right
    public var miniAppearWidthOfLastItem:CGFloat = 20.0
    
    /// number of items per screen, it can be integer like 3, that means total 3 items occupy whole screen, 4.5 means total 4 items and one half item show on the right end. Please note that if numberOfItemsPerScreen is more than screen width, the maximum allowed number of items per screen would be calculated by left margin, and last appeared item percentage which is determined by the fractional number of this value
    public var numberOfItemsPerScreen:Float = 0
    
    public init() { }
    
    
    /// Use this to set margin if arrange type is set by frame
    ///
    /// - Parameters:
    ///   - leftMargin: the margin between left border and first item
    ///   - miniMarginBetweenItems: the mini margin between items, it is the seed to calculate the actual margin which is not less than
    ///   - miniAppearWidthOfLastItem: the mini width appear for last item of current screen, set it 0 if you don't want any part of the last item appear on the right
    public init(leftMargin:CGFloat, miniMarginBetweenItems:CGFloat, miniAppearWidthOfLastItem:CGFloat) {
        self.leftMargin = leftMargin
        self.miniMarginBetweenItems = miniMarginBetweenItems
        self.miniAppearWidthOfLastItem = miniAppearWidthOfLastItem
    }
    
    
    /// Use this to set margin if arrange type is set by number per screen
    ///
    /// - Parameters:
    ///   - leftMargin: the margin between left border and first item
    ///   - numberOfItemsPerScreen: number of items per screen, it can be integer like 3, that means total 3 items occupy whole screen, 4.5 means total 4 items and one half item show on the right end.
    /// - note: if numberOfItemsPerScreen is more than screen width, the maximum allowed number of items per screen would be calculated by left margin, and last appeared item percentage which is determined by the fractional number of this value
    public init(leftMargin:CGFloat, numberOfItemsPerScreen:Float) {
        self.leftMargin = leftMargin
        self.numberOfItemsPerScreen = (numberOfItemsPerScreen >= 0 ? numberOfItemsPerScreen : 0)
    }
}

public enum ArrangeType {
    case byFrame
    case byNumber
}

open class ASHorizontalScrollView: UIScrollView, UIScrollViewDelegate {
    // MARK: - properties
    override open var frame: CGRect{
        didSet{
            itemY = (frame.size.height-self.uniformItemSize.height)/2
            //if width changes, then need to get new margin and reset all views
            if(frame.width != oldValue.width){
                self.refreshSubView()
            }
        }
    }
    
    
    /// whether to arrange items by frame or by number of items, if set by frame, all margin would be calculated by frame size, otherwise, calculated by number of items per screen
    /// - check `numberOfItemsPerScreen` for arranged by number type
    open var arrangeType:ArrangeType = .byFrame
    /// y position of all items
    open var itemY: CGFloat = 0
    /// an array which refer to all added items
    open var items: [UIView] = []
    /// center subviews when items do not occupy whole screen
    public var shouldCenterSubViews:Bool = false
    
    /// the uniform size of all added items, please set it before adding any items, otherwise, default size will be applied
    open var uniformItemSize:CGSize = CGSize.zero {
        didSet{
            itemY = (frame.size.height-self.uniformItemSize.height)/2
        }
    }
    /// the width to move to next item when target point which stops at an item is larger or equal than, default value is 1/3 that means, for example, if scrolling stops at half of an item, auto scroll to next item
    public var widthToScrollNextItem:CGFloat = 1/3
    
    public var marginSettings:MarginSettings {
        get {
            switch UIScreen.main.bounds.width {
            //for portrait
            case 320:
                if let setting = marginSettings_320 {
                    return setting
                }
            case 375:
                if let setting = marginSettings_375 {
                    return setting
                }
            case 414:
                if let setting = marginSettings_414 {
                    return setting
                }
            case 768:
                if let setting = marginSettings_768 {
                    return setting
                }
            case 1024:
                if let setting = marginSettings_1024 {
                    return setting
                }
            //for landscape
            case 480:
                if let setting = marginSettings_480 {
                    return setting
                }
            case 568:
                if let setting = marginSettings_568 {
                    return setting
                }
            case 667:
                if let setting = marginSettings_667 {
                    return setting
                }
            case 736:
                if let setting = marginSettings_736 {
                    return setting
                }
            case 812:
                if let setting = marginSettings_812 {
                    return setting
                }
            case 896:
                if let setting = marginSettings_896 {
                    return setting
                }
            case 1366:
                if let setting = marginSettings_1366 {
                    return setting
                }
            default:
                break
            }
            
            return defaultMarginSettings
        }
    }
    
    /// the default setting used if you don't set other margin settings for specific screen size
    public var defaultMarginSettings = MarginSettings()
    /// for iPhone 5s and lower versions in portrait
    public var marginSettings_320:MarginSettings?
    /// for iPhone 6 and 6s in portrait
    public var marginSettings_375:MarginSettings?
    /// for iPhone 6 plus and 6s plus in portrait
    public var marginSettings_414:MarginSettings?
    /// for ipad in portrait
    public var marginSettings_768:MarginSettings?
    
    /// for iPhone 4s and lower versions in landscape
    public var marginSettings_480:MarginSettings?
    /// for iPhone 5 and 5s in landscape
    public var marginSettings_568:MarginSettings?
    /// for iPhone 6 and 6s in landscape
    public var marginSettings_667:MarginSettings?
    /// for iPhone 6 plus and 6s plus in landscape
    public var marginSettings_736:MarginSettings?
    /// for iPhone X and Xs in landscape
    public var marginSettings_812:MarginSettings?
    /// for iPhone Xs Max and XR in landscape
    public var marginSettings_896:MarginSettings?
    /// for ipad and ipad pro 9.7 in landscape and ipad pro 12.9 portrait
    public var marginSettings_1024:MarginSettings?
    /// for ipad pro 12.9 in landscape
    public var marginSettings_1366:MarginSettings?
    
    /// store the current items' margin
    open var itemsMargin:CGFloat = 10.0
    
    /// the margin between left border and first item
    open var leftMarginPx:CGFloat {
        get {
            return self.marginSettings.leftMargin
        }
    }
    
    /// the mini margin between items, it is the seed to calculate the actual margin which is not less than
    open var miniMarginPxBetweenItems:CGFloat {
        get {
            return self.marginSettings.miniMarginBetweenItems
        }
    }
    
    /// the mini width appear for last item of current screen, set it 0 if you don't want any part of the last item appear on the right
    open var miniAppearPxOfLastItem:CGFloat {
        get {
            return self.marginSettings.miniAppearWidthOfLastItem
        }
    }
    
    /// number of items per screen, it can be integer like 3, that means total 3 items occupy whole screen, 4.5 means total 4 items and one half item show on the right end
    open var numberOfItemsPerScreen:Float {
        get {
            return self.marginSettings.numberOfItemsPerScreen
        }
    }
    
    // MARK: - view init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    fileprivate func initView() {
        //default item size is 80% of height
        self.uniformItemSize = CGSize(width: frame.size.height*0.8, height: frame.size.height*0.8)
        
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.delegate = self
    }
    
    override open func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self) {
            return true
        }
        return false
    }
    // MARK: - methods
    /**
     It re-calculate the item margin to fit in current view frame
     - note: This must be called after changing any size or margin property of this class to get acurrate margin
     - seealso: calculateMarginBetweenItems
     */
    open func setItemsMarginOnce()
    {
        self.itemsMargin = self.calculateMarginBetweenItems();
    }
    
    /// Calculate the exact margin between items
    open func calculateMarginBetweenItems() -> CGFloat
    {
        if self.arrangeType == .byFrame {
            return calculateMarginByFrame()
        }
        else {
            return calculateMarginByNumberPerScreen()
        }
    }
    
    /// Calculate the exact margin by frame
    open func calculateMarginByFrame() -> CGFloat {
        //calculate how many items listed on current screen except the last half appearance one
        let numberOfItemForCurrentWidth = floorf(Float((self.frame.size.width-self.leftMarginPx-self.miniAppearPxOfLastItem)/(self.uniformItemSize.width+self.miniMarginPxBetweenItems)))
        return (self.frame.size.width-self.leftMarginPx-self.miniAppearPxOfLastItem)/CGFloat(numberOfItemForCurrentWidth) - self.uniformItemSize.width
    }
    
    /// Calculate the exact margin by number of items per screen
    open func calculateMarginByNumberPerScreen() -> CGFloat {
        let numOfFull = Int(self.numberOfItemsPerScreen)
        if numOfFull <= 0 {// if margin is not set for this screen width, use calculation by frame instead
            return calculateMarginByFrame()
        }
        let lastItemPercentage = self.numberOfItemsPerScreen - Float(numOfFull)
        var margin = (self.frame.size.width-self.leftMarginPx-self.uniformItemSize.width * CGFloat(lastItemPercentage))/CGFloat(numOfFull) - self.uniformItemSize.width
        if margin <= 0 {//in such case, the number per screen width is larger than the screen width, calculate the max allowed number per screen using the left margin, fractional value of numberOfItemsPerScreen and mini margin between items
            let numberOfItemForCurrentWidth = floorf(Float((self.frame.size.width-self.leftMarginPx-self.uniformItemSize.width * CGFloat(lastItemPercentage))/(self.uniformItemSize.width+self.miniMarginPxBetweenItems)))
            margin = (self.frame.size.width-self.leftMarginPx-self.uniformItemSize.width * CGFloat(lastItemPercentage))/CGFloat(numberOfItemForCurrentWidth) - self.uniformItemSize.width
        }
        
        return margin
    }
    
    /**
     This add a new item into the scrollview
     
     - parameter item: the item you would like to add, it must not be nil.
     */
    open func addItem(_ item:UIView)
    {
        //setup new item size and origin
        if (self.items.count>0) {
            let lastItemRect:CGRect = self.items[self.items.count-1].frame;
            item.frame = CGRect(x: lastItemRect.origin.x + self.uniformItemSize.width + self.itemsMargin, y: itemY, width: self.uniformItemSize.width, height: self.uniformItemSize.height)
        }
        else {
            item.frame = CGRect(x: self.leftMarginPx, y: itemY, width: self.uniformItemSize.width, height: self.uniformItemSize.height)
        }
        
        items.append(item);
        self.addSubview(item);
        // set the content size of scroll view to fit new width and with the same margin as left margin
        self.contentSize = CGSize(width: item.frame.origin.x + self.uniformItemSize.width + self.leftMarginPx, height: self.frame.size.height);
    }
    
    /**
     This add multi new items into the scrollview
     
     - parameter items: the items in array you would like to add, it must not be nil.
     */
    open func addItems(_ items:[UIView])
    {
        for item in items {
            self.addItem(item)
        }
    }
    
    /**
     It removes the specified item from scrollview
     
     - parameter item: the item you would like to remove.
     
     - returns: true if removing successfully.
     */
    open func removeItem(_ item:UIView) -> Bool
    {
        guard let index = self.items.index(of: item) else {
            return false
        }
        
        return self.removeItemAtIndex(index)
    }
    
    /**
     It removes all items from scrollview
     
     - returns: true if removing successfully.
     */
    open func removeAllItems()->Bool
    {
        if self.items.count == 0 {
            return false
        }
        
        for i in (0...self.items.count-1).reversed() {
            let item:UIView = self.items[i]
            item.removeFromSuperview()
        }
        self.items.removeAll(keepingCapacity: false)
        self.contentSize = self.frame.size
        
        return true
    }
    
    /**
     It removes the specified item at index from scrollview
     
     - parameter index: the index of item you would like to remove.
     
     - returns: true if removing successfully.
     */
    open func removeItemAtIndex(_ index:Int)->Bool
    {
        if (index < 0 || index > self.items.count-1) {return false}
        //set new x position from index to the end
        if index != self.items.count-1{
            for i in (index+1...self.items.count-1).reversed() {
                let item:UIView = self.items[i]
                item.frame = CGRect(x: item.frame.minX-self.itemsMargin-self.uniformItemSize.width, y: item.frame.minY, width: item.frame.width, height: item.frame.height)
            }
        }
        
        let item:UIView = self.items[index]
        item.removeFromSuperview()
        self.items.remove(at: index)
        self.contentSize = CGSize(width: self.contentSize.width-self.itemsMargin-self.uniformItemSize.width, height: self.frame.size.height)
        
        return true
    }
    
    /// Refresh all subviews for changing size of current frame
    public func refreshSubView()
    {
        self.setItemsMarginOnce();
        var itemX = self.leftMarginPx
        if self.shouldCenterSubViews {
            itemX = centerSubviews()
        }
        else {
            itemX = self.reorderSubViews()
        }
        self.contentSize = CGSize(width: itemX, height: self.frame.size.height)
    }
    
    private func reorderSubViews() -> CGFloat {
        var itemX = self.leftMarginPx
        for item in self.items
        {
            item.frame = CGRect(x: itemX, y: item.frame.origin.y, width: item.frame.width, height: item.frame.height)
            itemX += item.frame.width + self.itemsMargin
        }
        
        return itemX - self.itemsMargin + self.leftMarginPx;
    }
    
    
    /// center subviews if all items can not fully occupy whole screen width
    ///
    /// - Returns: the scroll view content width
    public func centerSubviews() -> CGFloat{
        if let itemLastX = self.items.last?.frame.maxX {
            if itemLastX + self.leftMarginPx < self.frame.size.width {
                let extraGap = (self.frame.size.width - (self.itemsMargin + self.uniformItemSize.width) * CGFloat(self.items.count) + self.itemsMargin - self.leftMarginPx * 2) / 2
                var itemX = self.leftMarginPx + extraGap
                for item in self.items
                {
                    item.frame = CGRect(x: itemX, y: item.frame.origin.y, width: item.frame.width, height: item.frame.height)
                    itemX += item.frame.width + self.itemsMargin
                }
                return itemX - self.itemsMargin + self.leftMarginPx + extraGap;
            }
            return self.reorderSubViews()
        }
        return 0
    }
    
    // MARK: - ScrollView delegates
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset:CGPoint = targetContentOffset.pointee;
        //move to closest item
        if (targetOffset.x + scrollView.frame.size.width < scrollView.contentSize.width) {
            targetContentOffset.pointee.x = self.getClosestItemByX(position:targetOffset.x, inScrollView:(scrollView as! ASHorizontalScrollView)) - (scrollView as! ASHorizontalScrollView).leftMarginPx;
        }
    }
    
    fileprivate func getClosestItemByX(position xPosition:CGFloat, inScrollView scrollView:ASHorizontalScrollView) -> CGFloat
    {
        //get current cloest item on the left side
        var index = (Int)((xPosition - scrollView.leftMarginPx)/(scrollView.itemsMargin+scrollView.uniformItemSize.width))
        if index < 0 {
            index = 0
        }
        var item:UIView = scrollView.items[index]
        //check if target position is over widthToScrollNextItem of current left item, if so, move to next item
        if (xPosition-item.frame.origin.x > item.frame.size.width * widthToScrollNextItem) {
            item = scrollView.items[index+1]
        }
        
        return item.frame.origin.x
    }
    
    
}
