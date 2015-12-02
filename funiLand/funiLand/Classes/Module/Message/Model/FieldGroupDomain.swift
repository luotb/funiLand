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
    var groupFields: Array<FieldDomain>?
    
    init(){
        self.groupFields = Array<FieldDomain>()
    }
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        group <- map["group"]
        groupFields <- map["groupFields"]
    }
}
