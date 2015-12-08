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
        
        let tabController = TabBarViewController()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if AccountTool.getAccount() == nil {
            window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
        }else{
            window!.rootViewController = tabController
        }
        
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        setup()
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

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

