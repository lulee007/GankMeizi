//
//  DailyArticleModel.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/24.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import RxSwift
import CocoaLumberjack
import ObjectMapper

class DailyArticleModel: BaseModel {
    
    override init() {
        super.init()
    }
    
    
    func getArticleByDate(date: NSDate) -> Observable<DailyArticleEntity> {
        let components = NSCalendar.currentCalendar().components([.Day,.Month,.Year], fromDate: date)
        return  provider.request(GankIOService.ByDay(year: components.year, month: components.month, day: components.day))
            .observeOn(backgroundWorkScheduler)
            .map({ (response) ->  DailyArticleEntity in
                let result = Mapper<DailyArticleEntity>().map(String(data:response.data,encoding: NSUTF8StringEncoding))
                return result!
            })
            .observeOn(MainScheduler.instance)
    }
}