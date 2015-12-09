/* ---------------------------------------------------------
 * ASHorizontalScrollView.h
 * The MIT License (MIT)
 * Copyright (C) 2014-2015 WEIWEI CHEN
 * ---------------------------------------------------------
 *  History
 *  Created by WEIWEI CHEN on 14-6-1.
 *  Edit by WEIWEI CHEN 14-9-21: fix problems to work on xcode 6.0.1
 *  Edit by WEIWEI CHEN 15-12-09: add comments on functions
 *
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * -------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "ASHorizontalScrollViewDelegate.h"

@interface ASHorizontalScrollView : UIScrollView
{
    //y position of all items
    float itemY;
    
    ASHorizontalScrollViewDelegate *scrollViewdelegate;
}

/// an array which refer to all added items
@property (strong, nonatomic, readonly) NSMutableArray *items;

/// the uniform size of all added items, please set it before adding any items, otherwise, default size will be applied
@property (nonatomic)CGSize uniformItemSize;

/// store the current items' margin
@property (nonatomic, readonly)int itemsMargin;

/// the margin between left border and first item
@property (nonatomic)float leftMarginPx;

//the mini margin between items, it is the seed to calculate the actual margin which is not less than
@property (nonatomic)float miniMarginPxBetweenItems;

/// the mini width appear for last item of current screen, set it 0 if you don't want any part of the last item appear on the right
@property (nonatomic)float miniAppearPxOfLastItem;

/**
 This add a new item into the scrollview
 
 - parameter item: the item you would like to add, it must not be nil.
 */
- (void) addItem:(UIView*)item;

/**
 This add multi new items into the scrollview
 
 - parameter items: the items in array you would like to add, it must not be nil.
 */
- (void) addItems:(NSArray*)items;

/**
 It removes the specified item from scrollview
 
 - parameter item: the item you would like to remove.
 
 - returns: true if removing successfully.
 */
- (BOOL) removeItem:(UIView*)item;

/**
 It removes the specified item at index from scrollview
 
 - parameter index: the index of item you would like to remove.
 
 - returns: true if removing successfully.
 */
- (BOOL) removeItemAtIndex:(NSInteger)index;

/**
 It removes all items from scrollview
 
 - returns: true if removing successfully.
 */
- (BOOL) removeAllItems;

/**
 It re-calculate the item margin to fit in current view frame
 - note: This must be called after changing any size or margin property of this class to get acurrate margin
 - seealso: calculateMarginBetweenItems
 */
- (void) setItemsMarginOnce;
@end
