//
//  Response.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/28.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import UIKit
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
    var imagedic = [String: UIImage]()
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
                for oldContent in self.contentlist {
                    if url == oldContent.url {
                        continue
                    }
                }
                self.contentlist.append(item)
                
                if let url = NSURL(string: contentImg), let imgData = NSData(contentsOfURL: url), let image = UIImage(data: imgData) {
                    UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
                    image.drawInRect(CGRectMake(0, 0, 80, 80))
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    imagedic[contentImg] = newImage
                }
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
    
    func typeName(id: Int) -> String? {
        for type in typeList {
            if type.id == id {
                return type.name
            }
        }
        return nil
    }
}

struct TextJoke {
    var title = ""
    var content = ""
    var poster = ""
    var url = ""
}

class LaifuResponse {
    
    static let sharedManager = LaifuResponse()
    
    var resCode = -1
    var resError = ""
    var list = [TextJoke]()
    
    func setData(object: AnyObject) {
        let json = JSON(object)
        self.resCode = json["showapi_res_code"].int ?? -1
        self.resError = json["showapi_res_error"].string ?? ""
        
        if self.list.count > 200 {
            self.list = [TextJoke]()
        }
        if let list = json["showapi_res_body"]["list"].array {
            for item in list {
                guard let title = item["title"].string,
                    let content = item["content"].string,
                    let poster = item["poster"].string,
                    let url = item["url"].string else {
                        continue
                }
                print("poster:\(poster)")
                print("url:\(url)")
                self.list.append(TextJoke(title: title, content: content, poster: poster, url: url))
            }
        }
    }
    
    func clear() {
        list = [TextJoke]()
    }
}

struct ImgJoke {
    var title = ""
    var thumburl = ""
    var width = 0
    var height = 0
}

class ImageJokeResponse {
    var resCode = -1
    var resError = ""
    var list = [ImgJoke]()
    
    func setData(object: AnyObject) {
        let json = JSON(object)
        self.resCode = json["showapi_res_code"].int ?? -1
        self.resError = json["showapi_res_error"].string ?? ""
        
        if self.list.count > 100 {
            self.list = [ImgJoke]()
        }
        
        if let itemList = json["showapi_res_body"]["list"].array {
            for item in itemList {
                guard let title = item["title"].string,
                    let thumburl = item["thumburl"].string,
                    let width = item["width"].string,
                    let height = item["height"].string else {
                        continue
                }
                let iWidth = Int(NSString(string: width).intValue)
                let iHeight = Int(NSString(string: height).intValue)
                self.list.append(ImgJoke(title: title, thumburl: thumburl, width: iWidth, height: iHeight))
            }
        }
    }
    
    func clear() {
        list = [ImgJoke]()
    }
}
