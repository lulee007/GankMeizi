//
//  BaseModel.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/23.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import Moya
import CocoaLumberjack
import RxSwift
class BaseModel {
    var provider: RxMoyaProvider<GankIOService>
    
    var page = 1
    var offset = 20
    
    var backgroundWorkScheduler: OperationQueueScheduler!
    
    init(){
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        operationQueue.qualityOfService = NSQualityOfService.UserInitiated
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        
        let networkActivityPlugin = NetworkActivityPlugin { (change) -> () in
            
            DDLogDebug("network request: \(change)")
            
            switch (change) {
            case .Ended:
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case .Began:
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
        }
        
        self.provider = RxMoyaProvider<GankIOService>(plugins: [networkActivityPlugin ,NetworkLoggerPlugin.init()])
    }
}