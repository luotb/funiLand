//
//  MessageViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController, UIActionSheetDelegate {

    @IBOutlet var dataTypeSegment: UISegmentedControl!
    @IBOutlet var myTableView: UITableView!
    var calendarManager: JTCalendarManager!
    
    @IBOutlet var calendarMenuView: JTCalendarMenuView!
    @IBOutlet var calendarContentView: JTHorizontalCalendarView!
    //当前日期
    var todayDate: NSDate?
    //日历控件最小日期
    var minDate: NSDate?
    //日历控件最大日期
    var maxDate: NSDate?
    //选中的日期
    var dateSelected: NSDate = NSDate()
    //服务器返回的土地数据集合
    var landResponArray: Array<LandArrayRespon>?
    //选中日期对应的土地数据集合
    var landArray: Array<LandDomain> = Array<LandDomain>()
    //请求类型 0=供应, 1=成交
    var reqType: Int = 0
    //初始化请求的月份
    var reqMonth: String = NSDate.getTime(DateFormat.format4, date: nil)
    //选中的土地数据
    var landInfoDomain: LandDomain!
    
    
    //重写父类加载数据
    override func queryData() {
        self.myTableView.header.beginRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if ((UIApplication.sharedApplication().delegate) as! AppDelegate).isIgnoreNotification == true {
            ((UIApplication.sharedApplication().delegate) as! AppDelegate).resetMessageRead()
            self.loadCurrentDateData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
        self.loadCalendar()
        ((UIApplication.sharedApplication().delegate) as! AppDelegate).notificationBarOpenAppHandler()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        
        //这个是设置按下按钮时的颜色
        self.dataTypeSegment.tintColor = UIColor.didSelectedSegmentColor()
        //默认选中的按钮索引
        self.dataTypeSegment.selectedSegmentIndex = 0
        //修改字体的默认颜色与选中颜色
        let dictNormal = [NSForegroundColorAttributeName: UIColor.defSegmentTextColor(), NSFontAttributeName: UIFont.systemFontOfSize(14)]
        self.dataTypeSegment.setTitleTextAttributes(dictNormal, forState: UIControlState.Normal)
        
        let dictSelected = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14)]
       self.dataTypeSegment.setTitleTextAttributes(dictSelected, forState: UIControlState.Selected)
        
        //设置展示表格的数据源和代理
        self.myTableView.dataSource = self
        self.myTableView.delegate   = self
        
        //集成下拉刷新
        setupDownRefresh()
        self.queryData()
    }
    
    //加载日历
    func loadCalendar () {
        self.calendarManager = JTCalendarManager()
        self.calendarManager.delegate = self
        self.todayDate = NSDate();
        
        // Min date will be 2 month before today
        self.minDate = calendarManager.dateHelper.addToDate(todayDate, months: -12)
        
        // Max date will be 2 month after today
        self.maxDate = calendarManager.dateHelper.addToDate(todayDate, months: 12)
        
        self.calendarManager.menuView = calendarMenuView
        self.calendarManager.contentView = calendarContentView
        self.calendarManager.setDate(todayDate)
    }
    
    //下拉刷新
    func setupDownRefresh(){
        self.myTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.requestData()
        }
    }
    
    //根据指定日期判断是否有数据
    func haveEventForDay(date: NSDate) -> Bool {
        var judge : Bool = false
        
        for landRespon : LandArrayRespon in self.landResponArray! {
            let responDate = NSDate.getDateByDateStr(landRespon.date!, format: DateFormat.format1)
            if self.calendarManager.dateHelper.date(responDate, isTheSameDayThan: date) {
                judge = true
                break
            }
        }
        return judge
    }
    
    //获得选中日期的土地数据
    func getSelectedDataLandArray() {
        var judge : Bool = false
        if landResponArray != nil {
            for landRespon : LandArrayRespon in self.landResponArray! {
                let responDate = NSDate.getDateByDateStr(landRespon.date!, format: DateFormat.format1)
                if self.calendarManager.dateHelper.date(responDate, isTheSameDayThan: dateSelected) {
                    self.landArray = landRespon.dataList!
                    judge = true
                    break
                }
            }
        }
        
        if judge == false {
            self.landArray = Array<LandDomain>()
        }
    }
    
    //加载当天数据
    func loadCurrentDateData() {
        self.calendarManager.setDate(NSDate())
        self.reqMonth = NSDate.getTime(DateFormat.format4, date: nil)
        self.queryData()
    }
}

// MARK: - CalendarManager delegate
extension MessageViewController : JTCalendarDelegate {
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let tempDayView = dayView as! JTCalendarDayView
        
