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
    var netAreaMu: String?
    // 0=土地，1=项目
    var dataType: Int?
    // 规则：小于1000m 返回值单位m 大于等于1000m 返回值单位 km
    var distance: String?
    //用地性质
    var fieldusageName: String?
    var lat: Double?
    var lng: Double?
    //土地位置
    var address: String?
    var title: String?
    // 挂牌时间
    var transferDate: String?
    // 0=招，1=挂，2=拍
    var type: Int?
    // 最大容积率
    var cubagerateMax:Int?

    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        netAreaMu <- map["netAreaMu"]
        dataType <- map["dataType"]
        distance <- map["distance"]
        fieldusageName <- map["fieldusageName"]
        lat <- map["lat"]
        lng <- map["lng"]
        address <- map["address"]
        title <- map["title"]
        transferDate <- map["transferDate"]
        type <- map["type"]
    }
}
