//
//  ViewController.swift
//  sampleScorllViewInSwift
//
//  Created by Vivien on 14-6-8.
//  Copyright (c) 2014年 Zuse. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let kCellHeight:CGFloat = 60.0;
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sampleTableView:UITableView! = UITableView(frame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height), style:.Grouped)
        sampleTableView.dataSource = self
        sampleTableView.delegate = self
        self.view.addSubview(sampleTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifier = "Cell";
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            //(cell as UITableViewCell).text = "Row #\(indexPath.row)"
            let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight))
            if indexPath.row == 0{
                horizontalScrollView.uniformItemSize = CGSizeMake(50, 50);
                //this must be called after changing any size or margin property of this class to get acurrate margin
                horizontalScrollView.setItemsMarginOnce()
                for i in 1...10{
                    let button = UIButton(frame: CGRectMake(0,0,30,30))
                    button.backgroundColor = UIColor.blueColor()
                    horizontalScrollView.addItem(button)
                }
            }
            else if indexPath.row == 1 {
                horizontalScrollView.miniAppearPxOfLastItem = 30;
                horizontalScrollView.uniformItemSize = CGSizeMake(80, 50);
                //this must be called after changing any size or margin property of this class to get acurrate margin
                horizontalScrollView.setItemsMarginOnce()
                for i in 1...10{
                    let button = UIButton(frame: CGRectMake(0,0,30,30))
                    button.backgroundColor = UIColor.purpleColor()
                    horizontalScrollView.addItem(button)
                }
            }
            (cell! as UITableViewCell).contentView.addSubview(horizontalScrollView)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return kCellHeight;
    }
    
}

