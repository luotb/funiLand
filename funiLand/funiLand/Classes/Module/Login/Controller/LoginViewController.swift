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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func loginBtnClicked(sender: AnyObject) {
        let loginName = self.loginNameTextField.text
        if loginName == nil  || loginName?.isEmpty == true {
            FuniHUD.sharedHud().show(self.view, onlyMsg: "请输入手机号!")
            return
        }
        
//        if String.validateMobile(loginName!) == false {
//            FuniHUD.sharedHud().show(self.view, onlyMsg: "请输入正确的手机号!")
//            return
//        }
        
        let pwd = self.passwordTextField.text
        if pwd == nil  || pwd?.isEmpty == true {
            FuniHUD.sharedHud().show(self.view, onlyMsg: "请输入密码!")
            return
        }
        
        if(true){//登陆成功
            
            let account = Account();
            account.loginName = loginName
            account.passWord = pwd
            
            AccountTool.saveAccount(account)
            UIApplication.sharedApplication().keyWindow?.rootViewController = TabBarViewController();
            
//            HttpService.sharedInstance.login(account, success: { (msg:String) -> Void in
//                
//                AccountTool.saveAccount(account)
//                UIApplication.sharedApplication().keyWindow?.rootViewController = TabBarViewController();
//                
//                }, faild: { (error:String) -> Void in
//                    FuniHUD.sharedHud().show(self.view, onlyMsg: error)
//            })
        }
    }
    

}
