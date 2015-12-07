//
//  MapViewController.swift
//  funiLand
//
//  Created by You on 15/11/23.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet var myMapView: MKMapView!
    var locationManager:CLLocationManager!
    var centerCoordinate:CLLocationCoordinate2D!
    
    // 定位按钮
    @IBOutlet var userLocationBtn: UIButton!
    // 搜索条件View
    @IBOutlet var searchConditionView: UIView!
    //搜索条件按钮
    @IBOutlet var searchBtn: UIButton!
    // 搜索条件内容View
    var searchConditionContentView: MapSearchConditionTableViewController!
    // 搜索条件封装VO
    var rimInfoReqDomain = RimInfoReqDomain()
    // 搜索按钮动画是否执行
    var timerRunning: Bool = false
    // 土地详情view动画是否执行
    var landInfoRunning: Bool = false
    
    // 周边数据源
    var rimLandArray: Array<RimLandInfoDomain>!
    //所有标注
    var pointAnnotationArray = Array<FuniPointAnnotation>()
    //地图搜索
    var localSearch:MKLocalSearch?
    
    //土地详情View
    @IBOutlet var landInfoView: UIView!
    // 标注点的土地详情
    var annoatationDetailsView:MapAnnotationDetailsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSteup()
        startLocation()
        self.loadAnnoatationLandDetailsView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    //基础设置
    func initSteup(){
        
        self.myMapView.delegate = self
        self.myMapView.mapType = MKMapType.Standard
        self.myMapView.showsUserLocation = true
        
        self.searchConditionView.setBorderWithWidth(0, color: UIColor.whiteColor(), radian: 5)
        self.searchConditionContentView = self.storyboard?.instantiateViewControllerWithIdentifier("MapSearchConditionTableViewController") as! MapSearchConditionTableViewController
        self.searchConditionContentView.view.frame = CGRectMake(0, 0, 300, 300)
        self.searchConditionContentView.rimInfoReqDomain = self.rimInfoReqDomain
        self.searchConditionView.addSubview(self.searchConditionContentView.view)
    }
    
    // 加载标注土地详情VC
    func loadAnnoatationLandDetailsView() {
        self.annoatationDetailsView = self.storyboard?.instantiateViewControllerWithIdentifier("MapAnnotationDetailsViewController") as! MapAnnotationDetailsViewController
        self.landInfoView.addSubview(self.annoatationDetailsView.view)
    }
    
    //请求数据
    func queryData() {
        
        HttpService.sharedInstance.getRimInfoList(rimInfoReqDomain, success: { (rimInfoArray: Array<RimLandInfoDomain>) -> Void in
            
                self.rimLandArray = rimInfoArray
                self.packagePointAnnatotion()
                self.myMapView.addAnnotations(self.pointAnnotationArray)
            
            }) { (error:String) -> Void in
                FuniHUD.sharedHud().show(self.view, onlyMsg: error)
        }
    }
    
    //封装标注数据
    func packagePointAnnatotion() {
        
        for rimInfoDomain: RimLandInfoDomain in self.rimLandArray {
            let pointAnnatotion = FuniPointAnnotation()
            pointAnnatotion.coordinate = CLLocationCoordinate2DMake(rimInfoDomain.lat!, rimInfoDomain.lng!)
            pointAnnatotion.rimLandInfoDomain = rimInfoDomain
            pointAnnatotion.title = rimInfoDomain.title!
            self.pointAnnotationArray.append(pointAnnatotion)
        }
    }
    
    // MARK - CLLocationManagerDelegate
    
    func startLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch (status) {
        case CLAuthorizationStatus.NotDetermined :
            if self.locationManager.respondsToSelector("requestAlwaysAuthorization") {
                if #available(iOS 8.0, *) {
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.requestAlwaysAuthorization()
                } else {
                    // Fallback on earlier versions
                    if #available(iOS 9.0, *) {
                        self.locationManager.requestLocation()
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            break;
            
        case CLAuthorizationStatus.Denied :
            UIAlertView().alertViewWithTitle("请在设置-隐私-定位服务中开启定位功能!")
            self.defLoadCDMap()
            break
            
        case CLAuthorizationStatus.Restricted :
            UIAlertView().alertViewWithTitle("定位服务无法使用!")
            self.defLoadCDMap()
            break
        default:
            self.locationManager.startUpdatingLocation()
            break;
        }
    }
    
    //默认定位到成都
    func defLoadCDMap() {
        
        HttpService.setAppNetworkActivity(true)
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = "成都"
        
        if self.localSearch == nil {
            self.localSearch = MKLocalSearch(request: searchRequest)
        }
        
        self.localSearch?.startWithCompletionHandler({ (response:MKLocalSearchResponse?, error:NSError?) -> Void in
            HttpService.setAppNetworkActivity(false)
            
            if error != nil {
                
            } else {
                let pointAnnotation = FuniPointAnnotation()
                pointAnnotation.coordinate = response!.boundingRegion.center
                self.pointAnnotationArray.append(pointAnnotation)
                
                self.myMapView.setCenterCoordinate(response!.boundingRegion.center, animated: true)
            }
        })
    }
    
    // MARK: mapView delegate
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        //定位成功记录位置
        self.centerCoordinate = userLocation.location!.coordinate
        
        //点击大头针，会出现以下信息
        userLocation.title = "中国";
        userLocation.subtitle = "四大文明古国之一";
        
        //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
        //    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        //这个方法可以设置地图精度以及显示用户所在位置的地图
        let span = MKCoordinateSpanMake(0.1, 0.1);
        let region = MKCoordinateRegionMake(userLocation.location!.coordinate, span);
        mapView.setRegion(region, animated: true)
        
        self.queryData()
    }
    
    //定位失败
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        self.defLoadCDMap()
    }
    
    //可以打印经纬度的跨度，用来测试当前视图下地经纬度跨度是多少，然后用于上面的MKCoordinateSpanMake方法中
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("\(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)")
    }
    
    //地图标注
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Purple
        }
        else {
            pinView!.annotation = annotation
        }
        
        let pointAnnatotion = annotation as! FuniPointAnnotation
        
        if pointAnnatotion.rimLandInfoDomain != nil {
            if pointAnnatotion.rimLandInfoDomain?.dataType == 0 {
                //土地
                pinView?.image = UIImage(named: "Loca_normal")
            } else {
                //项目
                pinView?.image = UIImage(named: "other_normal")
            }
        }
        
        return pinView
    }
    
    // 地图标注点击
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
//        let pointAnnatotion = view.annotation as! FuniPointAnnotation
//        pointAnnatotion.rimLandInfoDomain
       
        if self.timerRunning {
            self.searchConditionBtnClicked(self.searchBtn)
        }
    }
    
    //    在通过双指捏拢、放大、缩小地图的时候回调
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if self.timerRunning {
            self.searchConditionBtnClicked(self.searchBtn)
        }
    }
    
    // 定位按钮点击
    @IBAction func userLocationBtnClicked(sender: AnyObject) {
        if self.centerCoordinate == nil {
            self.startLocation()
        } else {
            //用户位置为地图中心点
            self.myMapView.setCenterCoordinate(self.centerCoordinate, animated: true)
        }
    }
    
    // 查询条件按钮点击
    @IBAction func searchConditionBtnClicked(sender: UIButton) {
        self.timerRunning = !self.timerRunning;
        sender.selected = self.timerRunning
        
        self.searchConditionView.alpha = 1.0
        let animation = _POPSpringAnimation(tension: 100, friction: 10, mass: 1)
        animation.property = _POPAnimatableProperty(name: kPOPLayerSize)
        
        if self.timerRunning == true {
            animation.toValue =  NSValue(CGSize: CGSizeMake(300, 300))
        }
        else {
            animation.toValue = NSValue(CGSize:CGSizeMake(5, 5))
        }
        animation.springBounciness = 10.0;
        animation.springSpeed = 10.0;
        
        let animation2 = _POPSpringAnimation(tension: 100, friction: 10, mass: 1)
        animation2.property = _POPAnimatableProperty(name: kPOPLayerPosition)

        if self.timerRunning == true {
            animation2.toValue =  NSValue(CGPoint: CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.searchBtn.frame) + 150))
        }
        else {
            animation2.toValue = NSValue(CGSize:CGSizeMake(CGRectGetMidX(self.searchBtn.frame), CGRectGetMidY(self.searchBtn.frame)))
        }
        animation2.springBounciness = 10.0;
        animation2.springSpeed = 10.0;
        
