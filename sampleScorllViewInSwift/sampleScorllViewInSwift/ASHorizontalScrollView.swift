/* ---------------------------------------------------------
* ASHorizontalScrollView.swift
* The MIT License (MIT)
* Copyright (C) 2014 WEIWEI CHEN
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* -------------------------------------------------------*/

import UIKit

class ASHorizontalScrollView: UIScrollView, UIScrollViewDelegate {
    
    override var frame: CGRect{
    didSet{
        itemY = (frame.size.height-self.uniformItemSize.height)/2;
    }
    }
    //y position of all items
    var itemY: CGFloat = 0
    //an array which refer to all added items
    var items: Array<UIView> = []
    
    //the uniform size of all added items, please set it before adding any items, otherwise, default size will be applied
    var uniformItemSize:CGSize = CGSizeMake(0,0) {
    didSet{
        itemY = (frame.size.height-self.uniformItemSize.height)/2;
    }
    }
    
    //store the current items' margin
    var itemsMargin:CGFloat = 10.0
    
    //the margin between left border and first item
    var leftMarginPx:CGFloat = 5.0
    
    //the mini margin between items, it is the seed to calculate the actual margin which is not less than
    var miniMarginPxBetweenItems:CGFloat  = 10.0
    
    //the mini width appear for last item of current screen, set it 0 if you don't want any part of the last item appear on the right
    var miniAppearPxOfLastItem:CGFloat = 10.0
    
    
    init(frame: CGRect) {
        super.init(frame: frame)
        
        //default item size is 80% of height
        self.uniformItemSize = CGSizeMake(frame.size.height*0.8, frame.size.height*0.8)
        
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.delegate = self;
    }
    
    func addItem(item:UIView)
    {
        
        //setup new item size and origin
        if (self.items.count>0) {
            var lastItemRect:CGRect = (self.items[self.items.count-1] as UIButton).frame;
            item.frame = CGRectMake(lastItemRect.origin.x + self.uniformItemSize.width + self.itemsMargin, itemY, self.uniformItemSize.width, self.uniformItemSize.height)
        }
        else {
            item.frame = CGRectMake(self.leftMarginPx, itemY, self.uniformItemSize.width, self.uniformItemSize.height);
        }
        
        items.append(item);
        self.addSubview(item);
        // set the content size of scroll view to fit new width and with the same margin as left margin
        self.contentSize = CGSizeMake(item.frame.origin.x + self.uniformItemSize.width + self.leftMarginPx, self.frame.size.height);
    }
    
    func addItems(items:Array<UIView>)
    {
        for item in items {
            self.addItem(item)
        }
    }
    
    func setItemsMarginOnce()
    {
        self.itemsMargin = self.calculateMarginBetweenItems();
    }
    
    //calculate the exact margin between items
    func calculateMarginBetweenItems() -> CGFloat
    {
        //calculate how many items listed on current screen except the last half appearance one
        var numberOfItemForCurrentWidth = floorf(Float((self.frame.size.width-self.leftMarginPx-self.miniAppearPxOfLastItem)/(self.uniformItemSize.width+self.miniMarginPxBetweenItems)))
        //round func is not compatible in 32bit devices but only in 64bit(5s and iPad Air), so I use this stupid way :)
        return CGFloat(Int((self.frame.size.width-self.leftMarginPx-self.miniAppearPxOfLastItem)/CGFloat(numberOfItemForCurrentWidth) - self.uniformItemSize.width));
    }
    
    //return whether removing action is success
    func removeItem(item:UIView) -> Bool
    {
        var index = (self.items as NSArray).indexOfObject(item);
        if (index != NSNotFound) {
            return self.removeItemAtIndex(index);
        }
        else {return false;}
    }
    
    func removeItemAtIndex(index:Int)->Bool
    {
        if (index < 0 || index > self.items.count-1) {return false;}
        //set new x position from index to the end
        for (var i = self.items.count-1; i > index; i--) {
            var item:UIView = self.items[i];
            item.frame = CGRectMake(CGRectGetMinX(item.frame)-self.itemsMargin-self.uniformItemSize.width, CGRectGetMinY(item.frame), CGRectGetWidth(item.frame), CGRectGetHeight(item.frame));
        }
        var item:UIView = self.items[index];
        item.removeFromSuperview();
        self.items.removeAtIndex(index);
        self.contentSize = CGSizeMake(self.contentSize.width-self.itemsMargin-self.uniformItemSize.width, self.frame.size.height);
        
        return true;
    }
    
    
    //ScrollView delegates
    func scrollViewWillEndDragging(scrollView: ASHorizontalScrollView!, withVelocity velocity: CGPoint, targetContentOffset: CMutablePointer<CGPoint>)
    {
        //warning - this seems not a safe way to get target point, however, I can't find other way to retrieve the value
        var targetOffset:CGPoint = UnsafePointer<CGPoint>(targetContentOffset).memory;
        //move to closest item
        if (targetOffset.x + scrollView.frame.size.width < scrollView.contentSize.width) {
            UnsafePointer<CGPoint>(targetContentOffset).memory.x = self.getClosestItemByX(position:targetOffset.x, inScrollView:scrollView) - scrollView.leftMarginPx;
        }
    }
    
    func getClosestItemByX(position xPosition:CGFloat, inScrollView scrollView:ASHorizontalScrollView) -> CGFloat
    {
        //get current cloest item on the left side
        var index = (Int)((xPosition - scrollView.leftMarginPx)/(scrollView.itemsMargin+scrollView.uniformItemSize.width));
        var item:UIView = scrollView.items[index];
        //check if target position is over half of current left item, if so, move to next item
        if (xPosition-item.frame.origin.x>item.frame.size.width/2) {
            item = scrollView.items[index+1];
            //check if target position plus scroll view width over content width, if so, move back to last item
            if (item.frame.origin.x + scrollView.frame.size.width > scrollView.contentSize.width) {
                item = scrollView.items[index];
            }
        }
        
        return item.frame.origin.x;
    }
    
    
}
