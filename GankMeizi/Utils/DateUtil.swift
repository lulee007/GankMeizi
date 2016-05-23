//
//  DateUtil.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/23.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation

public class DateUtil {

    static let  DATE_FORMATTER = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    public static func stringToNSDate(dateString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sssZ"
        return dateFormatter.dateFromString( dateString )!
    }
    
   public static func areDatesSameDay(dateOne:NSDate,dateTwo:NSDate) -> Bool {
        let calender = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = [.Day, .Month, .Year]
        let compOne: NSDateComponents = calender.components(flags, fromDate: dateOne)
        let compTwo: NSDateComponents = calender.components(flags, fromDate: dateTwo);
        return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year);
    }

}