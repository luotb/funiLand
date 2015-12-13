//
//  APPSessionManage.swift
//  funiLand
//
//  Created by yangyangxun on 15/12/12.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

let DATEKEY = "defaultDateKey"

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
}
