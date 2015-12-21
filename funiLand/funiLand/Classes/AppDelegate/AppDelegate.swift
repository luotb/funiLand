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
    var tabBarViewController: TabBarViewController?
    var isFirstLoadApp: Bool = false
    //记录当前app加载的vc
    var currentViewContrller: BaseViewController?
    //完全退出app  点击通知栏打开app 保存通知数据 每次使用后需要置空
    var localNotification:[NSObject: AnyObject]?
    //通知里面的objId
    var landId: String?
    //是否有忽略消息
    var isIgnoreNotification: Bool = false
    var landDetailNavController: UINavigationController!

    
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
        self.localNotification = launchOptions
        
        return true
    }
    
    func setupWithStatusBar(application: UIApplication) {
        // 设置状态栏隐藏=false
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide);
        // 设置状态栏高亮
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true);
    }
    
    /**
     键盘管理
     */
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
            self.appBecomeActive()
//            self.currentViewContrller!.queryData()
        }
        self.isFirstLoadApp = true
    }
    
    //app刚刚处于活动状态
    func appBecomeActive()
    {
        if let date: NSDate = APPSessionManage.getOutAppDate() {
            let second = NSDate().timeIntervalSinceDate(date)
//            print(second)
//            self.currentViewContrller!.queryData()
            
            //转换分钟数
            let minute = second / 60
            if minute >= 10 && minute <= 25 {
                self.currentViewContrller!.queryData()
            }
            if minute > 25 && HttpService.sharedInstance.loginUserInfo != nil {
                self.window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
            }
        }
    }
}

// MARK: PUSH相关
extension AppDelegate {
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print(deviceToken)
        print("-------------------")
       print(token)
        UMessage.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //如果注册不成功
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if application.applicationState == UIApplicationState.Inactive {
            if let param = userInfo["param"] {
                self.landId = param["objId"] as? String
                self.showMessageVC()
            }
        } else if application.applicationState == UIApplicationState.Active {
            self.handleNotification(userInfo)
        }
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
    func notificationBarOpenAppHandler() {
        
        if let options: [NSObject: AnyObject] = self.localNotification {
            
            if let localNotification = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject: AnyObject] {
                
                FuniCommon.asynExecuteCode(0.5, code: { () -> Void in
                    self.handleNotification(localNotification)
                })
            }
            
            self.localNotification = nil
        }
    }
    
    /**
     push消息处理
     
     - parameter application:        <#application description#>
     - parameter notification:       <#notification description#>
     - parameter remoteNotification: <#remoteNotification description#>
     */
    func handleNotification(notification:[NSObject : AnyObject]?) {
        
        //关闭友盟自带的弹出框
        UMessage.setAutoAlert(false)
        //        UMessage.didReceiveRemoteNotification(userInfo)
        UMessage.sendClickReportForRemoteNotification(notification)
        
        if notification != nil {
            if let param = notification!["param"] {
                self.landId = param["objId"] as? String
                if let title = param["title"] {
                    let alertView = UIAlertView(title: "提示", message: title as! String, delegate: self, cancelButtonTitle: "忽略", otherButtonTitles: "查看")
                    alertView.show()
                }
            }
            
        }
    }
    
    func testPushMessage() {
        var params: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
        var params2: Dictionary<String, String> = Dictionary<String, String>()
        params2["objId"] = "4040"
        params2["title"] = "测试推送的通知标题"
        params["param"] = params2
        self.handleNotification(params)
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

// MARK UIAlertViewDelegate
extension AppDelegate : UIAlertViewDelegate  {
    
    /**
     显示土地详情页
     */
    func showMessageVC() {
        if HttpService.sharedInstance.loginUserInfo != nil {
            print("landID__" + self.landId!)
            let landDetailVC = Helper.getViewControllerFromStoryboard("Message", storyboardID: "LandDetailsViewController") as! LandDetailsViewController
            let landInfoDomain = LandDomain()
            landInfoDomain.id = self.landId
            landDetailVC.landDomain = landInfoDomain
            landDetailVC.isShowRim  = true
            
            let tab = self.window!.rootViewController as! TabBarViewController
            let nav = tab.viewControllers![tab.selectedIndex] as! NavigationController
            
            if nav.topViewController is ProfileViewController {
                nav.navigationBarHidden = false
            }
            nav.pushViewController(landDetailVC, animated: true)

        } else {
            UIAlertView().alertViewWithTitle("请先登录!")
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.showMessageVC()
        } else {
            self.ignoreNotificationHandler()
        }
    }
    
    /**
     忽略通知处理
     */
    func ignoreNotificationHandler() {
        if HttpService.sharedInstance.loginUserInfo != nil {
            //已经登录
            let tab = self.window!.rootViewController as! TabBarViewController
            let nav = tab.viewControllers![tab.selectedIndex] as! NavigationController
            
            if let messageVC: MessageViewController = nav.topViewController as? MessageViewController {
                //当前页为消息 自动加载 当天数据
                messageVC.loadCurrentDateData()
            } else {
                //当前页非消息 tabbar消息item加载红点 并记录有消息
                let vc: UIViewController = (self.tabBarViewController?.childViewControllers[0])!
                vc.tabBarItem.image = UIImage(named: "Newshave_icon_normal")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                self.isIgnoreNotification = true
            }
        } else {
            //未登录 忽略 不处理
        }
    }
    
    /**
     设置消息item为已读
     */
    func resetMessageRead() {
        let vc: UIViewController = (self.tabBarViewController?.childViewControllers[0])!
        vc.tabBarItem.image = UIImage(named: "News_icon_normal")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.isIgnoreNotification = false
    }
}

