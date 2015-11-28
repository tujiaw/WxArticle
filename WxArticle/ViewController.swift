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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let request = GoodArticleRequest(typeId: 0, key: "", page: 1)
        print(request.url)
        Alamofire.request(.GET, request.url).responseJSON {
            response in
            if response.result.isSuccess {
                if let value = response.result.value {
                    Data.sharedManager.goodArticle.setData(value)
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
}