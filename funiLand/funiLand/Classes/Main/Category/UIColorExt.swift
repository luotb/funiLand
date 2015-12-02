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
    static func getLandTypeColor(type: Int?) -> UIColor {
        var str = Color_Zhao
        if type != nil {
            switch type! {
            case 0 : str = Color_Zhao; break
            case 1 : str = Color_Gua; break
            case 2 : str = Color_Pai; break
            default: break;
            }
        }
        
        return UIColor.colorFromHexString(str)
    }
}
