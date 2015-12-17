//
//  NavigationController.swift
//  Pre-ownedHouse
//
//  Created by Allen on 15/11/3.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航栏背景色
        self.navigationBar.barTintColor = UIColor.navBarBgColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
        }
        
        var imgName = "Back_icon"
        if viewController is RimLandListViewController {
            imgName = "map_icon"
        }
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithTarget(self, action: "back", image: imgName, highImage: imgName)
        
        let rightBarItem = viewController.navigationItem.rightBarButtonItem
        if rightBarItem != nil {
            rightBarItem?.image = rightBarItem?.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    func back(){
        self.popViewControllerAnimated(true)
    }
    
}
