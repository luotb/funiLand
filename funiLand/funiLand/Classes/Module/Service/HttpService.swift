//
//  HttpService.swift
//  Pre-ownedHouse
//
//  Created by Allen on 15/11/4.
//  Copyright © 2015年 Allen. All rights reserved.
//

import Foundation

// magic.funi.com/magic/field/app/getFieldList.json?date=201512&type=0

let TERMINALTYPE = "IPHONE"

let baseURLString = "http://magic.drmst.com/field/app/data/"
//let accountBaseURLString = "http://magic.drmst.com/field/app/"
//let baseURLString = "http://192.168.1.241:8380/funi-app-magic/field/app/data/"
//let accountBaseURLString = "http://192.168.1.241:8380/funi-app-magic/field/app/"
let accountBaseURLString = "http://192.168.3.85/magic/field/app/"
let loginURLString = "login.json"
let logoutURLString = "logout.json"
let getSupplyOrBargainListURL = "getFieldList.json"
let getRimInfoURL = "getAroundData.json"
let getLandInfoURL = "getFieldInfo.json"


class HttpService {
    let sessionManager:ESPAFHTTPSessionManager;
    
    static let sharedInstance = HttpService()
    var talId: String?
    var loginUserInfo: FLUser?
    
    class func setAppNetworkActivity(on: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = on;
    }
    
    private init() {
        //        sessionManager = AFHTTPSessionManager(baseURL: NSURL(string: baseURLString)!)
        sessionManager = ESPAFHTTPSessionManager();
        sessionManager.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode(rawValue: 0)!)
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.requestSerializer.timeoutInterval = 3;
        //        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        //        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
    }
    
    
    // 数据URL拼装
    func buildUrl(postfixUrl:String) ->String{
        return baseURLString + postfixUrl
    }
    
    // 账号URL拼装
    func accountBuildUrl(postfixUrl:String) ->String{
        return accountBaseURLString + postfixUrl
    }
    
    // login request
    func login(userInfo: FLUser, success:(msg:String)->Void,faild:(error:String)->Void){
        
//        self.talId = "qwertyuu"
        userInfo.talId = self.talId
        let params = Mapper<FLUser>().toJSON(userInfo)
        self.loginUserInfo = userInfo
        
        sessionManager.ESP_POST(self.accountBuildUrl(loginURLString), parameters: params, taskSuccessed: { (responseVO: BaseRespDomain) -> Void in
            
            if responseVO.data != nil {
                let userResp = Mapper<FLUser>().map(responseVO.data)
                if let headUrl = userResp?.headUrl {
                    self.loginUserInfo?.headUrl = headUrl
                }
            }
            
            success(msg: String_LoginSuccess)
            
            }) { (error: String) -> Void in
                faild(error: error)
        }
    }
    
    // logout
    func logout(success:(msg:String)->Void,faild:(error:String)->Void){
        
        var params:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        params["tal"] = TERMINALTYPE
        
        sessionManager.ESP_GET(self.accountBuildUrl(logoutURLString), parameters: params, taskSuccessed: { (responseVO: BaseRespDomain) -> Void in
            success(msg: String_LogoutSuccess)
            }) { (error: String) -> Void in
                faild(error: error)
        }

    }
    
    //获取供应或成交土地数据
    func getSupplyOrBargainList(type:Int, months:String,success:(landArray:Array<LandArrayRespon>?) -> Void,faild: (error:String) -> Void) {
        
        var params:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        params["type"] = type;
        params["date"] = months;
        
        sessionManager.ESP_GET(self.buildUrl(getSupplyOrBargainListURL), parameters: params, taskSuccessed: { (responseVO: BaseRespDomain) -> Void in
            
                let respArray = Mapper<LandArrayRespon>().mapArray(responseVO.data)
                success(landArray: respArray)
            
            }) { (error: String) -> Void in
                faild(error: error)
        }
    }
    
    //获取土地详情数据
    func getLandInfo(id:String, success:(landInfo:LandInfoDomain?) -> Void,faild: (error:String) -> Void) {
        
        var params:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        params["fieldCode"] = id;
        
        sessionManager.ESP_GET(self.buildUrl(getLandInfoURL), parameters: params, taskSuccessed: { (responseVO: BaseRespDomain) -> Void in
            
            let respInfo = Mapper<LandInfoDomain>().map(responseVO.data)
            success(landInfo: respInfo)
            
            }) { (error: String) -> Void in
                faild(error: error)
        }
    }
    
    //获取地图周边数据
    func getRimInfoList(rimInfo:RimInfoReqDomain, success:(rimInfoArray:Array<RimLandInfoDomain>) -> Void,faild: (error:String) -> Void) {
        
        let params = Mapper<RimInfoReqDomain>().toJSON(rimInfo)
        
        sessionManager.ESP_GET(self.buildUrl(getRimInfoURL), parameters: params, taskSuccessed: { (responseVO: BaseRespDomain) -> Void in
            if responseVO.data != nil {
                let respArray = Mapper<RimLandInfoDomain>().mapArray(responseVO.data)
                success(rimInfoArray: respArray!)
            } else {
                success(rimInfoArray: Array<RimLandInfoDomain>())
            }
            }) { (error: String) -> Void in
                faild(error: error)
        }
    }
    
    // 根据土地类型数值返回中文  0=招，1=挂，2=拍
    func getLandTypeZN(type:Int?) -> String {
        var str = ""
        if type != nil {
            switch type! {
            case 0 : str = "招"; break
            case 1 : str = "挂"; break
            case 2 : str = "拍"; break
            default: break;
            }
        }
        
        return str
    }
}

