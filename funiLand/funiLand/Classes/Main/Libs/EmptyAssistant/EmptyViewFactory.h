//
//  OFFemptyFactory.h
//  51offer
//
//  Created by XcodeYang on 12/3/15.
//  Copyright © 2015 51offer. All rights reserved.
//

#import "FORScrollViewEmptyAssistant.h"

@interface EmptyViewFactory : NSObject

// 请求失败带按钮的
+ (void)errorNetwork:(UIScrollView *)scrollView
            btnBlock:(void(^)())btnBlock;

// 首页启动占位图
+ (void)emptyMainView:(UIScrollView *)scrollView
             btnBlock:(void(^)())btnBlock;

// 首页启动占位图(无按钮)
+ (void)emptyMainView:(UIScrollView *)scrollView;


@end
