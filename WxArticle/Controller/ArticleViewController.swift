//
//  ArticleViewController.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/28.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import UIKit

class ArticleContentViewController: UIViewController {
    
    var dataType: DataType = DataType.None
    var content = ContentList()
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let nsurl = NSURL(string: content.url) {
            webView.loadRequest(NSURLRequest(URL: nsurl))
        }
        navigationItem.title = content.userName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShare(sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: "文章 ", message: "分享到微信", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {(action) -> Void in
            print("cancel share")
        })
        let shareToFriend = UIAlertAction(title: "好朋友", style: .Destructive, handler: {(action) -> Void in
            self.shareToWChat(WXSceneSession)
        })
        let shareToGroupsFriends = UIAlertAction(title: "朋友圈", style: .Destructive, handler: {(action) -> Void in
            self.shareToWChat(WXSceneTimeline)
        })
        let favorite = UIAlertAction(title: "收藏", style: .Default, handler: {(action) -> Void in
            self.shareToWChat(WXSceneFavorite)
        })

        sheet.addAction(cancelAction)
        sheet.addAction(shareToFriend)
        sheet.addAction(shareToGroupsFriends)
        sheet.addAction(favorite)
        self.presentViewController(sheet, animated: true, completion: {() -> Void in
            print("present over")
        })
    }
    
    func shareToWChat(scene: WXScene) {
        let page = WXWebpageObject()
        page.webpageUrl = content.url
        
        let msg = WXMediaMessage()
        msg.mediaObject = page
        msg.title = (scene == WXSceneTimeline ? content.title : content.userName)
        msg.description = content.title
        
        switch dataType {
        case .GoodArticle:
            msg.setThumbImage(Data.sharedManager.goodArticle.imagedic[content.contentImg])
        case .SearchArticle:
            msg.setThumbImage(Data.sharedManager.searchArticle.imagedic[content.contentImg])
        default:
            print("data type error")
        }
        
        let req = SendMessageToWXReq()
        req.message = msg
        req.scene = Int32(scene.rawValue)
        WXApi.sendReq(req)
    }
    
}