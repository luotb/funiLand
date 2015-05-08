//
//  MessageViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UIActionSheetDelegate, JTCalendarDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSteup()
        self.loadCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        
        //这个是设置按下按钮时的颜色
        self.dataTypeSegment.tintColor = UIColor.grayColor()
        //默认选中的按钮索引
        self.dataTypeSegment.selectedSegmentIndex = 0
        //下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
        
        var attributes:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        attributes["UITextAttributeFont"] = UIFont.systemFontOfSize(12)
        attributes["UITextAttributeTextColor"] = UIColor.whiteColor()
//        attributes["UITextAttributeTextShadowColor"] = UIColor.clearColor()
        attributes["NSForegroundColorAttributeName"] = UIColor.whiteColor()
        self.dataTypeSegment.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
    
        
//        var highlightedAttributes:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
//        highlightedAttributes[NSForegroundColorAttributeName] = UIColor.redColor()
//        self.dataTypeSegment.setTitleTextAttributes(highlightedAttributes, forState: UIControlState.Highlighted)
    
        //修改字体的默认颜色与选中颜色
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],UITextAttributeTextColor,  [UIFont fontWithName:Helvetica size:16.f],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
//        [segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
        
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor redColor], NSForegroundColorAttributeName, nil];
//        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
//        [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];

        
        //设置展示表格的数据源和代理
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.separatorInset = UIEdgeInsetsZero
//        myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //空值代理和数据源
        self.myTableView.emptyDataSetDelegate = self
        self.myTableView.emptyDataSetSource = self
        
        //集成下拉刷新
        setupDownRefresh()
        self.myTableView.header.beginRefreshing()
        
        dataTypeSegment.addTarget(self, action:"segmentAction:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //选择器回调
    func segmentAction(segment:UISegmentedControl) {
        self.reqType = segment.selectedSegmentIndex
        self.myTableView.header.beginRefreshing()
    }
    
    //加载日历
    func loadCalendar () {
        self.calendarManager = JTCalendarManager()
        self.calendarManager.delegate = self
        self.todayDate = NSDate();
        
        // Min date will be 2 month before today
        self.minDate = calendarManager.dateHelper.addToDate(todayDate, months: -2)
        
        // Max date will be 2 month after today
        self.maxDate = calendarManager.dateHelper.addToDate(todayDate, months: 2)
        
        self.calendarManager.menuView = calendarMenuView
        self.calendarManager.contentView = calendarContentView
        self.calendarManager.setDate(todayDate)
    }
    
    //下拉刷新
    func setupDownRefresh(){
        self.myTableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.queryData()
        }
    }
    
    //加载数据
    func queryData(){
        
        self.reqMonth = "2015-05"
        HttpService.sharedInstance.getSupplyOrBargainList(self.reqType, months: self.reqMonth, success: { (landArray: Array<LandArrayRespon>?) -> Void in
                self.landResponArray = landArray
                self.getSelectedDataLandArray()
                self.calendarManager.reload()
                self.myTableView.header.endRefreshing()
            }) { (error: String) -> Void in
                FuniHUD.sharedHud().show(self.myTableView, onlyMsg: error)
                self.myTableView.header.endRefreshing()
        }
    }
    
    // MARK: - Table view data source and delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "共计 \(self.landArray.count) 宗土地"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.landArray.count;
    }
    
    func tableView(tableView:UITableView,cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("LandTableViewCell", forIndexPath: indexPath) as! LandTableViewCell
            cell.landDomain = self.landArray[indexPath.row]
            return cell;
            
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.landInfoDomain = self.landArray[indexPath.row]
        
        let landDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("LandDetailsViewController") as! LandDetailsViewController
        landDetailVC.landDomain = self.landInfoDomain
        self.navigationController?.pushViewController(landDetailVC, animated: true)
    }
    
    // MARK: - CalendarManager delegate
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        
        let tempDayView = dayView as! JTCalendarDayView
        
        // Today
        if self.calendarManager.dateHelper.date(NSDate(), isTheSameDayThan: tempDayView.date) {
            tempDayView.circleView.hidden = false
            tempDayView.circleView.backgroundColor = UIColor.blueColor()
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
            tempDayView.dotView.backgroundColor = UIColor.redColor()
            tempDayView.textLabel.textColor = UIColor.lightGrayColor()
        }
        // Another day of the current month
        else {
            tempDayView.circleView.hidden = true
            tempDayView.dotView.backgroundColor = UIColor.redColor()
            tempDayView.textLabel.textColor = UIColor.blackColor()
        }
        
        if self.landResponArray != nil && self.landResponArray?.isEmpty != false {
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
    
    
    //pragma mark - CalendarManager delegate - Page mangement
    
    func calendar(calendar: JTCalendarManager!, canDisplayPageWithDate date: NSDate!) -> Bool {
        return self.calendarManager.dateHelper.date(date, isEqualOrAfter: minDate, andEqualOrBefore: maxDate)
    }
    
    
    //根据指定日期判断是否有数据
    func haveEventForDay(date: NSDate) -> Bool {
        var judge : Bool = false
        
        for landRespon : LandArrayRespon in self.landResponArray! {
            let responDate = NSDate.getDateByDateStr(landRespon.date!, format: DateFormat.format2)
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
}
