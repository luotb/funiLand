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
            
            let result:BaseRespDomain = Mapper<BaseRespDomain>().map(id as! NSDictionary)!;
            if(result.code == 100){//成功
                taskSuccessed(responseVO: result);
                
            }else if(result.code == 102){//session过期,直接跳回登陆页面
                UIApplication.sharedApplication().keyWindow!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
            }else{
                if let message = result.remark{
                    taskFailured(error: message);
                }
            }
            }) { (task:NSURLSessionDataTask?, error:NSError!) -> Void in
                taskFailured(error: String_RequestError_Msg_1001)
        }
        
    }

    
    
    func ESP_POST(URLString: String!, parameters: AnyObject!, taskSuccessed: (responseVO:BaseRespDomain)->Void, taskFailured: (error:String)->Void ){
        
        super.POST(URLString, parameters: parameters, success: { (task:NSURLSessionDataTask!, id:AnyObject!) -> Void in
            
            let result:BaseRespDomain = Mapper<BaseRespDomain>().map(id as! NSDictionary)!;
            if(result.code == 100){//成功
                taskSuccessed(responseVO: result);
                
            }else if(result.code == 102){//session过期,直接跳回登陆页面
                UIApplication.sharedApplication().keyWindow!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
            }else{
                if let message = result.remark{
                    taskFailured(error: message);
                }
            }
            }) { (task:NSURLSessionDataTask?, error:NSError!) -> Void in
                taskFailured(error: String_RequestError_Msg_1001)
        }
        
    }
    
    
    func ESP_GET(URLString: String!, parameters: AnyObject!, taskSuccessed: (responseVO:BaseRespDomain)->Void, taskFailured: (error:String)->Void ){
        
        super.GET(URLString, parameters: parameters, success: { (task:NSURLSessionDataTask!, id:AnyObject!) -> Void in
            
            var result:BaseRespDomain?
            if id is NSArray {
                let aa = id as! NSArray
                result  = Mapper<BaseRespDomain>().map(aa[0])!;
            } else {
                result = Mapper<BaseRespDomain>().map(id as! NSDictionary)!;
            }
           
            if(result!.code == 100){//成功
                taskSuccessed(responseVO: result!);
                
            }else if(result!.code == 102){//session过期,直接跳回登陆页面
                UIApplication.sharedApplication().keyWindow!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
            }else{
                if let message = result!.remark{
                    taskFailured(error: message);
                }
            }
            }) { (task:NSURLSessionDataTask?, error:NSError!) -> Void in
                taskFailured(error: String_RequestError_Msg_1001)
        }
        
    }
}
