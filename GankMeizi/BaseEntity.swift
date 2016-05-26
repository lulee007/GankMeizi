//
//  BaseModel.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/20.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseEntity<T: Mappable>:  Mappable{
    
    var error: Bool?
    var results: [T]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        error   <-  map["error"]
        results <-  map["results"]
    }
    
}
