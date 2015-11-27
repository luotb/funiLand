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
}

extension NSDate {
    
    func getTime(format: DateFormat) -> String {
        // 获取系统当前时间
        let date = NSDate()
        let sec = date.timeIntervalSinceNow
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
        }
        
        let na = df.stringFromDate(currentDate)
        
        return na;
    }
    
    func millisecond() -> String {
        
        let time = NSDate().timeIntervalSince1970 * 1000
        return "\(time)"
    }
    
}
