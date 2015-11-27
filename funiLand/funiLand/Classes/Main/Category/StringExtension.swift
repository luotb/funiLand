//
//  StringExtension.swift
//  funiLand
//
//  Created by You on 15/11/27.
//  Copyright © 2015年 funi. All rights reserved.
//

import Foundation

let LocalStr_None   = ""

extension String {
    
    //获取uuid
    func gen_uuid() -> String {
        let uuid_ref = CFUUIDCreate(nil)
        let uuid_string_ref = CFUUIDCreateString(nil, uuid_ref);
//        CFRelease(uuid_ref);
        let uuid = uuid_string_ref as String
//        CFRelease(uuid_string_ref);
        return uuid;
    }
    
    
    /**
    * 判断str里面是否包含数字
    * @return   YES包含   NO不包含
    */
    func isIncludeNumber(str: String) -> Bool {
        let regex     = "(^[A-Za-z0-9]+$)"
        let pred = NSPredicate(format: "SELF MATCHES \(regex)", NSNumber(int: 24))
        let isMatch          = pred.evaluateWithObject(str);
        if(isMatch) {
            return false;
        }
        return true;
    }
    
    
    
    /**
    *  清除字符串两头空格
    *
    *  @param string 源字符串
    *
    *  @return 返回是否为空
    */
    func trimString(str: String) -> String {
        return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
}
