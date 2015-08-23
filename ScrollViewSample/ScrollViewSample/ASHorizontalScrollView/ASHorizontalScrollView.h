/* ---------------------------------------------------------
 * ASHorizontalScrollView.h
 * The MIT License (MIT)
 * Copyright (C) 2014 WEIWEI CHEN
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

//an array which refer to all added items
@property (strong, nonatomic, readonly) NSMutableArray *items;

//the uniform size of all added items, please set it before adding any items, otherwise, default size will be applied
@property (nonatomic)CGSize uniformItemSize;

//store the current items' margin
@property (nonatomic, readonly)int itemsMargin;

//the margin between left border and first item
@property (nonatomic)float leftMarginPx;

//the mini margin between items, it is the seed to calculate the actual margin which is not less than
@property (nonatomic)float miniMarginPxBetweenItems;

//the mini width appear for last item of current screen, set it 0 if you don't want any part of the last item appear on the right
@property (nonatomic)float miniAppearPxOfLastItem;

//add new item into scroll view
- (void) addItem:(UIView*)item;

//add items into scroll view
- (void) addItems:(NSArray*)items;

//remove item from scroll view with that specified item
- (BOOL) removeItem:(UIView*)item;

//remove item from scroll view with index in the array
- (BOOL) removeItemAtIndex:(NSInteger)index;

//remove all items
- (BOOL) removeAllItems;

//calculate items' margin, this must be called after setting any size or margin properties
- (void) setItemsMarginOnce;
@end
