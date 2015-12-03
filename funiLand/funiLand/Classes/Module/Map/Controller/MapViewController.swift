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
    
    // 搜索条件View
    @IBOutlet var searchConditionView: UIView!
    // 搜索条件内容View
    var searchConditionContentView: MapSearchConditionTableViewController!
    // 搜索条件封装VO
    var rimInfoReqDomain = RimInfoReqDomain()
    // 动画是否执行
    var timerRunning: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSteup()
        startLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //基础设置
    func initSteup(){
        
        self.myMapView.delegate = self
        self.myMapView.mapType = MKMapType.Standard
        self.myMapView.showsUserLocation = true
        
        self.searchConditionView.setBorderWithWidth(1, color: UIColor.whiteColor(), radian: 5)
        self.searchConditionContentView = self.storyboard?.instantiateViewControllerWithIdentifier("MapSearchConditionTableViewController") as! MapSearchConditionTableViewController
        self.searchConditionContentView.view.frame = CGRectMake(0, 0, 300, 300)
        self.searchConditionContentView.rimInfoReqDomain = self.rimInfoReqDomain
        self.searchConditionView.addSubview(self.searchConditionContentView.view)
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
            break
            
        case CLAuthorizationStatus.Restricted :
            UIAlertView().alertViewWithTitle("定位服务无法使用!")
            break
        default:
            self.locationManager.startUpdatingLocation()
            break;
        }
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
    }
    
    //可以打印经纬度的跨度，用来测试当前视图下地经纬度跨度是多少，然后用于上面的MKCoordinateSpanMake方法中
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("\(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)")
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
        
        UIView.transitionWithView(self.searchConditionView, duration: 0.3, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            self.searchConditionView.alpha = self.timerRunning ? 1.0 : 0
            }, completion: nil)
        
        // Create view to animate
        //        let view = UIView(frame: UIScreen.mainScreen().bounds)
        //        view.backgroundColor = UIColor.blueColor()
        
        // Create animation
        //        let anim = _POPSpringAnimation(tension: 100, friction: 10, mass: 1)
        //        anim.property = _POPAnimatableProperty(name: kPOPLayerOpacity)
        //        anim.toValue = 0
        //        _POPAnimation.addAnimation(anim, key: anim.property.name, obj: view.layer)
        
        //        let animation = _POPSpringAnimation(tension: 100, friction: 10, mass: 1)
        //        animation.property = _POPAnimatableProperty(name: kPOPLayerSize)
        //
        //        if self.timerRunning == true {
        //            animation.toValue =  NSValue(CGSize: CGSizeMake(300, 300))
        //        }
        //        else {
        //            animation.toValue = NSValue(CGSize:CGSizeMake(46, 46))
        //        }
        //        animation.springBounciness = 10.0;
        //        animation.springSpeed = 10.0;
        //        _POPAnimation.addAnimation(animation, key: animation.property.name, obj: self.searchConditionView.layer)
    }
    
    // 列表显示数据
    @IBAction func showListBtnClicked(sender: AnyObject) {
        
    }
}











