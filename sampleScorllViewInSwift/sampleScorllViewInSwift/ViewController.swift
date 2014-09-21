/* ---------------------------------------------------------
* ViewController.swift
* The MIT License (MIT)
* Copyright (C) 2014 WEIWEI CHEN
* ---------------------------------------------------------
*  HIstory
*  Created by WEIWEI CHEN on 14-6-8.
*  Edit by WEIWEI CHEN 14-9-21: fix problems to work on xcode 6.0.1
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* -------------------------------------------------------*/

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let kCellHeight:CGFloat = 60.0;
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sampleTableView:UITableView = UITableView(frame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height), style:.Grouped)
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
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell

        if (cell == nil) {
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
            cell.contentView.addSubview(horizontalScrollView)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        return kCellHeight;
    }
    
}

