//
//  UIView+Shadow.h
//  Shadow Maker Example
//  阴影
//  Created by Philip Yu on 5/14/13.
//  Copyright (c) 2013 Philip Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define shadowDirections [NSArray arrayWithObjects: @"top", @"bottom", @"left", @"right",nil]

@interface UIView (Shadow)

- (void) makeInsetShadow;
- (void) makeInsetShadowWithRadius:(float)radius Alpha:(float)alpha;
- (void) makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions;

/**
 *  设置边框
 */
- (void)chx_setBorderLine;

/**
 *  设置边框
 *
 *  @param aColor 边框颜色
 */
- (void)chx_setBorderLineColor:(UIColor *)aColor;

/**
 *  设置边框
 *
 *  @param aColor      边框颜色
 *  @param orientation 哪一条边框
 */
- (void)chx_setBorderLineColor:(UIColor *)aColor edge:(UIRectEdge)edge;

/**
 *  添加边线约束
 *
 *  @param color      边线颜色
 *  @param edge       边缘方向
 *  @param multiplier 边线高度、宽度乘法器([0, 1])
 */
- (void)chx_setBorderLineConstraintsWithColor:(UIColor *)color edge:(UIRectEdge)edge lineSizeMultiplier:(CGFloat)multiplier;

/**
 *  添加虚线边框
 *
 *  @param color 边线颜色
 */
- (void)chx_setDashborderLineColor:(UIColor *)color;

/**
 *  添加虚线边框
 *
 *  @param color 边线颜色
 *  @param edge  边线方向
 */
- (void)chx_setDashborderLineColor:(UIColor *)color edge:(UIRectEdge)edge;

/**
 *  设置边线
 *
 *  @param width       宽度
 *  @param borderColor 颜色
 */
- (void)chx_setBorderWidth:(CGFloat)width color:(UIColor *)borderColor;

@end
