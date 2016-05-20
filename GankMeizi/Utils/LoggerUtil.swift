//
//  LoggerUtil.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/19.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import CocoaLumberjack

class LoggerUtil {
    
    /**
     * 初始化 CocoaLumberjack DDLog <p/>
     * 包括 Xcode console 和 File Logger
     */
    static func initLogger(){
        DDLog.addLogger(DDTTYLogger.sharedInstance()) // TTY = Xcode console
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60*60*24  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger)
        DDLogDebug("DDLog inited");
    }
    
    
}