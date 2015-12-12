//
//  DataManager.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/28.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import Foundation

enum DataType {
    case None
    case GoodArticle
    case Category
    case SearchArticle
}

class Data {
    static let sharedManager = Data()
    
    var goodArticle = GoodArticleResponse()
    var category = CategoryResponse()
    var searchArticle = GoodArticleResponse()
}
