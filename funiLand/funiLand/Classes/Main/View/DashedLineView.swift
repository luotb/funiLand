//
//  DashedLineView.swift
//  funiLand
//
//  Created by You on 15/5/8.
//  Copyright © 2015年 funi. All rights reserved.
//

import UIKit

class DashedLineView: UIView {
    
//    override func initWithFrame(frame: CGRect) -> UIView {
//        supper.initWithFrame(frame: frame)
//        
//    }

    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let lengths: [CGFloat] = [10.0, 50.0]
        CGContextSetLineDash(context, 0, lengths, 1);
        CGContextMoveToPoint(context, self.x, self.y)
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))
        CGContextStrokePath(context);
    }

}
