//
//  LandInfoDomain.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandInfoDomain: Mappable {
    
    var area: String?
    var date: String?
    var fieldList: Array<FieldGroupDomain>?
    var lat: Double?
    var lng: Double?
    var title: String?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        area <- map["area"]
        date <- map["date"]
        fieldList <- map["fieldList"]
        lat <- map["lat"]
        lng <- map["lng"]
        title <- map["title"]
    }
}
