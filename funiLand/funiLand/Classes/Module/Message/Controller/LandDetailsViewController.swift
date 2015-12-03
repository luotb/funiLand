//
//  LandDetailsViewController.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var dottedlineImageView: UIImageView!
    
    var landInfoObj: LandInfoDomain = LandInfoDomain()
    var landDomain: LandDomain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
        self.drawDottedLine()
        if landDomain == nil {
            landDomain = LandDomain()
            landDomain.id = "888"
        }
        
        self.queryData()
//        print("title:\(landDomain.title)")
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
    }
    
    //加载数据
    func queryData(){
        
        HttpService.sharedInstance.getLandInfo(landDomain.id!, success: { (landInfo: LandInfoDomain?) -> Void in
            if landInfo != nil {
                self.landInfoObj = landInfo!
                self.titleLabel.text = landInfo!.title
                self.subTitleLabel.text = landInfo!.area! + "  " + landInfo!.date!
            } else {
                self.landInfoObj = LandInfoDomain()
            }
            
            self.myTableView.reloadData()
            
            }) { (error: String) -> Void in
                FuniHUD.sharedHud().show(self.myTableView, onlyMsg: error)
        }
    }

    // MARK: - Table view data source and delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 71
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.landInfoObj.fieldList?.count)!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.landInfoObj.fieldList?.count > 0 {
            return self.landInfoObj.fieldList![section].group
        }
        return ""
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.landInfoObj.fieldList?.count > 0 {
            return self.landInfoObj.fieldList![section].groupFields!.count
        }
        return 0;
    }
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("LandInfoTableViewCell", forIndexPath: indexPath) as! LandInfoTableViewCell
            let groupDomain: FieldGroupDomain = self.landInfoObj.fieldList![indexPath.section]
            let fieldDomain: FieldDomain = groupDomain.groupFields![indexPath.row]
            cell.fieldDomain = fieldDomain
            return cell;
            
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // 画虚线
    func drawDottedLine() {
        UIGraphicsBeginImageContext(dottedlineImageView.size)
        dottedlineImageView.image?.drawInRect(CGRectMake(0, 0, dottedlineImageView.width, dottedlineImageView.height))
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        let lengths:[CGFloat] = [10,5]
        let line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, UIColor.redColor().CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
        CGContextAddLineToPoint(line, 310.0, 20.0);
        CGContextStrokePath(line);
        dottedlineImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    }

}
