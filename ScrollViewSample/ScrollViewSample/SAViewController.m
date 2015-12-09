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
    sampleTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:sampleTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))sampleTableView.frame = CGRectMake(0, 0, sampleTableView.frame.size.width, sampleTableView.frame.size.height);
    else sampleTableView.frame = CGRectMake(0, 20, sampleTableView.frame.size.width, sampleTableView.frame.size.height);

    [sampleTableView reloadData];
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
    static NSString *CellIdentifierPortrait = @"CellPortrait";
    static NSString *CellIdentifierLandscape = @"CellLandscape";
    NSString *indentifier = self.view.frame.size.width > self.view.frame.size.height ? CellIdentifierLandscape : CellIdentifierPortrait;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ASHorizontalScrollView *horizontalScrollView = [[ASHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight)];
        if (indexPath.row == 0) {
            horizontalScrollView.miniAppearPxOfLastItem = 10;
            //sample code of how to use this scroll view
            horizontalScrollView.uniformItemSize = CGSizeMake(50, 50);
            //this must be called after changing any size or margin property of this class to get acurrate margin
            [horizontalScrollView setItemsMarginOnce];
            //create 20 buttons for cell 1
            NSMutableArray *buttons = [NSMutableArray array];
            for (int i=1; i<20; i++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.backgroundColor = [UIColor blueColor];
                [buttons addObject:label];
            }
            [horizontalScrollView addItems:buttons];
        }
        else if (indexPath.row == 1) {
            horizontalScrollView.miniAppearPxOfLastItem = 20;
            //setup the uniform size for all added items
            horizontalScrollView.uniformItemSize = CGSizeMake(90, 50);
            //this must be called after changing any size or margin property of this class to get acurrate margin
            [horizontalScrollView setItemsMarginOnce];
            
            NSMutableArray *buttons = [NSMutableArray array];
            for (int i=1; i<21; i++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.backgroundColor = [UIColor purpleColor];
                [buttons addObject:label];
            }
            [horizontalScrollView addItems:buttons];
//            [horizontalScrollView removeItemAtIndex:0];
//            [horizontalScrollView removeItemAtIndex:1];
        }
        
        [cell.contentView addSubview:horizontalScrollView];
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kCellHeight]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalScrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    }
    
	
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}



@end
