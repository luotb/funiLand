//
//  BaseViewController.swift
//  Pre-ownedHouse
//
//  Created by Allen on 15/11/3.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var noDataView:FuniNoDataViewController?
    var isFirstReq:Bool = true
    var reqResultData:AnyObject?

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

// MARK NoData
extension BaseViewController {
    
    //加载无数据视图
    func loadNoDataView() {
        self.noDataView = Helper.getViewControllerFromStoryboard("Login", storyboardID: "FuniNoDataViewController") as? FuniNoDataViewController
        self.noDataView?.view.alpha = 0
        self.view.addSubview((self.noDataView?.view)!)
        
        self.noDataView?.noDtaBtnClickedClosure = {
            () ->Void in
            self.queryData()
        }
    }
    
    func showNoDataHandler() {
        if self.noDataView == nil {
            self.loadNoDataView()
        }
        FuniCommon.animationExecute(0.5) { () -> Void in
            self.noDataView?.view.alpha = 1.0
        }
    }
    
    func noDataHandler(dataSource:AnyObject) {
        if self.isFirstReq == true {
            self.firstReqHandler(dataSource)
        } else {
            self.noFirstReqHandler(dataSource)
        }
    }
    
    func firstReqHandler(dataSource:AnyObject) {
        if dataSource.isEmpty == true || dataSource.count == 0 {
            self.showNoDataHandler()
        } else {
            self.noDataView?.view.alpha = 0
        }
        self.reqResultData = dataSource
        self.isFirstReq = false
    }
    
    func noFirstReqHandler(dataSource:AnyObject) {
        if self.reqResultData == nil {
            if dataSource.isEmpty == false {
                self.noDataView?.view.alpha = 0
            }
        } else {
            self.noDataView?.view.alpha = 0
        }
    }
}
