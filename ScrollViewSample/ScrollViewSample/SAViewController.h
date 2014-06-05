//
//  SAViewController.h
//  ScrollViewSample
//
//  Created by Vivien on 2014-06-01.
//  Copyright (c) 2014 Zuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASHorizontalScrollView.h"

@interface SAViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *sampleTableView;
}

@end
