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
*
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* -------------------------------------------------------*/

import UIKit

public class ASHorizontalScrollView: UIScrollView, UIScrollViewDelegate {
    let scale = UIScreen.mainScreen().scale
    
    override public var frame: CGRect{
        didSet{
            itemY = (frame.size.height-self.uniformItemSize.height)/2
            //if width changes, then need to get new margin and reset all views
            if(frame.width != oldValue.width){
                self.refreshSubView()
            }
        }
    }
    /// y position of all items
    public var itemY: CGFloat = 0
    /// an array which refer to all added items
    public var items: Array<UIView> = []
    
    /// the uniform size of all added items, please set it before adding any items, otherwise, default size will be applied
    public var uniformItemSize:CGSize = CGSizeMake(0,0) {
        didSet{
            itemY = (frame.size.height-self.uniformItemSize.height)/2
        }
    }
    
    /// store the current items' margin
    public var itemsMargin:CGFloat = 10.0
    
    /// the margin between left border and first item
    public var leftMarginPx:CGFloat = 5.0
    
    /// the mini margin between items, it is the seed to calculate the actual margin which is not less than
    public var miniMarginPxBetweenItems:CGFloat  = 10.0
    
    /// the mini width appear for last item of current screen, set it 0 if you don't want any part of the last item appear on the right
    public var miniAppearPxOfLastItem:CGFloat = 20.0
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        //default item size is 80% of height
        self.uniformItemSize = CGSizeMake(frame.size.height*0.8, frame.size.height*0.8)
        
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     This add a new item into the scrollview
     
     - parameter item: the item you would like to add, it must not be nil.
     */
    public func addItem(item:UIView)
    {
        //setup new item size and origin
        if (self.items.count>0) {
            let lastItemRect:CGRect = self.items[self.items.count-1].frame;
            item.frame = CGRectMake(lastItemRect.origin.x + self.uniformItemSize.width + self.itemsMargin, itemY, self.uniformItemSize.width, self.uniformItemSize.height)
        }
        else {
            item.frame = CGRectMake(self.leftMarginPx, itemY, self.uniformItemSize.width, self.uniformItemSize.height)
        }
        
        items.append(item);
        self.addSubview(item);
        // set the content size of scroll view to fit new width and with the same margin as left margin
        self.contentSize = CGSizeMake(item.frame.origin.x + self.uniformItemSize.width + self.leftMarginPx, self.frame.size.height);
    }
    
    /**
     This add multi new items into the scrollview
     
     - parameter items: the items in array you would like to add, it must not be nil.
     */
    public func addItems(items:[UIView])
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
    public func setItemsMarginOnce()
    {
        self.itemsMargin = self.calculateMarginBetweenItems();
    }
    
    /// Calculate the exact margin between items
    public func calculateMarginBetweenItems() -> CGFloat
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
    public func removeItem(item:UIView) -> Bool
    {
        let index = (self.items as NSArray).indexOfObject(item);
        if (index != NSNotFound) {
            return self.removeItemAtIndex(index)
        }
        else {return false}
    }
    
    /**
     It removes all items from scrollview
     
     - returns: true if removing successfully.
     */
    public func removeAllItems()->Bool
    {
        for i in (0...self.items.count-1).reverse() {
            let item:UIView = self.items[i]
            item.removeFromSuperview()
        }
        self.items.removeAll(keepCapacity: false)
        self.contentSize = CGSizeMake(self.contentSize.width-self.itemsMargin-self.uniformItemSize.width, self.frame.size.height)
        
        return true
    }
    
    /**
     It removes the specified item at index from scrollview
     
     - parameter index: the index of item you would like to remove.
     
     - returns: true if removing successfully.
     */
    public func removeItemAtIndex(index:Int)->Bool
    {
        if (index < 0 || index > self.items.count-1) {return false}
        //set new x position from index to the end
        if index != self.items.count-1{
            for i in (index+1...self.items.count-1).reverse() {
                let item:UIView = self.items[i]
                item.frame = CGRectMake(CGRectGetMinX(item.frame)-self.itemsMargin-self.uniformItemSize.width, CGRectGetMinY(item.frame), CGRectGetWidth(item.frame), CGRectGetHeight(item.frame))
            }
        }
        
        let item:UIView = self.items[index]
        item.removeFromSuperview()
        self.items.removeAtIndex(index)
        self.contentSize = CGSizeMake(self.contentSize.width-self.itemsMargin-self.uniformItemSize.width, self.frame.size.height)
        
        return true
    }
    
    /// Refresh all subviews for changing size of current frame
    private func refreshSubView()
    {
        self.setItemsMarginOnce();
        var itemX = self.leftMarginPx
        for item in self.items
        {
            item.frame = CGRectMake(itemX, item.frame.origin.y, item.frame.width, item.frame.height)
            itemX += item.frame.width + self.itemsMargin
        }
        
        itemX = itemX - self.itemsMargin + self.leftMarginPx;
        self.contentSize = CGSizeMake(itemX, self.frame.size.height)
    }
    
    
    //ScrollView delegates
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //warning - this seems not a safe way to get target point, however, I can't find other way to retrieve the value
        let targetOffset:CGPoint = UnsafePointer<CGPoint>(targetContentOffset).memory;
        //move to closest item
        if (targetOffset.x + scrollView.frame.size.width < scrollView.contentSize.width) {
            targetContentOffset.memory.x = self.getClosestItemByX(position:targetOffset.x, inScrollView:(scrollView as! ASHorizontalScrollView)) - (scrollView as! ASHorizontalScrollView).leftMarginPx;
        }
    }
    
    private func getClosestItemByX(position xPosition:CGFloat, inScrollView scrollView:ASHorizontalScrollView) -> CGFloat
    {
        //get current cloest item on the left side
        let index = (Int)((xPosition - scrollView.leftMarginPx)/(scrollView.itemsMargin+scrollView.uniformItemSize.width))
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
