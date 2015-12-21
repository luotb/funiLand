//
//  FuniNoDataViewController.swift
//  funiLand
//
//  Created by You on 15/12/21.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

//无数据按钮点击闭包
typealias  NoDtaBtnClickedClosure = () -> Void

class FuniNoDataViewController: UIViewController {
    
    var noDtaBtnClickedClosure: NoDtaBtnClickedClosure?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK View EventHandler
extension FuniNoDataViewController {
    
    @IBAction func noDataBtnClicked(sender: UIButton) {
        if self.noDtaBtnClickedClosure != nil {
            self.noDtaBtnClickedClosure!()
        }
    }
}
