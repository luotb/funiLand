//
//  NSDateExtension.swift
//  funiLand
//
//  Created by You on 15/11/27.
//  Copyright © 2015年 funi. All rights reserved.
//

import Foundation

enum DateFormat {
    case format1
    case format2
    case format3
    case format4
}

extension NSDate {
    
    class func getTime(format: DateFormat, var date: NSDate?) -> String {
        // 获取系统当前时间
        if date == nil {
            date = NSDate()
        }
        let sec = date!.timeIntervalSinceNow
        let currentDate = NSDate.init(timeIntervalSinceNow: sec)
        
        //设置时间输出格式：
        let df = NSDateFormatter()
        
        switch format {
            case DateFormat.format1 :
                df.dateFormat = "yyyy-MM-dd"
            case DateFormat.format2 :
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            case DateFormat.format3 :
                df.dateFormat = "yyyyMMddHHmmss"
            case DateFormat.format4 :
                df.dateFormat = "yyyy-MM"
        }
        
        let na = df.stringFromDate(currentDate)
        
        return na;
    }
    
    func millisecond() -> String {
        
        let time = NSDate().timeIntervalSince1970 * 1000
        return "\(time)"
    }
    
    //时间格式的字符串转日期对象
    class func getDateByDateStr(str: String, format: DateFormat) ->NSDate {
        let df =  NSDateFormatter()
        switch format {
        case DateFormat.format1 :
            df.dateFormat = "yyyy-MM-dd"
        case DateFormat.format2 :
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        case DateFormat.format3 :
            df.dateFormat = "yyyyMMddHHmmss"
        case DateFormat.format4 :
            df.dateFormat = "yyyy-MM"
        }
        return  df.dateFromString(str)!
    }
    
}
