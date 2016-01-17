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
    var typeId: Int = -1
    var key: String = ""
    var page: Int = -1
    
    init(typeId: Int, key: String, page: Int) {
        super.init(appId: 12078)
        self.typeId = typeId
        self.key = key
        self.page = page
    }
    
    init(page: Int, key: String) {
        super.init(appId: 12078)
        self.page = page
        self.key = key
    }
    
    var url: String {
        var params = [(String, String)]()
        if typeId >= 0 {
            params.append(("typeId", String(typeId)))
        }
        if !key.isEmpty {
            params.append(("key", key))
        }
        if page > 1 {
            params.append(("page", String(page)))
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

class JokeTextRequest : Request {
    var url: String {
        let sign = super.sign([(String, String)](), secret: "c7288cbf5a0941598e3ab326c27f9668")
        return super.url("http://route.showapi.com/107-32", sign: sign)
    }
    
    init() {
        super.init(appId: 12078)
    }
}

class ImageJokeRequest : Request {
    var time: String = ""
    var page: Int = 0
    var maxResult: Int = 0
    
    var url: String {
        let params = [("time", self.time), ("page", String(self.page)), ("maxResult", String(self.maxResult))]
        let sign = super.sign(params, secret: "c7288cbf5a0941598e3ab326c27f9668")
        return super.url("http://route.showapi.com/107-33", sign: sign)
    }
    
    init(time: String = NSDate.currentDate("yyyy-MM-dd"), page: Int = 1, maxResult: Int = 20) {
        super.init(appId: 12078)
        self.time = time
        self.page = page
        self.maxResult = maxResult
    }
}

