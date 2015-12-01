//
//  FieldGroupDomain.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class FieldGroupDomain: Mappable {

    var group: String?
    var groupField: Array<FieldDomain>?
    
    init(){}
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        group <- map["group"]
        groupField <- map["groupField"]
    }
}
