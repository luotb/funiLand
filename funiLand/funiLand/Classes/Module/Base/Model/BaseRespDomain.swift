//
//  BaseRespDomain.swift
//  funiLand
//
//  Created by You on 15/11/30.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class BaseRespDomain: Mappable {
    
    var code: Int?
    var remark: String?
    var total: Int?
    var data: AnyObject?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        total <- map["total"]
        code <- map["code"]
        remark <- map["remark"]
        data <- map["data"]
    }

}
