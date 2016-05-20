//
//  GankIOService.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/20.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
enum GankIOService {
    // 随机获取某类指定个数的数据
    case RandomByKindAndCount(kind:String,count:Int)
    
    // 某天数据
    case ByDay(year:Int,month:Int,day:Int)
    
    // 分页获取某类数据
    case ByPageAndKind(kind:String,page:Int,count:Int)
    
    // 获取某日网站的 html 数据
    case HtmlByDay(year:Int,month:Int,day:Int)
    
    // 分页获取网站的 html 数据
    case HtmlByPage(page:Int,count:Int)
    
}

//extension GankIOService: TargetType