//
//  RimLandListViewController.swift
//  funiLand
//
//  Created by yangyangxun on 15/12/6.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class RimLandListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet var myTableView: UITableView!
    
    // 周边请求数据
    var rimInfoReqDomain: RimInfoReqDomain!
    // 数据源
    var landArray:Array<RimLandInfoDomain> = Array<RimLandInfoDomain>(){
        willSet{
            self.myTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        
        //设置展示表格的数据源和代理
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //空值代理和数据源
        myTableView.emptyDataSetDelegate = self
        myTableView.emptyDataSetSource = self
        
        //集成下拉刷新
        setupDownRefresh()
    }
    
    //下拉刷新
    func setupDownRefresh(){
        self.myTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.queryData()
        }
    }
    
    //加载数据
    func queryData(){
        
        HttpService.sharedInstance.getRimInfoList(self.rimInfoReqDomain, success: { (rimInfoArray: Array<RimLandInfoDomain>) -> Void in
            
                self.landArray = rimInfoArray
                self.myTableView.reloadData()
            
            }) { (error:String) -> Void in
                FuniHUD.sharedHud().show(self.view, onlyMsg: error)
        }
    }
    
    // MARK: - Table view data source and delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landArray.count;
    }
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("LandTableViewCell", forIndexPath: indexPath) as! LandTableViewCell
//            cell.landDomain = landArray[indexPath.row]
            return cell;
            
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rimLandInfo: RimLandInfoDomain = landArray[indexPath.row]
        let landDomain = LandDomain()
        landDomain.id = rimLandInfo.id!
        
        let landDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("LandDetailsViewController") as! LandDetailsViewController
        landDetailVC.landDomain = landDomain
        self.navigationController?.pushViewController(landDetailVC, animated: true)
    }
}
