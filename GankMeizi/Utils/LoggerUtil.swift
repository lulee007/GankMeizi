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
        DDTTYLogger.sharedInstance().logFormatter = LogFormatter()
        DDLog.addLogger(DDTTYLogger.sharedInstance()) // TTY = Xcode console
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60*60*24  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger)
        DDLogDebug("DDLog inited");
    }
    
    class LogFormatter : NSObject,DDLogFormatter
    {
        func formatLogMessage(logMessage: DDLogMessage!) -> String! {
            
            let dateAndTimeFormatter = NSDateFormatter()
            dateAndTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
            let dateAndTime = dateAndTimeFormatter.stringFromDate(logMessage.timestamp)
            
            return "[\(dateAndTime) -\(stringForLogLevel(logMessage.flag)) \(logMessage.fileName) \(logMessage.function): \(logMessage.line) ]: \(logMessage.message)"
        }
        
        private func stringForLogLevel(logflag:DDLogFlag) -> String {
            switch(logflag) {
            case DDLogFlag.Error:
                return "E"
            case DDLogFlag.Warning:
                return "W"
            case DDLogFlag.Info:
                return "I"
            case DDLogFlag.Debug:
                return "D"
            case DDLogFlag.Verbose:
                return "V"
            default:
                break
            }
            return ""
        }
    }
    
    
}