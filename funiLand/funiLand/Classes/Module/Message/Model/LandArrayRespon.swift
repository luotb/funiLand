//
//  LandArrayRespon.swift
//  funiLand
//
//  Created by You on 15/11/25.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandArrayRespon: Mappable {

    var date: NSDate?
    var dataList: [LandDomain]?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        dataList <- map["dataList"]
    }
}
