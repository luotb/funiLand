//
//  RimInfoRespDomain.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class RimInfoRespDomain: Mappable {
    
    var distance: Int?
    var lat: Double?
    var lng: Double?
    var check1: Bool = false
    var check2: Bool = false
    var check3: Bool = false

    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        distance <- map["distance"]
        lat <- map["lat"]
        lng <- map["lng"]
        check1 <- map["check1"]
        check2 <- map["check2"]
        check3 <- map["check3"]
    }
}
