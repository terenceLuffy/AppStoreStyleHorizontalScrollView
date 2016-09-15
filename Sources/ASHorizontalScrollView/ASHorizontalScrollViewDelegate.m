/* ---------------------------------------------------------
 * ASHorizontalScrollViewDelegate.m
 * The MIT License (MIT)
 * Copyright (C) 2014-2015 WEIWEI CHEN
 * ---------------------------------------------------------
 *  History
 *  Created by WEIWEI CHEN on 14-6-2.
 *  Edit by WEIWEI CHEN 16-09-15: avoid cloeset index smaller than 0 when only one item showed in screen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * -------------------------------------------------------*/

#import "ASHorizontalScrollViewDelegate.h"
#import "ASHorizontalScrollView.h"

@implementation ASHorizontalScrollViewDelegate
- (void)scrollViewWillEndDragging:(ASHorizontalScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (targetContentOffset->x + scrollView.frame.size.width < scrollView.contentSize.width) {
        targetContentOffset->x = [self getClosestItemByX:targetContentOffset->x inScrollView:scrollView] - scrollView.leftMarginPx;
    }
}

- (float)getClosestItemByX:(float)xPosition inScrollView:(ASHorizontalScrollView*)scrollView
{
    //get current cloest item on the left side
    int index = (int)((xPosition - scrollView.leftMarginPx)/(scrollView.itemsMargin+scrollView.uniformItemSize.width));
    if (index < 0) {
        index = 0;
    }
    UIView *item = [scrollView.items objectAtIndex:index];
    //check if target position is over half of current left item, if so, move to next item
    if (xPosition-item.frame.origin.x>item.frame.size.width/2) {
        item = [scrollView.items objectAtIndex:index+1];
        //check if target position plus scroll view width over content width, if so, move back to last item
        if (item.frame.origin.x + scrollView.frame.size.width > scrollView.contentSize.width) {
            item = [scrollView.items objectAtIndex:index];
        }
    }
    
    return item.frame.origin.x;
}

@end
