/* ---------------------------------------------------------
* ViewController.swift
* The MIT License (MIT)
* Copyright (C) 2014 WEIWEI CHEN
* ---------------------------------------------------------
*  HIstory
*  Created by WEIWEI CHEN on 14-6-8.
*  Edit by WEIWEI CHEN 14-9-21: fix problems to work on xcode 6.0.1
*  Edit by WEIWEI CHEN 15-12-09: change to adapt Swift 2.1 with Xcode 7 & iOS 9.0
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* -------------------------------------------------------*/

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let kCellHeight:CGFloat = 60.0
    var sampleTableView:UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sampleTableView = UITableView(frame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height), style:.Grouped)
        sampleTableView.dataSource = self
        sampleTableView.delegate = self
        sampleTableView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.view.addSubview(sampleTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.sampleTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifierPortrait = "CellPortrait";
        let CellIdentifierLandscape = "CellLandscape";
        let indentifier = self.view.frame.width > self.view.frame.height ? CellIdentifierLandscape : CellIdentifierPortrait
        var cell = tableView.dequeueReusableCellWithIdentifier(indentifier)

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: indentifier)
            cell?.selectionStyle = .None
            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight))
            if indexPath.row == 0{
                horizontalScrollView.miniAppearPxOfLastItem = 10
                horizontalScrollView.uniformItemSize = CGSizeMake(50, 50)
                //this must be called after changing any size or margin property of this class to get acurrate margin
                horizontalScrollView.setItemsMarginOnce()
                for _ in 1...20{
                    let button = UIButton(frame: CGRectZero)
                    button.backgroundColor = UIColor.blueColor()
                    horizontalScrollView.addItem(button)
                }
            }
            else if indexPath.row == 1 {
                horizontalScrollView.miniAppearPxOfLastItem = 30
                horizontalScrollView.uniformItemSize = CGSizeMake(80, 50)
                //this must be called after changing any size or margin property of this class to get acurrate margin
                horizontalScrollView.setItemsMarginOnce()
                for _ in 1...20{
                    let button = UIButton(frame: CGRectZero)
                    button.backgroundColor = UIColor.purpleColor()
                    horizontalScrollView.addItem(button)
                }
            }
            cell?.contentView.addSubview(horizontalScrollView)
            horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: kCellHeight))
            cell?.contentView.addConstraint(NSLayoutConstraint(item: horizontalScrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: cell!.contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return kCellHeight
    }
    
}

