/* ---------------------------------------------------------
 * ASHorizontalScrollView.m
 * The MIT License (MIT)
 * Copyright (C) 2014-2016 WEIWEI CHEN
 * ---------------------------------------------------------
 *  History
 *  Created by WEIWEI CHEN on 14-6-1.
 *  Edit by WEIWEI CHEN 14-9-21: fix problems to work on xcode 6.0.1
 *  Edit by WEIWEI CHEN 15-12-09: add comments on functions, remove scale when calculating margin, it seems that the behaviour in iOS 9 change the way of align views
 *  Edit by WEIWEI CHEN 16-05-17: fix removeItemAtIndex last index crash bug
 *  Edit by WEIWEI CHEN 16-09-15: add support to nib, just change the class on nib file to ASHorizontalScrollView
 *
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * -------------------------------------------------------*/

#import "ASHorizontalScrollView.h"

@implementation ASHorizontalScrollView

#define kDefaultLeftMargin 5.0f;
#define kMinMarginBetweenItems 10.0f;
#define kMinWidthAppearOfLastItem 20.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _items = [NSMutableArray array];
    
    //default item size is 80% of height
    _uniformItemSize = CGSizeMake(self.frame.size.height*0.8, self.frame.size.height*0.8);
    
    //default attributes
    _leftMarginPx = kDefaultLeftMargin;
    _miniMarginPxBetweenItems = kMinMarginBetweenItems;
    _miniAppearPxOfLastItem = kMinWidthAppearOfLastItem;
    
    //get default item margin
    [self setItemsMarginOnce];
    
    [self setShowsHorizontalScrollIndicator:NO];
    [self setDecelerationRate:UIScrollViewDecelerationRateFast];
    
    scrollViewdelegate = [[ASHorizontalScrollViewDelegate alloc] init];
    self.delegate = scrollViewdelegate;
}

- (void)setFrame:(CGRect)frame
{
    CGRect oldValue = self.frame;
    [super setFrame:frame];
    itemY = (frame.size.height-self.uniformItemSize.height)/2;
    if(frame.size.width != oldValue.size.width){
        [self refreshSubView];
    }
}

- (void)setUniformItemSize:(CGSize)uniformItemSize
{
    _uniformItemSize = uniformItemSize;
    itemY = (self.frame.size.height-uniformItemSize.height)/2;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return true;
    }
    return false;
}

#pragma mark - add item
- (void)addItem:(UIView*)item
{
    //setup new item size and origin
    if (self.items.count>0) {
        CGRect lastItemRect = ((UIView*)self.items.lastObject).frame;
        [item setFrame:CGRectMake(lastItemRect.origin.x + self.uniformItemSize.width + self.itemsMargin, itemY, self.uniformItemSize.width, self.uniformItemSize.height)];
    }
    else [item setFrame:CGRectMake(self.leftMarginPx, itemY, self.uniformItemSize.width, self.uniformItemSize.height)];
    
    [_items addObject:item];
    [self addSubview:item];
    // set the content size of scroll view to fit new width and with the same margin as left margin
    self.contentSize = CGSizeMake(item.frame.origin.x + self.uniformItemSize.width + self.leftMarginPx, self.frame.size.height);
}

- (void)addItems:(NSArray *)items
{
    for (UIView* item in items) {
        [self addItem:item];
    }
}

/// Calculate the exact margin between items
- (int)calculateMarginBetweenItems
{
//    CGFloat scale = [UIScreen mainScreen].scale;
    //calculate how many items listed on current screen except the last half appearance one
    int numberOfItemForCurrentWidth = floorf((self.frame.size.width-self.leftMarginPx-self.miniAppearPxOfLastItem)/(_uniformItemSize.width+self.miniMarginPxBetweenItems));
    
    return round((self.frame.size.width-self.leftMarginPx-self.miniAppearPxOfLastItem)/numberOfItemForCurrentWidth - _uniformItemSize.width);
}

- (void)setItemsMarginOnce
{
    _itemsMargin = [self calculateMarginBetweenItems];
}

#pragma mark - remove item
- (BOOL) removeAllItems
{
    for (long i = self.items.count - 1; i >= 0; i--) {
        UIView *item = self.items[i];
        [item removeFromSuperview];
    }
    [self.items removeAllObjects];
    self.contentSize = CGSizeMake(self.contentSize.width-self.itemsMargin-self.uniformItemSize.width, self.frame.size.height);
    
    return true;
}

- (BOOL)removeItem:(UIView *)item
{
    NSInteger index = [self.items indexOfObject:item];
    if (index != NSNotFound) {
        return [self removeItemAtIndex:index];
    }
    else return false;
}

- (BOOL)removeItemAtIndex:(NSInteger)index
{
    if (index < 0 || index > self.items.count-1) return false;
    //set new x position from index to the end
    if (index != self.items.count-1) {
        for (NSInteger i = self.items.count-1; i > index; i--) {
            UIView *item = [self.items objectAtIndex:i];
            item.frame = CGRectMake(CGRectGetMinX(item.frame)-self.itemsMargin-self.uniformItemSize.width, CGRectGetMinY(item.frame), CGRectGetWidth(item.frame), CGRectGetHeight(item.frame));
        }
    }
    UIView *item = [self.items objectAtIndex:index];
    [item removeFromSuperview];
    [self.items removeObjectAtIndex:index];
    self.contentSize = CGSizeMake(self.contentSize.width-self.itemsMargin-self.uniformItemSize.width, self.frame.size.height);
    
    return true;
}

/// Refresh all subviews for changing size of current frame
- (void) refreshSubView
{
    [self setItemsMarginOnce];
    float itemX = self.leftMarginPx;
    for (UIView *item in self.items) {
        item.frame = CGRectMake(itemX, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
        itemX += item.frame.size.width + self.itemsMargin;
    }
    itemX = itemX - self.itemsMargin + self.leftMarginPx;
    self.contentSize = CGSizeMake(itemX, self.frame.size.height);
}


@end
