//
//  FuniCommon.swift
//  funiLand
//
//  Created by You on 15/12/16.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class FuniCommon: NSObject {

    static func asynExecuteCode(time: NSTimeInterval, code:() -> Void) {
        let delay = dispatch_time(DISPATCH_TIME_NOW,
            Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            code()
        }
    }
    
    static func animationExecute(time: NSTimeInterval, code:() -> Void) {
        UIView.animateWithDuration(time) { () -> Void in
            code()
        }
    }
}
