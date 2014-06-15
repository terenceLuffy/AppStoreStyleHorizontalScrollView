//
//  ASHorizontalScrollViewDelegate.m
//  ScrollViewSample
//
//  Created by Vivien on 2014-06-02.
//  Copyright (c) 2014 Zuse. All rights reserved.
//

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
