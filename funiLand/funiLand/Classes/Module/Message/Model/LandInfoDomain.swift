//
//  LandInfoDomain.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandInfoDomain: Mappable {
    
    var fieldList: Array<FieldGroupDomain>?
    var lat: Double?
    var lng: Double?
    var title: String?
    //区域
    var region: String?
    //宗号
    var fieldNo:String?
    
    init(){
        self.fieldList = Array<FieldGroupDomain>()
    }
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        region <- map["region"]
        fieldNo <- map["fieldNo"]
        fieldList <- map["fieldList"]
        lat <- map["lat"]
        lng <- map["lng"]
        title <- map["title"]
    }
}
