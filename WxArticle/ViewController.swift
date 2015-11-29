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
    
    var isLoading = false
    var typeId: Int = 0 {
        willSet {
            
        }
        didSet {
            self.navigationController?.popToRootViewControllerAnimated(true)
            Data.sharedManager.goodArticle.contentlist = [ContentList]()
            requestData(self.typeId, page: self.page, toTop: true)
        }
    }
    var page: Int = 0 {
        willSet {
            
        }
        didSet {
            requestData(self.typeId, page: self.page)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.page = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func requestData(typeId: Int, page: Int, toTop: Bool = false) {
        if isLoading {
            return
        }
        
        isLoading = true
        self.view.makeToastActivity()
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
            self.navigationItem.title = Data.sharedManager.category.typeName(typeId)
            if toTop {
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
            if let url = NSURL(string: content.contentImg), let imgData = NSData(contentsOfURL: url), let image = UIImage(data: imgData) {
                UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
                image.drawInRect(CGRectMake(0, 0, 80, 80))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                cell?.imageView?.image = newImage
            }
            cell?.textLabel?.text = content.userName
            cell?.detailTextLabel?.text = content.title
        }
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let articleViewController = segue.destinationViewController as? ArticleViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                let goodArticleList = Data.sharedManager.goodArticle.contentlist
                if goodArticleList.count > row {
                    articleViewController.userName = goodArticleList[row].userName
                    articleViewController.url = goodArticleList[row].url
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

