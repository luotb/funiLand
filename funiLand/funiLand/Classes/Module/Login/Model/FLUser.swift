//
//  FLUser.swift
//  funiLand
//
//  Created by You on 15/11/26.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class FLUser: Mappable {

    var loginName: String?
    var passWord: String?
    var tal:String = TERMINALTYPE
    var talId:String?
    var headUrl:String?
    
    init(name:String, pwd:String) {
        self.loginName = name
        self.passWord = pwd
    }
    
    init(account: Account) {
        self.loginName = account.loginName
        self.passWord = account.passWord
        self.tal = TERMINALTYPE
        self.talId = APPSessionManage.getUUIDByKeychain()
    }
    
    required init?(_ map: Map){
        mapping(map)
    }
    
    func mapping(map: Map) {
        loginName <- map["loginName"]
        passWord <- map["passWord"]
        tal <- map["tal"]
        talId <- map["talId"]
        headUrl <- map["headUrl"]
    }
}
