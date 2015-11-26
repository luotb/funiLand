//
//  UIBarButtonItemExt.swift
//  Pre-ownedHouse
//
//  Created by whb on 15/11/11.
//  Copyright © 2015年 Allen. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func itemWithTarget(target:AnyObject,action:Selector, image:String,highImage:String) -> UIBarButtonItem{
        let btn = UIButton(type: UIButtonType.Custom);
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside);
        btn.setBackgroundImage(UIImage(named: image), forState: UIControlState.Normal);
        btn.setBackgroundImage(UIImage(named: highImage), forState: UIControlState.Highlighted);
        btn.frame.size = (btn.currentBackgroundImage?.size)!;
        return UIBarButtonItem(customView: btn);
    }
}
