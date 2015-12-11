//
//  KeySearchedViewController.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/29.
//  Copyright © 2015年 tujiaw. All rights reserved.
//


import UIKit
import Alamofire

class KeySearchedViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var isLoading = false
    var page: Int = 0 {
        didSet {
            guard let key = navigationItem.title where !key.isEmpty else {
                return
            }
            
            //request.url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let request = GoodArticleRequest(page: page, key: key)
            if let url = request.url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
                isLoading = true
                self.view.makeToastActivity()
                Alamofire.request(.GET, url).responseJSON {
                    response in
                    if response.result.isSuccess {
                        if let value = response.result.value {
                            if self.page == 1 {
                                Data.sharedManager.searchArticle.contentlist.removeAll()
                            }
                            Data.sharedManager.searchArticle.setData(value)
                            self.tableView.reloadData()
                        }
                    }
                    self.isLoading = false
                    self.view.hideToastActivity()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let articleViewController = segue.destinationViewController as? ArticleViewController2 {
            if let row = tableView.indexPathForSelectedRow?.row {
                let searchArticleList = Data.sharedManager.searchArticle.contentlist
                if searchArticleList.count > row {
                    articleViewController.userName = searchArticleList[row].userName
                    articleViewController.url = searchArticleList[row].url
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

extension KeySearchedViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.sharedManager.searchArticle.contentlist.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "SEARCH_CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        if Data.sharedManager.searchArticle.contentlist.count > indexPath.row {
            let content = Data.sharedManager.searchArticle.contentlist[indexPath.row]
            if let image = Data.sharedManager.searchArticle.imagedic[content.contentImg] {
                cell?.imageView?.image = image
            }
            cell?.textLabel?.text = content.userName
            cell?.detailTextLabel?.text = content.title
        }
        
        return cell!
    }
}

extension KeySearchedViewController: UISearchBarDelegate {
    internal func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        if let key = searchBar.text {
            self.navigationItem.title = key
            page = 1
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension KeySearchedViewController {
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if action == Selector("copy:") {
            if indexPath.row < Data.sharedManager.searchArticle.contentlist.count {
                UIPasteboard.generalPasteboard().string = Data.sharedManager.searchArticle.contentlist[indexPath.row].url
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


