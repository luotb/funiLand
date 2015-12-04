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
    //已成交未呈现=4；已成交已呈现=3；未成交土地=2
    var fieldType: Int?
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
        fieldType <- map["fieldType"]
        keyword <- map["keyword"]
    }
}
