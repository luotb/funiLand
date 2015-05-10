//
//  LandDetailsViewController.swift
//  funiLand
//
//  Created by You on 15/12/1.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class LandDetailsViewController: BaseViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    var landDomain: LandDomain!
    
    var landInfoObj: LandInfoDomain = LandInfoDomain() {
        willSet{
            self.titleLabel.text = newValue.title
            var str = ""
            if let area = newValue.area {
                str += area
            }
            
            if let date = newValue.date {
                str += date
            }
            
            self.subTitleLabel.text = str
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
        self.queryData()
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
    
    // 画虚线
    func drawDottedLine(imageView: UIImageView) {
        UIGraphicsBeginImageContext(imageView.size)
        imageView.image?.drawInRect(CGRectMake(0, 0, imageView.width, imageView.height))
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        let lengths:[CGFloat] = [10,5]
        let line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, UIColor.redColor().CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
        CGContextAddLineToPoint(line, 310.0, 20.0);
        CGContextStrokePath(line);
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func drawInContext(view: UIView) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        
        let lengths: [CGFloat] = [CGFloat(APPWIDTH-20)]
        CGContextSetLineDash(context, 0, lengths, 2)
        
        CGContextMoveToPoint(context, view.x, view.y)
        CGContextAddLineToPoint(context, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))
    }

}

// MARK: - Table view data source and delegate
extension LandDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.landInfoObj.fieldList?.count)!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.landInfoObj.fieldList?.count > 0 {
            
            let view = UIView(frame: CGRectMake(0, 0, APPWIDTH, 30))
            view.backgroundColor = UIColor.whiteColor()
            
            let dashedLineView = DashedLineView(frame: CGRectMake(10, 0, APPWIDTH-20, 1))
            view.addSubview(dashedLineView)
            
            let label = UILabel(frame: CGRectMake(20, 13, APPWIDTH-40, 16))
            label.textColor = UIColor.colorFromHexString("#ED6715")
            label.text = self.landInfoObj.fieldList![section].group
            view.addSubview(label)
            
            return view
        }
        return nil
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
}

// MARK: View EventHandler
extension LandDetailsViewController {
    
    // 周边按钮点击
    @IBAction func rimBtnClicked(sender: UIButton) {
        
        self.landInfoObj.lat = 30.6709490000
        self.landInfoObj.lng = 104.0984620000
        if self.landInfoObj.lat > 0 && self.landInfoObj.lng > 0 {
            let mapVC = Helper.getViewControllerFromStoryboard("Map", storyboardID: "MapViewController") as! MapViewController
            
            let rimInfoReqDomain = RimInfoReqDomain()
            rimInfoReqDomain.lat = self.landInfoObj.lat
            rimInfoReqDomain.lng = self.landInfoObj.lng
            mapVC.rimInfoReqDomain = rimInfoReqDomain
            mapVC.isShowRim = true
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
}

// MARK: Service Request And Data Package
extension LandDetailsViewController {
    
    //加载数据
    func queryData(){
        
        HttpService.sharedInstance.getLandInfo(landDomain.id!, success: { (landInfo: LandInfoDomain?) -> Void in
            if landInfo != nil {
                self.landInfoObj = landInfo!
            } else {
                self.landInfoObj = LandInfoDomain()
            }
            
            self.myTableView.reloadData()
            
            }) { (error: String) -> Void in
                FuniHUD.sharedHud().show(self.myTableView, onlyMsg: error)
        }
    }
}
