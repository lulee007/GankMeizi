//
//  HtmlArticleEntity.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/20.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import ObjectMapper

class HtmlArticleEntity: Mappable {
    let DATE_FORMATTER = "yyyy-MM-dd'T'HH:mm:sssZ"

    var _id: String?
    var content: String?
    var publishedAt: NSDate?
    var title: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
    
        _id         <-  map["_id"]
        content     <-  map["content"]
        publishedAt <-  (map["publishAt"],CustomDateFormatTransform(formatString: DATE_FORMATTER))
        title       <-  map["title"]
    }
    
    
}

