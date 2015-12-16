//
//  LandListReq.swift
//  funiLand
//
//  Created by You on 15/12/16.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandListReq: Mappable {

    var fieldType: Int?
    var date: String?
    var tal: String?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        fieldType <- map["fieldType"]
        date <- map["date"]
        tal <- map["tal"]
    }
}
