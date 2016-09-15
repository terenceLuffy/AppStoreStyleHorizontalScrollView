/* ---------------------------------------------------------
* ASHorizontalScrollView.swift
* The MIT License (MIT)
* Copyright (C) 2014-2016 WEIWEI CHEN
* ---------------------------------------------------------
*  History
*  Created by WEIWEI CHEN on 14-6-8.
*  Edit by WEIWEI CHEN 14-9-21: fix problems to work on xcode 6.0.1
*  Edit by WEIWEI CHEN 15-12-09: change to adapt Swift 2.1, add comments on functions, remove scale when calculating margin, it seems that the behaviour in iOS 9 change the way of align views
*  Edit by WEIWEI CHEN 16-05-17: change C style code to swift 3 format, fix removeItemAtIndex last index crash bug
*  Edit by WEIWEI CHEN 16-09-15: Change to adapt Swift 3 with Xcode 8, add support to nib, just change the class on nib file to ASHorizontalScrollView
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* -------------------------------------------------------*/

import UIKit

open class ASHorizontalScrollView: UIScrollView, UIScrollViewDelegate {
    let scale = UIScreen.main.scale
    
    override open var frame: CGRect{
        didSet{
            itemY = (frame.size.height-self.uniformItemSize.height)/2
            //if width changes, then need to get new margin and reset all views
            if(frame.width != oldValue.width){
                self.refreshSubView()
            }
        }
    }
    /// y position of all items
    open var itemY: CGFloat = 0
    /// an array which refer to all added items
    open var items: Array<UIView> = []
    
    /// the uniform size of all added items, please set it before adding any items, otherwise, default size will be applied
    open var uniformItemSize:CGSize = CGSize(width: 0,height: 0) {
        didSet{
            itemY = (frame.size.height-self.uniformItemSize.height)/2
        }
    }
    
    /// store the current items' margin
    open var itemsMargin:CGFloat = 10.0
    
    /// the margin between left border and first item
    open var leftMarginPx:CGFloat = 5.0
    
    /// the mini margin between items, it is the seed to calculate the actual margin which is not less than
    open var miniMarginPxBetweenItems:CGFloat  = 10.0
    
    /// the mini width appear for last item of current screen, set it 0 if you don't want any part of the last item appear on the right
    open var miniAppearPxOfLastItem:CGFloat = 20.0
    
    
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
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.delegate = self
    }
    
    override open func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self) {
            return true
        }
        return false
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
        //calculate how many items listed on current screen except the last half appearance one
        let numberOfItemForCurrentWidth = floorf(Float((self.frame.size.width-self.leftMarginPx-self.miniAppearPxOfLastItem)/(self.uniformItemSize.width+self.miniMarginPxBetweenItems)))
        //round func is not compatible in 32bit devices but only in 64bit(5s and iPad Air), so I use this stupid way :)
        return CGFloat(Int((self.frame.size.width-self.leftMarginPx-self.miniAppearPxOfLastItem)/CGFloat(numberOfItemForCurrentWidth) - self.uniformItemSize.width));
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
        if (index != NSNotFound) {
            return self.removeItemAtIndex(index)
        }
        else {return false}
    }
    
    /**
     It removes all items from scrollview
     
     - returns: true if removing successfully.
     */
    open func removeAllItems()->Bool
    {
        for i in (0...self.items.count-1).reversed() {
            let item:UIView = self.items[i]
            item.removeFromSuperview()
        }
        self.items.removeAll(keepingCapacity: false)
        self.contentSize = CGSize(width: self.contentSize.width-self.itemsMargin-self.uniformItemSize.width, height: self.frame.size.height)
        
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
    fileprivate func refreshSubView()
    {
        self.setItemsMarginOnce();
        var itemX = self.leftMarginPx
        for item in self.items
        {
            item.frame = CGRect(x: itemX, y: item.frame.origin.y, width: item.frame.width, height: item.frame.height)
            itemX += item.frame.width + self.itemsMargin
        }
        
        itemX = itemX - self.itemsMargin + self.leftMarginPx;
        self.contentSize = CGSize(width: itemX, height: self.frame.size.height)
    }
    
    
    //ScrollView delegates
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
        //check if target position is over half of current left item, if so, move to next item
        if (xPosition-item.frame.origin.x>item.frame.size.width/2) {
            item = scrollView.items[index+1]
            //check if target position plus scroll view width over content width, if so, move back to last item
            if (item.frame.origin.x + scrollView.frame.size.width > scrollView.contentSize.width) {
                item = scrollView.items[index]
            }
        }
        
        return item.frame.origin.x
    }
    
    
}
