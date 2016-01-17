//
//  ImageJokeViewCell.swift
//  WxArticle
//
//  Created by tutujiaw on 16/1/17.
//  Copyright © 2016年 tujiaw. All rights reserved.
//

import UIKit
import SnapKit

class WebView : UIWebView {
    
}
class ImageJokeViewCell : UITableViewCell, UIWebViewDelegate {
    
    static let ID = "IMAGE_JOKE_VIEW_CELL_ID"
    
    let titleLabel = UILabel()
    let webView = UIWebView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        self.addSubview(webView)
        
        titleLabel.snp_makeConstraints{(make)->Void in
            make.top.equalTo(self.snp_top).offset(0)
            make.height.equalTo(30)
            make.centerX.equalTo(self.snp_centerX).offset(0)
            make.width.equalTo(self.snp_width)
        }
        
        webView.scalesPageToFit = true
        webView.scrollView.scrollEnabled = false
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
    
}
