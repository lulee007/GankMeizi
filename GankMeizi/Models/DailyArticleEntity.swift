//
//  DailyArticleModel.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/20.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import ObjectMapper

class DailyArticleEntity:  Mappable{
    
    var category: [String]?
    var error: Bool?
    var results:[String:[ArticleEntity]]?
    
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        category    <-  map["category"]
        error       <-  map["error"]
        results     <-  map["results"]
    }
    
}