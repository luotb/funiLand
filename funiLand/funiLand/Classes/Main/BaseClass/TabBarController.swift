//
//  BaseTabBarViewController.swift
//  Pre-ownedHouse
//
//  Created by Allen on 15/11/3.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tabBar.translucent = false
        
        let messageNav = Helper.getViewControllerFromStoryboard("Message", storyboardID: "MessageNavigationController") as! NavigationController
        let messageViewController = messageNav.topViewController as? MessageViewController
        if let messageViewController = messageViewController {
            addChildViewController(messageViewController, title: "消息", imageName: "News_icon_normal", selectedImageName: "News_iconclick&selected1", navController: messageNav)
        }
        
        
        let mapNav = Helper.getViewControllerFromStoryboard("Map", storyboardID: "MapNavigationController") as! NavigationController
        let mapViewController = mapNav.topViewController as? MapViewController
        if let mapViewController = mapViewController {
            addChildViewController(mapViewController, title: "地图", imageName: "Search_icon_normal", selectedImageName: "Search_icon_click", navController: mapNav)
        }
        
        let profileNav = Helper.getViewControllerFromStoryboard("Profile", storyboardID: "ProfileNavigationController") as! NavigationController
        let profileViewController = profileNav.topViewController as? ProfileViewController
        if let profileViewController = profileViewController {
            addChildViewController(profileViewController, title: "我的", imageName: "Myself_icon_normal", selectedImageName: "Myself_icon_click", navController: profileNav)
        }
        
        //.自定义工具栏
        self.tabBar.backgroundColor = UIColor.clearColor()
        //底部工具栏背景颜色
        self.tabBar.barTintColor = UIColor.navBarBgColor()
        //.设置底部工具栏文字颜色（默认状态和选中状态）
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:UIColor.whiteColor(), forKey:NSForegroundColorAttributeName) as? [String : AnyObject], forState:UIControlState.Normal);
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:UIColor.didSelectedTabBarTitleColor(), forKey:NSForegroundColorAttributeName) as? [String : AnyObject], forState:UIControlState.Selected)
    }
    
    private func addChildViewController(childController: UIViewController, title: String, imageName: String, selectedImageName: String, navController: UINavigationController) {
        
        // 设置子控制器的图片
        childController.tabBarItem.image = UIImage(named: imageName)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImageName)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        childController.title = title
        
        let rightBarItem = childController.navigationItem.rightBarButtonItem
        if rightBarItem != nil {
            rightBarItem?.image = rightBarItem?.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        
        addChildViewController(navController)
        
    }
    
    
}