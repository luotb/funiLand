//
//  Account.swift
//  Pre-ownedHouse
//
//  Created by whb on 15/11/10.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

class Account: NSObject {
    
    var loginName:String?
    
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.loginName, forKey: "loginName")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.loginName = aDecoder.decodeObjectForKey("loginName") as? String
    }
    
    override init() {
        
    }
    
    
}
