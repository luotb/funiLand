//
//  RimLandInfoDomain.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class RimLandInfoDomain: Mappable {
    
    // 包含单位 亩
    var area: String?
    // 0=土地，1=项目
    var categorg: Int?
    // 规则：小于1000m 返回值单位m 大于等于1000m 返回值单位 km
    var distance: String?
    //用地性质
    var landProperty: String?
    var lat: Double?
    var lng: Double?
    var title: String?
    // 挂牌时间
    var transferDate: String?
    // 0=招，1=挂，2=拍
    var type: Int?

    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        area <- map["area"]
        categorg <- map["categorg"]
        distance <- map["distance"]
        landProperty <- map["landProperty"]
        lat <- map["lat"]
        lng <- map["lng"]
        title <- map["title"]
        transferDate <- map["transferDate"]
        type <- map["type"]
    }
}
