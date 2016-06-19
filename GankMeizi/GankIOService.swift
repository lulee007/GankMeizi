//
//  GankIOService.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/20.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import Moya

class GankIO {
    static let HOST = "http://gank.io"
    static let PATH_API = "/api"
    
}

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
    
    // 搜索
    case Search(text: String,category: String,count: Int,page: Int)
    
}

extension GankIOService: TargetType {
    
    var baseURL: NSURL {return NSURL(string: GankIO.HOST)!}
    var path: String {
        switch self {
        case .RandomByKindAndCount(let kind,let count):
            return "\(GankIO.PATH_API)/random/data/\(kind)/\(count)"
        case .ByDay(let year, let month , let day):
            return "\(GankIO.PATH_API)/day/\(year)/\(month)/\(day)"
        case .HistoryDays:
            return "\(GankIO.PATH_API)/day/history"
        case .ByPageAndKind(let kind,let page,let count):
            return "\(GankIO.PATH_API)/data/\(kind)/\(count)/\(page)"
        case .HtmlByDay(let year, let month, let day):
            return "\(GankIO.PATH_API)/history/content/day/\(year)/\(month)/\(day)"
        case .HtmlByPage(let page, let count):
            return "\(GankIO.PATH_API)/history/content/\(count)/\(page)"
        case .Search(let text,let category,let count,let page):
            return "\(GankIO.PATH_API)/search/query/\(text)/category/\(category)/count/\(count)/page/\(page)"
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