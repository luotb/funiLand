//
//  Account.swift
//  Pre-ownedHouse
//
//  Created by whb on 15/11/10.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

class Account: NSObject, NSCoding {
    
    var loginName:String?
    var password: String?
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.loginName, forKey: "loginName")
        aCoder.encodeObject(self.password, forKey: "password")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.loginName = aDecoder.decodeObjectForKey("loginName") as? String
        self.password = aDecoder.decodeObjectForKey("password") as? String
    }
    
    override init() {
        
    }
    
    
}
