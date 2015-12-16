//
//  AccountTool.swift
//  Pre-ownedHouse
//
//  Created by whb on 15/11/10.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

//+"/account.archive"
let keychainKEY = "funiLandAccount"


class AccountTool: NSObject {
    
    // 保存账号信息到钥匙串
    class func saveAccount(account: Account){
        let tempData = NSKeyedArchiver.archivedDataWithRootObject(account)
//        KeychainSwift().set(tempData, forKey: keychainKEY)
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setValue(tempData, forKey: keychainKEY)
    }
    
    // 从钥匙串获取账户信息
    class func getAccount() -> Account? {
        //       let tempData = KeychainSwift().getData(keychainKEY)
        //       let account = NSKeyedUnarchiver.unarchiveObjectWithData(tempData!)
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let tempData = userDefault.objectForKey(keychainKEY) {
            let account = NSKeyedUnarchiver.unarchiveObjectWithData(tempData as! NSData)
            return account as? Account
        } else {
            return nil
        }
    }
    
    // 删除信息
    class func delAccount(){
//        KeychainSwift().delete(keychainKEY)
        let userDefault = NSUserDefaults.standardUserDefaults()
        if userDefault.objectForKey(keychainKEY) != nil {
            userDefault.removeObjectForKey(keychainKEY)
        }
    }
}
