//
//  UIAlertViewExtension.swift
//  funiLand
//
//  Created by yangyangxun on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import Foundation

extension UIAlertView {
    
    func alertViewWithTitle(message: String) {
        let alertView = UIAlertView()
        alertView.title = "提示"
        alertView.message = message
        alertView.addButtonWithTitle("确定")
        alertView.show()
    }
}