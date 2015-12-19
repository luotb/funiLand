//
//  ProfileViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK UIAlertViewDelegate
extension ProfileViewController : UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 1 {
            AccountTool.delAccount()
            HttpService.sharedInstance.logout({ (msg: String) -> Void in
               
                ((UIApplication.sharedApplication().delegate) as! AppDelegate).window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
                
                }, faild: { (error: String) -> Void in
                    ((UIApplication.sharedApplication().delegate) as! AppDelegate).window!.rootViewController = Helper.getViewControllerFromStoryboard("Login", storyboardID: "LoginNavigationController") as! NavigationController
            })
        }
    }
}

// MARK: View EventHandler
extension ProfileViewController {
    
    // 退出按钮点击
    @IBAction func logoutBtnClicked(sender: UIButton) {
        let alertView = UIAlertView(title: "提示", message: "确认退出!", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
        alertView.show()
    }
    
}
