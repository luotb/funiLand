//
//  OFFemptyFactory.m
//  51offer
//
//  Created by XcodeYang on 12/3/15.
//  Copyright © 2015 51offer. All rights reserved.
//

#import "EmptyViewFactory.h"

@implementation EmptyViewFactory

#pragma mark - blockConfig

// 请求失败带按钮的
+ (void)errorNetwork:(UIScrollView *)scrollView
            btnBlock:(void(^)())btnBlock
{
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"empty_err_net"];
                                            configer.emptyTitle = @"网络请求失败";
                                            configer.emptySubtitle = @"请点击重新加载\n模拟数据也是需要人品的,现在成功概率更高了\n赶快试一试吧";
                                            configer.emptyCenterOffset = CGPointMake(0, -50);
                                        }
                                        emptyBtnTitle:@"重新加载"
                                  emptyBtnActionBlock:btnBlock];
}


// 首页启动占位图
+ (void)emptyMainView:(UIScrollView *)scrollView
             btnBlock:(void(^)())btnBlock
{
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"empty_common"];
                                            configer.emptyTitle = @"暂无数据";
                                            configer.emptySubtitle = @"请点击发出请求\n有一定的概率可以加载出新数据\n赶快试一试吧";
                                        }
                                        emptyBtnTitle:@"发出请求"
                                  emptyBtnActionBlock:btnBlock];
}


#pragma mark - modelConfig

// 首页启动占位图(无按钮)
+ (void)emptyMainView:(UIScrollView *)scrollView
{
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.emptyImage = [UIImage imageNamed:@"empty_common"];
    configer.emptyTitle = @"已经删除完全部数据了";
    configer.emptySubtitle = @"可以在试试下拉刷新获取数据\n有一定的概率可以加载出之前的数据\n赶快试一试吧";
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView emptyConfiger:configer];
    
    [(UITableView *)scrollView reloadData];
}

@end
