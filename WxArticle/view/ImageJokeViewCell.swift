//
//  ImageJokeViewCell.swift
//  WxArticle
//
//  Created by tutujiaw on 16/1/17.
//  Copyright © 2016年 tujiaw. All rights reserved.
//

import UIKit
import SnapKit

enum TouchState {
    case None
    case Start
    case Move
    case End
    case Cancel
}

class WebView : UIWebView {
    
}
class ImageJokeViewCell : UITableViewCell, UIWebViewDelegate {
    
    static let ID = "IMAGE_JOKE_VIEW_CELL_ID"
    let titleLabel = UILabel()
    let webView = UIWebView()
    var parent: UIViewController? = nil
    
    static let touchJSStr = "document.ontouchstart=function(event){x=event.targetTouches[0].clientX;y=event.targetTouches[0].clientY;document.location=\"myweb:touch:start:\"+x+\":\"+y;};document.ontouchmove=function(event){x=event.targetTouches[0].clientX;y=event.targetTouches[0].clientY;document.location=\"myweb:touch:move:\"+x+\":\"+y;};document.ontouchcancel=function(event){document.location=\"myweb:touch:cancel\";};document.ontouchend=function(event){document.location=\"myweb:touch:end\";};"
    static var imageUrl = ""
    var timer: NSTimer? = nil
    
    var touchState: TouchState = TouchState.None
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, parent: UIViewController?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        self.addSubview(webView)
        self.parent = parent
        
        titleLabel.snp_makeConstraints{(make)->Void in
            make.top.equalTo(self.snp_top).offset(0)
            make.height.equalTo(30)
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.width.equalTo(self.snp_width)
        }
        
        webView.scalesPageToFit = true
        webView.scrollView.scrollEnabled = false
        webView.delegate = self
        webView.snp_makeConstraints{(make)->Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(0)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(self.snp_width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestStr:String = request.URL!.absoluteString
        
        let components = requestStr.componentsSeparatedByString(":")
        if(components.count>1 && components[0] == "myweb"){
            if(components[1] == "touch"){
                if(components[2] == "start"){
                    touchState = TouchState.Start
                    let ptX:Float32 = (components[3] as NSString).floatValue
                    let ptY:Float32 = (components[4] as NSString).floatValue
                    let js:String = "document.elementFromPoint(\(ptX), \(ptY)).tagName"
                    let tagName:String? = webView.stringByEvaluatingJavaScriptFromString(js)
                    if(tagName!.uppercaseString == "IMG") {
                        let srcJS:String = "document.elementFromPoint(\(ptX), \(ptY)).src"
                        ImageJokeViewCell.imageUrl = srcJS
                        if(ImageJokeViewCell.imageUrl != ""){
                            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "handleLongTouch", userInfo: nil, repeats: false)
                        }
                    }
                } else if(components[2] == "move") {
                    touchState = TouchState.Move
                    if(timer != nil) {
                        timer!.fire()
                    }
                } else if(components[2] == "cancel") {
                    touchState = TouchState.Cancel
                    if(timer != nil) {
                        timer!.fire()
                    }
                } else if(components[2] == "end"){
                    touchState = TouchState.End
                    if(timer != nil) {
                        timer!.fire()
                    }
                }
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.stringByEvaluatingJavaScriptFromString(ImageJokeViewCell.touchJSStr)
        disableLongPressGesturesForView(webView)
    }
    
    // 禁用图片放大镜
    func disableLongPressGesturesForView(view: UIView) {
        for subview in view.subviews {
            if let gestures = subview.gestureRecognizers as [UIGestureRecognizer]! {
                for gesture in gestures {
                    if gesture is UILongPressGestureRecognizer {
                        gesture.enabled = false
                    }
                }
            }
            disableLongPressGesturesForView(subview)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            return
        }
    }
    
    func handleLongTouch() {
        if(ImageJokeViewCell.imageUrl != "" && touchState == TouchState.Start) {
            let sheet = UIAlertController(title: "图片", message: "分享图片", preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {(action) -> Void in
                print("cancel share")
            })
            let saveAction = UIAlertAction(title: "保存到相册", style: .Destructive, handler: {(action) -> Void in
                let saveUrl = self.webView.stringByEvaluatingJavaScriptFromString(ImageJokeViewCell.imageUrl);
                if let saveUrl = saveUrl {
                    if let data = NSData(contentsOfURL: NSURL(string: saveUrl)!) {
                        if let image = UIImage(data: data) {
                            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
                        }
                    }
                }
            })
            sheet.addAction(cancelAction)
            sheet.addAction(saveAction)

            if self.parent != nil {
                parent!.presentViewController(sheet, animated: true, completion: { () -> Void in
                    print("yyyy")
                })
            }
        }
    }
    
}
