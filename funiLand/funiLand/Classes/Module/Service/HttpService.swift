//
//  HttpService.swift
//  Pre-ownedHouse
//
//  Created by Allen on 15/11/4.
//  Copyright © 2015年 Allen. All rights reserved.
//

import Foundation

let baseURLString = "http://192.168.1.241/"
let loginURLString = "login.json"


class HttpService {
    let sessionManager:AFHTTPSessionManager;
    
    static let sharedInstance = HttpService()
    
    private init() {
        //        sessionManager = AFHTTPSessionManager(baseURL: NSURL(string: baseURLString)!)
        sessionManager = AFHTTPSessionManager();
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
    
    func login(param params:NSMutableDictionary?,success:(str:String)->Void,faild:(error:String)->Void){
        
        sessionManager.GET(self.buildUrl(loginURLString), parameters: params, success: { (task:NSURLSessionDataTask!, id:AnyObject!) -> Void in
            success(str: "调用成功")
            }) { (NSURLSessionDataTask, error:NSError!) -> Void in
                faild(error: "网络错误，请稍后再试！")
        }
        
    }
}

