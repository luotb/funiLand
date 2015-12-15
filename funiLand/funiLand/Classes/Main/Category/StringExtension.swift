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
    static func gen_uuid() -> String {
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
    static func isIncludeNumber(str: String) -> Bool {
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
    
    //手机号码验证
    static func validateMobile(mobile:String) -> Bool
    {
    //手机号以13， 15，18开头，八个 \d 数字字符
        let mobileReg = "^((13[0-9])|(17[0])|(15[^4,\\D])|(18[0,2,3,5-9]))\\d{8}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobileReg)
        
        if regextestmobile.evaluateWithObject(mobile)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // 排除空
    static func excludeEmpty(param: AnyObject?) -> String {
        
        if let p = param {
            
            switch p {
            case let someInt as Int:
                return String(someInt)
            case let someDouble as Double where someDouble > 0:
                return String(someDouble)
            case is Double:
                return String(p)
            case let someString as String:
                return someString
            default:  
                return String(p)
            }
        } else {
            return ""
        }
    }
    
    /// MD5加密
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestLen)
        return String(format: hash as String)
    }
    
    /**
     生成UUID
     
     - returns: <#return value description#>
     */
    static func randomTalId() -> String
    {
       return NSUUID().UUIDString
    }
    
}
