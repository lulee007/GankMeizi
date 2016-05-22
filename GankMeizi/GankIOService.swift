//
//  GankIOService.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/20.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import Moya
enum GankIOService {
    // 随机获取某类指定个数的数据
    case RandomByKindAndCount(kind:String,count:Int)
    
    // 某天数据
    case ByDay(year:Int,month:Int,day:Int)
    
    // 获取发过干货的日期
    case HistoryDays
    
    // 分页获取某类数据
    case ByPageAndKind(kind:String,page:Int,count:Int)
    
    // 获取某日网站的 html 数据
    case HtmlByDay(year:Int,month:Int,day:Int)
    
    // 分页获取网站的 html 数据
    case HtmlByPage(page:Int,count:Int)
    
}

extension GankIOService: TargetType {
    var baseURL: NSURL {return NSURL(string: "http://gank.io/api")!}
    var path: String{
        switch self {
        case .RandomByKindAndCount(let kind,let count):
            return "/random/data/\(kind)/\(count)"
        case .ByDay(let year, let month , let day):
            return "/day/\(year)/\(month)/\(day)"
        case .HistoryDays:
            return "/day/history"
        case .ByPageAndKind(let kind,let page,let count):
            return "/data/\(kind)/\(count)/\(page)"
        case .HtmlByDay(let year, let month, let day):
            return "/history/content/day/\(year)/\(month)/\(day)"
        case .HtmlByPage(let page, let count):
            return "/history/content/\(count)/\(page)"
        }
    }
    
    var method: Moya.Method  {
        switch self {
        default:
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        default:
            return nil
        }
    }
    
    var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
    
}