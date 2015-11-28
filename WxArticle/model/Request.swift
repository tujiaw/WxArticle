//
//  Request.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/28.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation

class Request {
    var appId: Int
    
    var timestamp: String {
        return NSDate.currentDate("yyyyMMddHHmmss")
    }
    
    var signMethod = "md5"
    
    var resGzip = 0
    
    var allParams = [(String, String)]()
    
    init(appId: Int) {
        self.appId = appId
    }
    
    func sign(appParams: [(String, String)], secret: String) -> String {
        self.allParams = appParams
        self.allParams.append(("showapi_appid", String(self.appId)))
        self.allParams.append(("showapi_timestamp", self.timestamp))
        
        let sortedParams = allParams.sort{$0.0 < $1.0}
        var str = ""
        for item in sortedParams {
            str += (item.0 + item.1)
        }
        str += secret.lowercaseString
        return str.md5()
    }
    
    func url(mainUrl: String, sign: String) -> String {
        var url = mainUrl + "?"
        for param in self.allParams {
            url += "\(param.0)=\(param.1)&"
        }
        url += "showapi_sign=\(sign)"
        return url
    }
}

class GoodArticleRequest : Request {
    var typeId: Int = 0
    var key: String = ""
    var page: Int = 1
    
    init(typeId: Int, key: String, page: Int) {
        super.init(appId: 12078)
        self.typeId = typeId
        self.key = key
        self.page = page
    }
    
    var url: String {
        var params = [("typeId", String(typeId)), ("page", String(page))]
        if !key.isEmpty {
            params.append(("key", key))
        }
        let sign = super.sign(params, secret: "c7288cbf5a0941598e3ab326c27f9668")
        return super.url("http://route.showapi.com/582-2", sign: sign)
    }
}

class CategoryRequest: Request {
    init() {
        super.init(appId: 12078)
    }
    
    var url: String {
        let params = [(String, String)]()
        let sign = super.sign(params, secret: "c7288cbf5a0941598e3ab326c27f9668")
        return super.url("http://route.showapi.com/582-1", sign: sign)
    }
}
