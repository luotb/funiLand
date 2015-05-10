//
//  RimInfoRespDomain.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class RimInfoReqDomain: Mappable {
    
    var distance: Int?
    var lat: Double?
    var lng: Double?
    //关键词
    var keyword: String?
    
    init(){
        self.distance = 2
    }
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        distance <- map["distance"]
        lat <- map["lat"]
        lng <- map["lng"]
        keyword <- map["keyword"]
    }
}
