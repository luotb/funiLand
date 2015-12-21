//
//  RimLandInfoDomain.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class RimLandInfoDomain: Mappable {
    
    //id
    var id:String?
    // 包含单位 亩
    var netAreaMu: String?
    // 1=土地，2=项目
    var dataType: Int?
    //已成交未呈现=4；已成交已呈现=3；未成交土地=2
    var fieldType: Int?
    // 规则：小于1000m 返回值单位m 大于等于1000m 返回值单位 km
    var distance: String?
    //用地性质
    var fieldusageName: String?
    var lat: Double?
    var lng: Double?
    var lat2: String?
    var lng2: String?
    //土地位置
    var address: String?
    var title: String?
    // 挂牌时间
    var transferDate: String?
    // 出让日期
    var dealDate: String?
    // 0=招，1=挂，2=拍
    var type: String?
    // 最大容积率
    var cubagerateMax:CGFloat?

    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        netAreaMu <- map["netAreaMu"]
        dataType <- map["dataType"]
        fieldType <- map["fieldType"]
        distance <- map["distance"]
        fieldusageName <- map["fieldusageName"]
        lat <- map["lat"]
        lng <- map["lng"]
        address <- map["address"]
        title <- map["title"]
        transferDate <- map["transferDate"]
        dealDate <- map["dealDate"]
        type <- map["type"]
        cubagerateMax <- map["cubagerateMax"]
    }
}
