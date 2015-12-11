//
//  ArticleViewController.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/28.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import UIKit

class ArticleViewController2: UIViewController {
    var userName = ""
    var url = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let nsurl = NSURL(string: url) {
            webView.loadRequest(NSURLRequest(URL: nsurl))
        }
        navigationItem.title = userName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func onShare(sender: UIBarButtonItem) {
        let req = SendMessageToWXReq()
        req.text = "分享测试"
        req.bText = true
        WXApi.sendReq(req)
    }
    
}