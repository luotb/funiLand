//
//  FieldDomain.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class FieldDomain: Mappable {

    var name: String?
    var value: String?
    var height: CGFloat?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        value <- map["value"]
    }
}
