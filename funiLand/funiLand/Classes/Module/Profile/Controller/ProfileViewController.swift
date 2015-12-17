//
//  ProfileViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    
    
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
    
    
    @IBAction func testBtnClicked(sender: AnyObject) {
        var params: Dictionary<NSObject, AnyObject> = Dictionary<NSObject, AnyObject>()
        var params2: Dictionary<String, String> = Dictionary<String, String>()
        params2["objId"] = "4040"
        params2["title"] = "测试推送的通知标题"
        
        params["param"] = params2
        
        ((UIApplication.sharedApplication().delegate) as! AppDelegate).handleNotification(params)
    }
    
}
