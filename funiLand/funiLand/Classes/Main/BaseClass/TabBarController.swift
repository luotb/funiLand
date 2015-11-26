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
        
        let messageNav = Helper.getViewControllerFromStoryboard("Message", storyboardID: "NavigationController") as! NavigationController
        let messageViewController = messageNav.topViewController as? MessageViewController
        if let messageViewController = messageViewController {
            addChildViewController(messageViewController, title: "消息", imageName: "tab_Gov", selectedImageName: "tab_Gov_Sel", navController: messageNav)
        }
        
        
        let mapNav = Helper.getViewControllerFromStoryboard("Map", storyboardID: "NavigationController") as! NavigationController
        let mapViewController = mapNav.topViewController as? MapViewController
        if let mapViewController = mapViewController {
            addChildViewController(mapViewController, title: "地图", imageName: "tab_Information", selectedImageName: "tab_Information_Sel", navController: mapNav)
        }
        
        let profileNav = Helper.getViewControllerFromStoryboard("Profile", storyboardID: "NavigationController") as! NavigationController
        let profileViewController = profileNav.topViewController as? ProfileViewController
        if let profileViewController = profileViewController {
            addChildViewController(profileViewController, title: "我的", imageName: "tab_Me", selectedImageName: "tab_Me_Sel", navController: profileNav)
        }
        
    }
    
    private func addChildViewController(childController: UIViewController, title: String, imageName: String, selectedImageName: String, navController: UINavigationController) {
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)!
        childController.tabBarItem.selectedImage = UIImage(named: selectedImageName)!
        
        addChildViewController(navController)
        
    }
    
    
}