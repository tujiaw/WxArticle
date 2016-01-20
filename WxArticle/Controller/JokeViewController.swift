//
//  ViewController.swift
//  JokeText
//
//  Created by tutujiaw on 15/11/11.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class JokeViewController: UIViewController {
    let segControl = UISegmentedControl(items: ["笑话", "趣图"])
    let tableView = UITableView()
    
    var isLoading = false
    var firstSegRow = 0
    var secondSegRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)
        self.view.addSubview(segControl)
        
        segControl.backgroundColor = UIColor.whiteColor()
        segControl.selectedSegmentIndex = 0
        segControl.hidden = false
        segControl.addTarget(self, action: Selector("segmentValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        segControl.snp_makeConstraints{(make)->Void in
            make.top.equalTo(self.view.snp_top).offset(20)
            make.height.equalTo(25)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(200)
        }
        
        tableView.snp_makeConstraints{(make)->Void in
            make.top.equalTo(segControl.snp_bottom).offset(5)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(self.view)
        }
        
        requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getColor(color:Int32) -> UIColor{
        let red = CGFloat((color&0xff0000)>>16)/255
        let green = CGFloat((color&0xff00)>>8)/255
        let blue = CGFloat(color&0xff)/255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    func requestData() {
        isLoading = true
        self.view.makeToastActivity()
        let loadFinishedHandle = {()->Void in
            self.isLoading = false
            self.view.hideToastActivity()
        }
        
        if segControl.selectedSegmentIndex == 0 {
            let request = JokeTextRequest()
            Alamofire.request(.GET, request.url).responseJSON { response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        Data.sharedManager.textJoke.setData(value)
                        self.tableView.reloadData()
                    }
                }
                loadFinishedHandle()
            }
        } else if segControl.selectedSegmentIndex == 1 {
            let request = ImageJokeRequest()
            Alamofire.request(.GET, request.url).responseJSON { response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        Data.sharedManager.imageJoke.setData(value)
                        self.tableView.reloadData()
                    }
                }
                loadFinishedHandle()
            }
        }
    }
    
    func segmentValueChanged(sender: UISegmentedControl) {
        var needRequest = false
        if segControl.selectedSegmentIndex == 0 {
            if Data.sharedManager.textJoke.list.count == 0 {
                needRequest = true
            } else {
                self.tableView.reloadData()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: firstSegRow, inSection: 0), atScrollPosition: .Bottom, animated: true)
            }
        } else {
            if Data.sharedManager.imageJoke.list.count == 0 {
                needRequest = true
            } else {
                self.tableView.reloadData()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: secondSegRow, inSection: 0), atScrollPosition: .Bottom, animated: true)
            }
        }
        
        if needRequest {
            if self.tableView.numberOfRowsInSection(0) > 0 {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            }
            requestData()
        }
    }
}

extension JokeViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segControl.selectedSegmentIndex == 0 {
            return Data.sharedManager.textJoke.list.count
        } else {
            return Data.sharedManager.imageJoke.list.count
        }
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var result: UITableViewCell!
        if segControl.selectedSegmentIndex == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier(JokeViewCell.ID) as? JokeViewCell
            if cell == nil {
                cell = JokeViewCell(style: .Subtitle, reuseIdentifier: JokeViewCell.ID)
            }
            
            if Data.sharedManager.textJoke.list.count > indexPath.row {
                do {
                let jokeItem = Data.sharedManager.textJoke.list[indexPath.row]
                cell?.titleLabel.text = jokeItem.title
                cell?.ctLabel.text = ""
                let htmlContent = jokeItem.content.dataUsingEncoding(NSUTF32StringEncoding, allowLossyConversion: false)
                if let htmlContent = htmlContent {
                    let attrContent = try NSAttributedString(data: htmlContent, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    cell?.contentLabel.attributedText = attrContent
                    cell?.contentLabel.numberOfLines = 0
                    cell?.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
                    }
                } catch {}
            }
            
            result = cell
            firstSegRow = indexPath.row
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier(ImageJokeViewCell.ID) as? ImageJokeViewCell
            if cell == nil {
                cell = ImageJokeViewCell(style: .Subtitle, reuseIdentifier: ImageJokeViewCell.ID, parent: self)
            }
            
            if Data.sharedManager.imageJoke.list.count > indexPath.row {
                let jokeItem = Data.sharedManager.imageJoke.list[indexPath.row]
                cell?.titleLabel.text = jokeItem.title
                cell?.webView.loadRequest(NSURLRequest(URL: NSURL(string: jokeItem.thumburl)!))
            }
            
            result = cell
            secondSegRow = indexPath.row
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segControl.selectedSegmentIndex == 0 {
            return UITableViewAutomaticDimension
        } else {
            if Data.sharedManager.imageJoke.list.count > indexPath.row {
                let width = Data.sharedManager.imageJoke.list[indexPath.row].width
                let height = Data.sharedManager.imageJoke.list[indexPath.row].height
                let scale = CGFloat(width) / self.view.frame.size.width
                guard width != 0 && height != 0 && scale != 0 else {
                    return UITableViewAutomaticDimension
                }
                return CGFloat(height) / scale + CGFloat(40)
            }
            return UITableViewAutomaticDimension
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.isLoading {
            return
        }
        
        let space = CGFloat(20)
        let y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom
        //print("y:\(y), height:\(scrollView.contentSize.height), table height:\(self.tableView.frame.height)")
        if y > scrollView.contentSize.height + space {           // 滑到底部
            requestData()
        }
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if action == Selector("copy:") {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? JokeViewCell {
                UIPasteboard.generalPasteboard().string = cell.contentLabel.text
            }
        }
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if segControl.selectedSegmentIndex == 0 {
            return action == Selector("copy:")
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if segControl.selectedSegmentIndex == 0 {
            return true
        } else {
            return false
        }
    }
}
