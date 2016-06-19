//
//  MyDateFormatTransform.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/6/19.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import ObjectMapper

// 扩展String

extension String {
    func substring(s: Int, _ e: Int? = nil) -> String {
        let start = s >= 0 ? self.startIndex : self.endIndex
        let startIndex = start.advancedBy(s)
        
        var end: String.Index
        var endIndex: String.Index
        if(e == nil){
            end = self.endIndex
            endIndex = self.endIndex
        } else {
            end = e >= 0 ? self.startIndex : self.endIndex
            endIndex = end.advancedBy(e!)
        }
        
        let range = Range<String.Index>(startIndex..<endIndex)
        return self.substringWithRange(range)
        
    }
}
 
public class MyDateFormatTransform:  TransformType{

    let formatter: NSDateFormatter

    public init(){
        formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")

    }
    
    public  func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let dateString = value as? String {
            //yyyy-MM-dd'T'HH:mm:ss
            //yyyy-MM-dd HH:mm:ss
            
            if(dateString.containsString("T")){
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

            }else{
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            }
            let tDateString = dateString.substring(0, 19)
            return formatter.dateFromString(tDateString)
            
        }
        return nil
    }
    
    public func transformToJSON(value: NSDate?) -> String? {
        if let date = value {
            return formatter.stringFromDate(date)
        }
        return nil

    }
}