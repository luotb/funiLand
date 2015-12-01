//
//  HttpService.swift
//  Pre-ownedHouse
//
//  Created by Allen on 15/11/4.
//  Copyright © 2015年 Allen. All rights reserved.
//

import Foundation

let tal = "IPHONE"
let baseURLString = "http://192.168.1.241:8090/rap/mockjs/1/"
//let baseURLString = "http://cn.rapapi.net/mockjs/302/"
let loginURLString = "login.json"
let getSupplyOrBargainListURL = "getSupplyOrBargainList.json"
let getRimInfoURL = "getRimInfo.json"
let getLandInfoURL = "getLandInfo.json"


class HttpService {
    let sessionManager:ESPAFHTTPSessionManager;
    
    static let sharedInstance = HttpService()
    
    private init() {
        //        sessionManager = AFHTTPSessionManager(baseURL: NSURL(string: baseURLString)!)
        sessionManager = ESPAFHTTPSessionManager();
        sessionManager.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode(rawValue: 0)!)
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.requestSerializer.timeoutInterval = 3;
        //        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        //        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
    }
    
    
    //URL拼装
    func buildUrl(postfixUrl:String) ->String{
        return baseURLString + postfixUrl
    }
    
    // login request
    func login(loginName: String, pwd: String, success:(msg:String)->Void,faild:(error:String)->Void){
        
        var params:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        params["loginName"] = loginName;
        params["passWord"] = pwd;
        params["tal"] = tal;
        
        sessionManager.ESP_POST(self.buildUrl(loginURLString), parameters: params, taskSuccessed: { (responseVO: BaseRespDomain) -> Void in
                success(msg: String_LoginSuccess)
            }) { (error: String) -> Void in
                faild(error: error)
        }
    }
    
    //获取供应或成交土地数据
    func getSupplyOrBargainList(type:Int, months:String,success:(landArray:Array<LandArrayRespon>?) -> Void,faild: (error:String) -> Void) {
        
        var params:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        params["type"] = type;
        params["date"] = months;
        
//        sessionManager.responseSerializer = AFJSONResponseSerializer()
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
        params["id"] = id;
        
        sessionManager.ESP_GET(self.buildUrl(getLandInfoURL), parameters: params, taskSuccessed: { (responseVO: BaseRespDomain) -> Void in
            
            let respInfo = Mapper<LandInfoDomain>().map(responseVO.data)
            success(landInfo: respInfo)
            
            }) { (error: String) -> Void in
                faild(error: error)
        }
    }
    
    //获取地图周边数据
    func getRimInfoList(rimInfo:RimInfoRespDomain, success:(rimInfoArray:Array<RimLandInfoDomain>?) -> Void,faild: (error:String) -> Void) {
        
        let params = Mapper<RimInfoRespDomain>().toJSON(rimInfo)
        
//        sessionManager.responseSerializer = AFJSONResponseSerializer()
        sessionManager.ESP_GET(self.buildUrl(getRimInfoURL), parameters: params, taskSuccessed: { (responseVO: BaseRespDomain) -> Void in
            
                let respArray = Mapper<RimLandInfoDomain>().mapArray(responseVO.data)
            
                success(rimInfoArray: respArray!)
            
            }) { (error: String) -> Void in
                faild(error: error)
        }
    }
}

