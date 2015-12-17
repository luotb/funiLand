//
//  UIColorExt.swift
//  Pre-ownedHouse
//
//  Created by whb on 15/11/11.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

let Color_Zhao = "#1548ED"
let Color_Gua = "#09B736"
let Color_Pai = "#ED6715"
let Color_Def = "#FFFFFF"

extension UIColor {
     class func colorFromHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

    // 根据土地类型返回对应颜色
    static func landTypeColor(type: String?) -> UIColor {
        var str = Color_Def
        if type != nil {
            switch type! {
            case "招" : str = Color_Zhao; break
            case "挂" : str = Color_Gua; break
            case "拍" : str = Color_Pai; break
            default: break;
            }
        }
        
        return UIColor.colorFromHexString(str)
    }
    
    /**
     导航栏背景颜色
     
     - returns: <#return value description#>
     */
    static func navBarBgColor() -> UIColor {
        return UIColor.colorFromHexString("#227CFE")
    }
    
    /**
     tabbar选中 字体颜色
     
     - returns: <#return value description#>
     */
    static func didSelectedTabBarTitleColor() -> UIColor {
        return UIColor.colorFromHexString("#FFF000")
    }
    
    //输入框文本颜色
    static func inputTextColor() -> UIColor {
        return UIColor.colorFromHexString("#AAD2FD")
    }
    
    static func textColor1() -> UIColor {
        return UIColor.colorFromHexString("#546180")
    }
    
    static func textColor2() -> UIColor {
        return UIColor.colorFromHexString("#28A4FF")
    }
    
    static func textColor3() -> UIColor {
        return UIColor.colorFromHexString("#ED6715")
    }
    
    static func borderColor1() -> UIColor {
        return UIColor.colorFromHexString("#00A2FF")
    }
    
    static func borderColor2() -> UIColor {
        return UIColor.colorFromHexString("#858585")
    }
    
    static func didSelectedSegmentColor() -> UIColor {
        return UIColor.colorFromHexString("#0C70D6")
    }
    
    static func defSegmentTextColor() -> UIColor {
        return UIColor.colorFromHexString("#1053A2")
    }
    
    static func calendarDotViewBgColor() -> UIColor {
        return UIColor.colorFromHexString("#07308F")
    }
    
    static func tableViewHeadBgColor() -> UIColor {
        return UIColor.colorFromHexString("#ECEFF3")
    }
}
