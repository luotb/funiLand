//
//  APPSessionManage.swift
//  funiLand
//
//  Created by yangyangxun on 15/12/12.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

let DATEKEY = "defaultDateKey"
let TALONLYUUID = "talOnlyUUID"

class APPSessionManage: NSObject {

    /**
     保存离开app的时间至NSUserDefault
     */
    static func saveWillOutAppDate() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setValue(NSDate(), forKey: DATEKEY)
    }
    
    /**
     获得离开app时保存的时间
     */
    static func getOutAppDate() ->NSDate {
        let userDefault = NSUserDefaults.standardUserDefaults()
        return userDefault.objectForKey(DATEKEY) as! NSDate
    }
    
    /**
     保存一个UUID到钥匙串
     */
    static func saveUUIDToKeychain(str: String) {
        let uuidData: NSData = str.dataUsingEncoding(NSUTF8StringEncoding)!
        KeychainSwift().set(uuidData, forKey: TALONLYUUID)
    }
    
    /**
     获得UUID
     
     - returns: <#return value description#>
     */
    static func getUUIDByKeychain() -> String {
        if let tempData = KeychainSwift().getData(TALONLYUUID) {
            let uuid = String(data: tempData, encoding: NSUTF8StringEncoding)
            return uuid!
        } else {
            let uuid: String = String.randomTalId()
            APPSessionManage.saveUUIDToKeychain(uuid)
            return uuid
        }
    }
}
