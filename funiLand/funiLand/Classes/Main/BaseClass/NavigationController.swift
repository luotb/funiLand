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
        self.navigationBar.barTintColor = UIColor.colorFromHexString("#227CFE")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
        }
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithTarget(self, action: "back", image: "Back_icon", highImage: "Back_icon")
        super.pushViewController(viewController, animated: animated)
    }
    
    
    func back(){
        self.popToRootViewControllerAnimated(true);
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
