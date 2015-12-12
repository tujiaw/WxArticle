//
//  ViewController.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/16.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var imageCache = [(String, UIImage)]()
    
    var isLoading = false
    var typeId: Int = -1 {
        didSet {
            self.navigationController?.popToRootViewControllerAnimated(true)
            Data.sharedManager.goodArticle.contentlist = [ContentList]()
            requestData(self.typeId, page: self.page, toTop: true)
        }
    }
    var page: Int = 1 {
        didSet {
            requestData(self.typeId, page: self.page)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: "onRefreshControl", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        let curId = NSUserDefaults.standardUserDefaults().integerForKey("curId")
        let curTitle = NSUserDefaults.standardUserDefaults().stringForKey("curTitle")
        if let curTitle = curTitle {
            self.typeId = curId
            self.navigationItem.title = curTitle
        } else {
            self.typeId = 0
            self.navigationItem.title = "热点"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func onRefreshControl() {
        Data.sharedManager.goodArticle.contentlist = [ContentList]()
        requestData(typeId, page: 1)
    }
    
    func requestData(typeId: Int, page: Int, toTop: Bool = false) {
        if isLoading {
            return
        }
        
        isLoading = true
        if !refreshControl.refreshing {
            self.view.makeToastActivity()
        }
        
        let request = GoodArticleRequest(typeId: self.typeId, key: "", page: self.page)
        print(request.url)
        Alamofire.request(.GET, request.url).responseJSON {
            response in
            if response.result.isSuccess {
                if let value = response.result.value {
                    Data.sharedManager.goodArticle.setData(value)
                        
                    self.tableView.reloadData()
                }
            }
            self.isLoading = false
            self.view.hideToastActivity()
            self.refreshControl.endRefreshing()
            
            let curTitle = Data.sharedManager.category.typeName(typeId) ?? self.navigationItem.title
            self.navigationItem.title = curTitle
            NSUserDefaults.standardUserDefaults().setValue(curTitle, forKey: "curTitle")
            NSUserDefaults.standardUserDefaults().setValue(self.typeId, forKey: "curId")
            
            if toTop && self.tableView.numberOfRowsInSection(0) > 0 {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            }
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.sharedManager.goodArticle.contentlist.count
    }

    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "ARTICLE_CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        if Data.sharedManager.goodArticle.contentlist.count > indexPath.row {
            let content = Data.sharedManager.goodArticle.contentlist[indexPath.row]
            cell?.imageView?.image = Data.sharedManager.goodArticle.imagedic[content.contentImg]
            cell?.textLabel?.text = content.userName
            cell?.detailTextLabel?.text = content.title
        }
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let articleViewController = segue.destinationViewController as? ArticleContentViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                let goodArticleList = Data.sharedManager.goodArticle.contentlist
                if goodArticleList.count > row {
                    articleViewController.dataType = DataType.GoodArticle
                    articleViewController.content = goodArticleList[row]
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if isLoading {
            return
        }
        
        let space = CGFloat(20)
        let y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom
        if y > scrollView.contentSize.height + space {
            ++self.page
        }
    }
}

extension ViewController {
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if action == Selector("copy:") {
            if indexPath.row < Data.sharedManager.goodArticle.contentlist.count {
                UIPasteboard.generalPasteboard().string = Data.sharedManager.goodArticle.contentlist[indexPath.row].url
            }
        }
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return action == Selector("copy:")
    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}


