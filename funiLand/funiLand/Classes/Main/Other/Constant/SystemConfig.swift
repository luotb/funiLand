//
//  SystemConfig.swift
//  funiLand
//
//  Created by yangyangxun on 15/11/26.
//  Copyright © 2015年 funi. All rights reserved.
//

import Foundation


//let APPWIDTH = UIScreen.mainScreen().bounds.width
//let APPHEIGHT = UIScreen.mainScreen().bounds.height
let APPWIDTH = ((UIApplication.sharedApplication().delegate) as! AppDelegate).window!.frame.size.width
let APPHEIGHT = ((UIApplication.sharedApplication().delegate) as! AppDelegate).window!.frame.size.height
let APPWIDTH_4 = CGFloat(320)

let UMengAppKey   = "565d0d2f67e58e39d4001770"
let TENCENT_BUGLY = "900014227"
let APPCHANNEL    = "APP Store"

// String
let String_RequestError_Msg_1001          = "网络错误,请稍后再试!"
let String_RequestError_Msg_1009          = "网络不给力哦 请检查您是否在冲浪!"
let String_LoginSuccess                            = "登录成功!"
let String_LogoutSuccess                            = "登出成功!"
let Number_Lat        =        0.006471
let Number_Lng        =        0.005992
let CD_Lat            = 104.072254
let CD_Lng            = 30.663558

