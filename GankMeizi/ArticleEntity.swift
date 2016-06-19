//
//  Article.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/20.
//  Copyright © 2016年 lulee007. All rights reserved.
//
import Foundation
import ObjectMapper

class ArticleEntity: Mappable {
    
	var who: String?
	var _id: String?
	var desc: String?
	var publishedAt: NSDate?
	var used: Int?
	var createdAt: NSDate?
	var url: String?
	var type: String?

    
	// MARK: Mappable

    required init?(_ map: Map) {
        
    }

	func mapping(map: Map) {
		who <- map["who"]
		_id <- map["_id"]
		desc <- map["desc"]
		publishedAt <- (map["publishedAt"], MyDateFormatTransform())
		used <- map["used"]
		createdAt <- (map["createdAt"],MyDateFormatTransform())
		url <- map["url"]
		type <- map["type"]
	}
    
    
}