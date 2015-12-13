//
//  AppDelegate.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

let  NOTIFICATION_APPCOMEBACK = "notification_appcomeback"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var baseViewController: BaseViewController?
    var isFirstLoadApp: Bool = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        self.setupWithStatusBar(application)
        self.registerUMessageNotification(launchOptions)
        self.registerAPPActiveNotification()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
        
//        if AccountTool.getAccount() == nil {
//            window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
//        }else{
//            let tabController = TabBarViewController()
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
        print("第一次加载")
        return true
    }
    
    func setupWithStatusBar(application: UIApplication) {
        // 设置状态栏隐藏=false
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide);
        // 设置状态栏高亮
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true);
    }
    
    private func setup() {
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        window!.tintColor = UIColor(hue: 1, saturation: 0.67, brightness: 0.93, alpha: 1)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        print("后台运行")
    }

    func applicationWillResignActive(application: UIApplication) {
        print("按HOME")
        APPSessionManage.saveWillOutAppDate()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("回来了")
        if self.isFirstLoadApp == true {
            print("回来了嘛")
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_APPCOMEBACK, object: nil)
        }
        self.isFirstLoadApp = true
    }
   
}

// MARK: app session 相关
extension AppDelegate {
    
    /**
     注册通知
     */
    func registerAPPActiveNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appActiveNotification:", name: NOTIFICATION_APPCOMEBACK, object: nil)
    }
    
    func appActiveNotification(notification: NSNotification)
    {
        let date: NSDate = APPSessionManage.getOutAppDate()
        let second = NSDate().timeIntervalSinceDate(date)
        print(second)
        //转换分钟数
        if second > 10 {
            self.baseViewController!.queryData()
        }
//        let minute = second / 60
//        if minute >= 1 && minute <= 2 && self.baseViewController != nil {
//            self.baseViewController!.queryData()
//        } else
//            if minute > 2 {
//               self.window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
//        }
    }
}

// MARK: PUSH相关
extension AppDelegate {
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        HttpService.sharedInstance.talId = token
        
       print(token)
        UMessage.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //如果注册不成功
        print(error)
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
    
    /**
     push消息处理
     
     - parameter application:        <#application description#>
     - parameter notification:       <#notification description#>
     - parameter remoteNotification: <#remoteNotification description#>
     */
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

