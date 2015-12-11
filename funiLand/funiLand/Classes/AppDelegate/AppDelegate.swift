//
//  AppDelegate.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.setupWithStatusBar(application)
        
//        let tabController = TabBarViewController()
        
        self.registerUMessageNotification(launchOptions)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
        
//        if AccountTool.getAccount() == nil {
//            window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
//        }else{
//            window!.rootViewController = tabController
//        }
        
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        setup()
        
        if launchOptions?.isEmpty == true {
            let tempOptions:Dictionary<String, AnyObject> = launchOptions as! Dictionary<String, AnyObject>
            if let localNotification:UILocalNotification = tempOptions[UIApplicationLaunchOptionsRemoteNotificationKey] as? UILocalNotification {
                self.handleNotification(application, notification: nil, remoteNotification: localNotification)
            }
        }
        
        return true
    }
    
    func setupWithStatusBar(application: UIApplication) {
        // 设置状态栏隐藏
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide);
        // 设置状态栏高亮
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true);
    }
    
    private func setup() {
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        window!.tintColor = UIColor(hue: 1, saturation: 0.67, brightness: 0.93, alpha: 1)
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        HttpService.sharedInstance.talId = token
        
//        print(token)
        UMessage.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
  
        print(error)
    //如果注册不成功
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
   
        self.handleNotification(application, notification: userInfo, remoteNotification: UILocalNotification())
        
    }
    
    //注册友盟的消息推送
    func registerUMessageNotification(launchOptions: [NSObject: AnyObject]?) {
    //set AppKey and LaunchOptions
        
        UMessage.startWithAppkey(UMengAppKey, launchOptions: launchOptions)
    
    //register remoteNotification types
        
        if #available(iOS 8.0, *) {
            
            let action1 = UIMutableUserNotificationAction()
            action1.identifier = "action1_identifier"
            action1.title = "Accept"
            action1.activationMode = UIUserNotificationActivationMode.Foreground//当点击的时候启动程序
            
            let action2 = UIMutableUserNotificationAction()  //第二按钮
            action2.identifier = "action2_identifier"
            action2.title = "Reject"
            action2.activationMode = UIUserNotificationActivationMode.Background//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = true//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = true
            
            let categorys = UIMutableUserNotificationCategory()
            categorys.identifier = "category1"//这组动作的唯一标示
            categorys.setActions([action1, action2], forContext: UIUserNotificationActionContext.Default)

            let setArray:Set<UIMutableUserNotificationCategory> = [categorys]
            let userSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Badge, UIUserNotificationType.Sound, UIUserNotificationType.Alert], categories: setArray)
            
            UMessage.registerRemoteNotificationAndUserNotificationSettings(userSettings)
            
        } else{
            //register remoteNotification types
            
            UMessage.registerForRemoteNotificationTypes([UIRemoteNotificationType.Badge,UIRemoteNotificationType.Sound,UIRemoteNotificationType.Alert])
        }
        
        UMessage.setLogEnabled(false)
        
    }
    
    func handleNotification(application:UIApplication, notification:[NSObject : AnyObject]?, remoteNotification:UILocalNotification) {
        
//        let not = notification
//        if remoteNotification != nil {
//            notification = remoteNotification as! [NSObject : AnyObject]
//        }
        
        //关闭友盟自带的弹出框
        UMessage.setAutoAlert(false)
        //        UMessage.didReceiveRemoteNotification(userInfo)
        UMessage.sendClickReportForRemoteNotification(notification)
        
        print(notification)
        
        let msg: String = (notification!["aps"] as! Dictionary)["alert"]!
        if msg.isEmpty == false {
            let alertView = UIAlertView(title: "提示", message: msg, delegate: nil, cancelButtonTitle: "忽略", otherButtonTitles: "查看", "")
            alertView.show()
        }
    }
  
}

