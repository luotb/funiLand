//
//  LoginViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var loginNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //本地有存储账户信息则自动登录
        if let account: Account = AccountTool.getAccount() {
            self.loginRequest(account)
        } else {
            self.showMainView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     显示登录输入框
     */
    func showMainView() {
        UIView.transitionWithView(self.mainView, duration: 0.3, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            self.mainView.alpha = 1
            }, completion: nil)
    }
}

// MARK: View EventHandler
extension LoginViewController {
    
    @IBAction func loginBtnClicked(sender: AnyObject) {
        let loginName = self.loginNameTextField.text
        if loginName == nil  || loginName?.isEmpty == true {
            FuniHUD.sharedHud().show(self.view, onlyMsg: "请输入手机号!")
            return
        }
        
        if String.validateMobile(loginName!) == false {
            FuniHUD.sharedHud().show(self.view, onlyMsg: "请输入正确的手机号!")
            return
        }
        
        let pwd = self.passwordTextField.text
        if pwd == nil  || pwd?.isEmpty == true {
            FuniHUD.sharedHud().show(self.view, onlyMsg: "请输入密码!")
            return
        }
        
        let account = Account();
        account.loginName = loginName
        account.passWord  = pwd
        account.passWord  = account.passWord?.md5
        self.loginRequest(account)
    }
    
}

// MARK: Service Request And Data Package
extension LoginViewController {
    
    //login request
    func loginRequest(account: Account) {
        
//              AccountTool.saveAccount(account)
//            UIApplication.sharedApplication().keyWindow?.rootViewController = TabBarViewController()
        FuniHUD.sharedHud().show(self.view, msg: "请稍等")
        let userInfo = FLUser(account: account)
        HttpService.sharedInstance.login(userInfo, success: { (msg:String) -> Void in
            CrashReporter.sharedInstance().setUserId(userInfo.loginName)
            AccountTool.saveAccount(account)
            FuniHUD.sharedHud().hide(self.view)
            
            let tabBarVC = TabBarViewController()
            ((UIApplication.sharedApplication().delegate) as! AppDelegate).tabBarViewController = tabBarVC
            ((UIApplication.sharedApplication().delegate) as! AppDelegate).window?.rootViewController = tabBarVC
            
            }, faild: { (error:String) -> Void in
                FuniHUD.sharedHud().show(self.view, onlyMsg: error)
                self.showMainView()
        })
    }
}