        // Today
        if self.calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: tempDayView.date) {
            tempDayView.circleView.hidden = false
            tempDayView.circleView.backgroundColor = UIColor.calendarDotViewBgColor()
            tempDayView.dotView.backgroundColor = UIColor.whiteColor()
            tempDayView.textLabel.textColor = UIColor.whiteColor()
        }
            // Selected date
        else if self.calendarManager.dateHelper.date(self.dateSelected, isTheSameDayThan: tempDayView.date) == true {
            tempDayView.circleView.hidden = false
            tempDayView.circleView.backgroundColor = UIColor.redColor()
            tempDayView.dotView.backgroundColor = UIColor.whiteColor()
            tempDayView.textLabel.textColor = UIColor.whiteColor()
        }
            // Other month
        else if self.calendarManager.dateHelper.date(self.calendarContentView.date, isTheSameMonthThan: tempDayView.date) == false {
            tempDayView.circleView.hidden = true
            tempDayView.dotView.backgroundColor = UIColor.calendarDotViewBgColor()
            tempDayView.textLabel.textColor = UIColor.lightGrayColor()
        }
            // Another day of the current month
        else {
            tempDayView.circleView.hidden = true
            tempDayView.dotView.backgroundColor = UIColor.calendarDotViewBgColor()
            tempDayView.textLabel.textColor = UIColor.calendarDotViewBgColor()
        }
        
        if self.landResponArray != nil {
            if self.haveEventForDay(tempDayView.date) {
                tempDayView.dotView.hidden = false
            } else {
                tempDayView.dotView.hidden = true
            }
        }
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let tempDayView = dayView as! JTCalendarDayView
        self.dateSelected = tempDayView.date;
        self.getSelectedDataLandArray()
        
        // Animation for the circleView
        tempDayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        
        UIView.transitionWithView(tempDayView, duration: 0.3, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            tempDayView.circleView.transform = CGAffineTransformIdentity
            self.calendarManager.reload()
            }, completion: nil)
        
        // Load the previous or next page if touch a day from another month
        
        if self.calendarManager.dateHelper.date(self.calendarContentView.date, isTheSameMonthThan: tempDayView.date) == false {
            if self.calendarContentView.date.compare(tempDayView.date) == NSComparisonResult.OrderedAscending {
                self.calendarContentView.loadNextPageWithAnimation()
            } else {
                self.calendarContentView.loadPreviousPageWithAnimation()
            }
        }
        
        self.myTableView.reloadData()
    }
    
    func calendar(calendar: JTCalendarManager!, canDisplayPageWithDate date: NSDate!) -> Bool {
        return self.calendarManager.dateHelper.date(date, isEqualOrAfter: minDate, andEqualOrBefore: maxDate)
    }
    
    func calendarDidLoadPreviousPage(calendar: JTCalendarManager!) {
        self.reqMonth = NSDate.getTime(DateFormat.format4, date: calendar.date())
         self.queryData()
    }
    
    func calendarDidLoadNextPage(calendar: JTCalendarManager!) {
        self.reqMonth = NSDate.getTime(DateFormat.format4, date: calendar.date())
        self.queryData()
    }
}

// MARK: - Table view data source and delegate
extension MessageViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, APPWIDTH, 40))
        view.backgroundColor = UIColor.tableViewHeadBgColor()
        
        let label1 = UILabel(frame: CGRectMake(10, 11, 30, 14))
        label1.textColor = UIColor.textColor1()
        label1.text = "共计"
        label1.font = UIFont.systemFontOfSize(14)
        view.addSubview(label1)
        
        let label2 = UILabel(frame: CGRectMake(40, 11, 15, 14))
        label2.textColor = UIColor.textColor2()
        label2.text = "\(self.landArray.count)"
        label2.font = UIFont.systemFontOfSize(14)
        label2.textAlignment = NSTextAlignment.Center
        view.addSubview(label2)
        
        let label3 = UILabel(frame: CGRectMake(55, 11, 45, 14))
        label3.textColor = UIColor.textColor1()
        label3.text = "宗土地"
        label3.font = UIFont.systemFontOfSize(14)
        view.addSubview(label3)
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.landArray.count;
    }
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("LandTableViewCell", forIndexPath: indexPath) as! LandTableViewCell
            if self.landArray.count > 0 {
                cell.landDomain = self.landArray[indexPath.row]
            }
            return cell;
            
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.landArray.count > 0 {
            self.landInfoDomain = self.landArray[indexPath.row]
            
            let landDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("LandDetailsViewController") as! LandDetailsViewController
            landDetailVC.landDomain = self.landInfoDomain
            landDetailVC.isShowRim  = true
            self.navigationController?.pushViewController(landDetailVC, animated: true)
        }
    }
}

// MARK: View EventHandler
extension MessageViewController {
    
    //选择器回调
    @IBAction func segmentAction(segment:UISegmentedControl) {
        self.reqType = segment.selectedSegmentIndex
        self.queryData()
    }
    
    // 附近按钮点击
    @IBAction func rimLandBtnClicked(sender: UIBarButtonItem) {
        let mapVC = Helper.getViewControllerFromStoryboard("Map", storyboardID: "MapViewController") as! MapViewController
        mapVC.isHomeRim = true
        mapVC.showRimLandType = 1
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    // 上一月按钮点击
    @IBAction func previousPageCalendartnClicked(sender: UIButton) {
        self.calendarContentView.loadPreviousPageWithAnimation()
    }
    
    // 下一月按钮点击
    @IBAction func nextPageCalendarBtnClicked(sender: UIButton) {
        self.calendarContentView.loadNextPageWithAnimation()
    }
    
}

// MARK: Service Request And Data Package
extension MessageViewController {
    
    //加载数据
    func requestData() {
//        self.reqMonth = "2015-05"
        HttpService.sharedInstance.getSupplyOrBargainList(self.reqType, months: self.reqMonth, success: { (landArray: Array<LandArrayRespon>?) -> Void in
            self.landResponArray = landArray
            self.getSelectedDataLandArray()
            self.calendarManager.reload()
            self.myTableView.reloadData()
            self.myTableView.header.endRefreshing()
            }) { (error: String) -> Void in
                FuniHUD.sharedHud().show(self.myTableView, onlyMsg: error)
                self.myTableView.header.endRefreshing()
        }
    }
}
