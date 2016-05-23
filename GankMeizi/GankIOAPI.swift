//
//  GankIOAPI.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/20.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import Moya
import CocoaLumberjack
import ObjectMapper
import RxSwift

class GankIOAPI {
    
    var provider: RxMoyaProvider<GankIOService>
    
    /**
     初始化 provider 并添加插件：<p/>
     1. 网络请求日志<p/>
     2. 根据请求状态 同步显示到 导航栏的网络请求<p/>
     - returns:
     */
    init() {
        let networkActivityPlugin = NetworkActivityPlugin { (change) -> () in
            
            DDLogDebug("networkPlugin \(change)")
            switch(change){
            case .Ended:
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case .Began:
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
        }
        
        self.provider = RxMoyaProvider<GankIOService>(plugins: [networkActivityPlugin ,NetworkLoggerPlugin.init()])
        
    }
    
    
//    func getByDay(year: Int, month: Int, day: Int)  {
//        
//        self.gankioProvider.request(.ByDay(year: year, month: month, day: day)) { (result) in
//            
//            if result.error == nil {
//                let data =  Mapper<DailyArticleEntity>().map(String(data: (result.value?.data)!, encoding: NSUTF8StringEncoding))
//                
//                DDLogDebug(Mapper().toJSONString(data!, prettyPrint: true)!)
//                
//            }else{
//                print(result.error)
//            }
//        }
//    }
    
    func getArticleInfoByPage(page: Int, count: Int) -> Observable<[HtmlArticleEntity]> {
        return provider.request(GankIOService.HtmlByPage(page: page, count: count))
        .debug()
        .map({ (response) -> [HtmlArticleEntity] in
            let result = Mapper<BaseEntity<HtmlArticleEntity>>().map(String(data: response.data,encoding:  NSUTF8StringEncoding))
            
            return (result?.results)!
        })
        
        
    }
    
    
}