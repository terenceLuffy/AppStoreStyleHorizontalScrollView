//
//  SAViewController.m
//  ScrollViewSample
//
//  Created by Vivien on 2014-06-01.
//  Copyright (c) 2014 Zuse. All rights reserved.
//

#import "SAViewController.h"

@interface SAViewController ()

@end

@implementation SAViewController

const float kCellHeight = 60.0f;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //create table view to contain ASHorizontalScrollView
    sampleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    sampleTableView.delegate = self;
    sampleTableView.dataSource = self;
    [self.view addSubview:sampleTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
        
        
        if (indexPath.row == 0) {
            //sample code of how to use this scroll view
            ASHorizontalScrollView *horizontalScrollView = [[ASHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight)];
            [cell.contentView addSubview:horizontalScrollView];
            horizontalScrollView.uniformItemSize = CGSizeMake(50, 50);
            //this must be called after changing any size or margin property of this class to get acurrate margin
            [horizontalScrollView setItemsMarginOnce];
            //create 10 buttons for cell 1
            NSMutableArray *buttons = [NSMutableArray array];
            for (int i=1; i<20; i++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                label.backgroundColor = [UIColor blueColor];
                [buttons addObject:label];
            }
            [horizontalScrollView addItems:buttons];
        }
        else if (indexPath.row == 1) {
            ASHorizontalScrollView *horizontalScrollView = [[ASHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight)];
            [cell.contentView addSubview:horizontalScrollView];
            horizontalScrollView.uniformItemSize = CGSizeMake(80, 50);
            //this must be called after changing any size or margin property of this class to get acurrate margin
            [horizontalScrollView setItemsMarginOnce];
            
            NSMutableArray *buttons = [NSMutableArray array];
            for (int i=1; i<21; i++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
                label.backgroundColor = [UIColor purpleColor];
                [buttons addObject:label];
            }
            [horizontalScrollView addItems:buttons];
            [horizontalScrollView removeItemAtIndex:0];
            [horizontalScrollView removeItemAtIndex:1];
        }
    }
    
	
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}



@end
