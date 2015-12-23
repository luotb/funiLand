//
//  ESPAFHTTPSessionManager.swift
//  Pre-ownedHouse
//
//  Created by whb on 15/11/20.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit


class ESPAFHTTPSessionManager: AFHTTPSessionManager {
    
    
    func ESP_PUT(URLString: String!, parameters: AnyObject!, taskSuccessed: (responseVO:BaseRespDomain)->Void, taskFailured: (error:String)->Void ){
        
        super.PUT(URLString, parameters: parameters, success: { (task:NSURLSessionDataTask!, id:AnyObject!) -> Void in
            
            self.packageBaseResp(id, successed: taskSuccessed, failured: taskFailured)
            
            }) { (task:NSURLSessionDataTask?, error:NSError!) -> Void in
                self.requestErrorCode(error, faild: taskFailured)
        }
        
    }
    
    func ESP_POST(URLString: String!, parameters: AnyObject!, taskSuccessed: (responseVO:BaseRespDomain)->Void, taskFailured: (error:String)->Void ){
        
        super.POST(URLString, parameters: parameters, success: { (task:NSURLSessionDataTask!, id:AnyObject!) -> Void in
            
            self.packageBaseResp(id, successed: taskSuccessed, failured: taskFailured)
            
            }) { (task:NSURLSessionDataTask?, error:NSError!) -> Void in
                self.requestErrorCode(error, faild: taskFailured)
        }
        
    }
    
    
    func ESP_GET(URLString: String!, parameters: AnyObject!, taskSuccessed: (responseVO:BaseRespDomain)->Void, taskFailured: (error:String)->Void ){
        
        super.GET(URLString, parameters: parameters, success: { (task:NSURLSessionDataTask!, id:AnyObject!) -> Void in
            print(id)
            self.packageBaseResp(id, successed: taskSuccessed, failured: taskFailured)
            
            }) { (task:NSURLSessionDataTask?, error:NSError!) -> Void in
                self.requestErrorCode(error, faild: taskFailured)
        }
    }
    
    // 封装顶层返回
    func packageBaseResp(id:AnyObject!, successed: (responseVO:BaseRespDomain)->Void, failured: (error:String)->Void ) {
        
        var result:BaseRespDomain?
        if id != nil {
            if id is NSArray {
                let aa = id as! NSArray
                result  = Mapper<BaseRespDomain>().map(aa[0])!;
            } else if id is NSDictionary {
                result = Mapper<BaseRespDomain>().map(id as! NSDictionary)!;
            } else {
                result = BaseRespDomain()
                result!.remark = String_Message_RequestError
            }
        } else {
            result = BaseRespDomain()
            result!.remark = String_Message_RequestError
        }
        
        if  result!.code == Code_Success  ||
            result!.code == Code_Success2 ||
            result!.code == Code_Success3  {
            //成功
            successed(responseVO: result!);
            
        }else if(result!.code == Code_SessionTimeOut){//session过期,直接跳回登陆页面
                AccountTool.delAccount()
            UIApplication.sharedApplication().keyWindow!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
        }else{
            if let message = result!.remark{
                failured(error: message);
            } else {
                failured(error: String_Message_RequestError)
            }
        }
    }
    
    // 1001  1009
    func requestErrorCode(error:NSError, faild:(error:String)->Void ) {
        switch (error.code) {
        case String_RequestError_1001:
            faild(error:String_RequestError_Msg_1001);
            break;
        case String_RequestError_1004:
            faild(error:String_RequestError_Msg_1009);
            break;
        case String_RequestError_1009:
            faild(error:String_RequestError_Msg_1009);
            break;
        default:
            faild(error:String_Message_RequestError);
            break;
        }
    }
}
