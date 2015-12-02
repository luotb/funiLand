//
//  LandArrayRespon.swift
//  funiLand
//
//  Created by You on 15/11/25.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandArrayRespon: Mappable {

//    var date: NSDate?
    var date: String?
    var dataList: [LandDomain]?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
//        date <- (map["date"], FuniDateTransform())
        date <- map["date"]
        dataList <- map["dataList"]
    }
}

public class FuniDateTransform: TransformType {
    public typealias Object = NSDate
    public typealias JSON = Double
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let timeStr = value as? String {
            return NSDate.getDateByDateStr(timeStr, format: DateFormat.format1)
        }
        return nil
    }
    
    public func transformToJSON(value: NSDate?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970)
        }
        return nil
    }
}
