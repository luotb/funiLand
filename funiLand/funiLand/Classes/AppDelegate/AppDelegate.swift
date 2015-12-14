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
    var isFirstLoadApp: Bool = false
    var currentViewContrller: BaseViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        self.setupWithStatusBar(application)
        self.registerUMessageNotification(launchOptions)
        self.umengTrack()
        //bugly
        self.settingBugly()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
        window!.backgroundColor = UIColor.whiteColor()
        window!.tintColor = UIColor(hue: 1, saturation: 0.67, brightness: 0.93, alpha: 1)
        window!.makeKeyAndVisible()
        setup()
        self.notificationBarOpenAppHandler(launchOptions)
        
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
    }

}

// MARK: app session 相关
extension AppDelegate {
    
    func applicationWillResignActive(application: UIApplication) {
        APPSessionManage.saveWillOutAppDate()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        if self.isFirstLoadApp == true {
//            self.appBecomeActive()
            self.currentViewContrller!.queryData()
        }
        self.isFirstLoadApp = true
    }
    
    //app刚刚处于活动状态
    func appBecomeActive()
    {
        var isLogin = true
        if let date: NSDate = APPSessionManage.getOutAppDate() {
            let second = NSDate().timeIntervalSinceDate(date)
//            print(second)
//            self.currentViewContrller!.queryData()
            
            //转换分钟数
            let minute = second / 60
            if minute >= 10 && minute <= 25 {
                isLogin = false
            }
        }
        
        if isLogin == true {
            self.window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
        } else {
            self.currentViewContrller!.queryData()
        }
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
        self.handleNotification(userInfo)
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
    
    ///通知栏打开app
    func notificationBarOpenAppHandler(launchOptions: [NSObject: AnyObject]?) {
        
        if let options: [NSObject: AnyObject] = launchOptions {
            
            if let localNotification = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject: AnyObject] {
                
                let time: NSTimeInterval = 5
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
                
                dispatch_after(delay, dispatch_get_main_queue()) {
                    self.handleNotification(localNotification)
                }
            }
        }
    }
    
    /**
     push消息处理
     
     - parameter application:        <#application description#>
     - parameter notification:       <#notification description#>
     - parameter remoteNotification: <#remoteNotification description#>
     */
    func handleNotification(notification:[NSObject : AnyObject]?) {
        
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
            
//            UIAlertView(title: <#T##String#>, message: <#T##String#>, delegate: <#T##UIAlertViewDelegate?#>, cancelButtonTitle: <#T##String?#>, otherButtonTitles: <#T##String#>, nil)
        }
    }
}

// MARK UMeng 统计相关
extension AppDelegate {
    
    func umengTrack() {
        // 如果不需要捕捉异常，注释掉此行
//        MobClick.setCrashReportEnabled(false)
        // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
        MobClick.setLogEnabled(false)
        //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
        //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
        MobClick.startWithAppkey(UMengAppKey, reportPolicy: BATCH, channelId: nil)
    }
}

// MARK buly
extension AppDelegate {
    
    func settingBugly() {
        CrashReporter.sharedInstance().enableLog(false)
        CrashReporter.sharedInstance().installWithAppId(TENCENT_BUGLY)
        CrashReporter.sharedInstance().setChannel(APPCHANNEL)
    }
}

