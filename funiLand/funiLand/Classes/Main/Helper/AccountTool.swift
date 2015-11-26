//
//  AccountTool.swift
//  Pre-ownedHouse
//
//  Created by whb on 15/11/10.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

//+"/account.archive"
let filePath=(NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("account.archive")


class AccountTool: NSObject {
    
    class var account:Account?{
        get{
            return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? Account;
        }
        set{
            NSKeyedArchiver.archiveRootObject(newValue!, toFile: filePath)
        }
    }

}
