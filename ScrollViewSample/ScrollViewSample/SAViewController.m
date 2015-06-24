/* ---------------------------------------------------------
 * SAViewController.m
 * The MIT License (MIT)
 * Copyright (C) 2014 WEIWEI CHEN
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * -------------------------------------------------------*/

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
            horizontalScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            horizontalScrollView.uniformItemSize = CGSizeMake(50, 50);
            //this must be called after changing any size or margin property of this class to get acurrate margin
            [horizontalScrollView setItemsMarginOnce];
            //create 20 buttons for cell 1
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
            horizontalScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
