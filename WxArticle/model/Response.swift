//
//  Response.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/28.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation
import SwiftyJSON

class Response {
    var showapi_res_code = 0
    var showapi_res_error = ""
    
    init(resCode: Int, resError: String) {
        self.showapi_res_code = resCode
        self.showapi_res_error = resError
    }
}

struct ContentList {
    var id = ""
    var title = ""
    var typeId = 0
    var typeName = ""
    var url = ""
    var contentImg = ""
    var userLog = ""
    var userName = ""
    var userLogo_code = ""
}

class GoodArticleResponse: Response {
    var contentlist = [ContentList]()
    var maxResult = 0
    var allNum = 0
    var allPages = 0
    var currentPage = 0
    
    init() {
        super.init(resCode: -1, resError: "")
    }
    
    func setData(object: AnyObject) {
        let json = JSON(object)
        super.showapi_res_code = json["showapi_res_code"].int ?? -1
        super.showapi_res_error = json["showapi_res_error"].string ?? ""
        
        let pagebean = json["showapi_res_body"]["pagebean"]
        self.maxResult = pagebean["maxResult"].int ?? 0
        self.allNum = pagebean["allNum"].int ?? 0
        self.allPages = pagebean["allPages"].int ?? 0
        self.currentPage = pagebean["currentPage"].int ?? 0
        if let contentlist = pagebean["contentlist"].array {
            for content in contentlist {
                guard let title = content["title"].string,
                    let url = content["url"].string,
                    let contentImg = content["contentImg"].string,
                    let userName = content["userName"].string
                    else {
                        print(content)
                        continue
                }
                var item = ContentList()
                item.title = title
                item.url = url
                item.contentImg = contentImg
                item.userName = userName
                self.contentlist.append(item)
            }
        }
    }
}

struct TypeList {
    var id = 0
    var name = ""
}

class CategoryResponse : Response {
    var typeList = [TypeList]()
    
    init() {
        super.init(resCode: -1, resError: "")
    }
    
    func setData(object: AnyObject) {
        let json = JSON(object)
        super.showapi_res_code = json["showapi_res_code"].int ?? -1
        super.showapi_res_error = json["showapi_res_error"].string ?? ""
        self.typeList = [TypeList]()
        if let typeList = json["showapi_res_body"]["typeList"].array {
            for type in typeList {
                print(type)
                guard let id = type["id"].string, let name = type["name"].string else {
                    continue
                }
                self.typeList.append(TypeList(id: Int(NSString(string: id).intValue), name: name))
            }
            self.typeList.sortInPlace{$0.id < $1.id}
        }
    }
}