//        animation2.completionBlock = {
//            (anim:_POPAnimation, finished:Bool) -> void in
//            
//        }
        
        _POPAnimation.addAnimation(animation, key: animation.property.name, obj: self.searchConditionView.layer)
        _POPAnimation.addAnimation(animation2, key: animation2.property.name, obj: self.searchConditionView.layer)
    }
    
    // 列表显示数据
    @IBAction func showListBtnClicked(sender: AnyObject) {
        
        let rimLandListVC = self.storyboard?.instantiateViewControllerWithIdentifier("RimLandListViewController") as! RimLandListViewController
        rimLandListVC.rimInfoReqDomain = self.rimInfoReqDomain
//        rimLandListVC.landArray = self.rimLandArray
        self.navigationController?.pushViewController(rimLandListVC, animated: true)

    }
    
    
    @IBAction func testBtnClicked(sender: AnyObject) {
        self.landInfoRunning = !self.landInfoRunning
        
        let animation = _POPSpringAnimation(tension: 100, friction: 10, mass: 1)
        animation.property = _POPAnimatableProperty(name: kPOPLayerPosition)
        
        if self.landInfoRunning == true {
            animation.toValue =  NSValue(CGPoint: CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) - CGRectGetHeight(self.landInfoView.frame)))
        }
        else {
            animation.toValue = NSValue(CGPoint:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) + 20))
        }
        animation.springBounciness = 10.0;
        animation.springSpeed = 10.0;
        _POPAnimation.addAnimation(animation, key: animation.property.name, obj: self.landInfoView.layer)
        
        UIView.transitionWithView(self.userLocationBtn, duration: 0.3, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            
            self.userLocationBtn.alpha = self.landInfoRunning == true ? 0 : 1
            
            }, completion: nil)
    }
    
}











