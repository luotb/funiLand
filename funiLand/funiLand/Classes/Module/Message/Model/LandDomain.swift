//
//  LandDomain.swift
//  funiLand
//
//  Created by You on 15/11/25.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandDomain: Mappable {
    
    var id: String?
    var title: String?
    var description1: String?
    var description2: String?
    var type:String?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        description1 <- map["description1"]
        description2 <- map["description2"]
        type <- map["type"]
    }
}
