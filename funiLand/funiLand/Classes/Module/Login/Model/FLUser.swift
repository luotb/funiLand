//
//  FLUser.swift
//  funiLand
//
//  Created by You on 15/11/26.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class FLUser: BaseDomain {

    var loginName: NSString?
    var password: NSString?
    
    init(name:NSString, pwd:NSString) {
        self.loginName = name
        self.password = pwd
    }
}
