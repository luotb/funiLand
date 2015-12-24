//
//  BaseViewController.swift
//  Pre-ownedHouse
//
//  Created by Allen on 15/11/3.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        //禁用自动调整位置
        self.automaticallyAdjustsScrollViewInsets = false
        ((UIApplication.sharedApplication().delegate) as! AppDelegate).currentViewContrller = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
     加载数据子类重写
     */
    func queryData() {
    }
   
}
