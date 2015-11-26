//
//  UIView+Shadow.m
//  Shadow Maker Example
//
//  Created by Philip Yu on 5/14/13.
//  Copyright (c) 2013 Philip Yu. All rights reserved.
//

#import "UIView+Shadow.h"

#define kShadowViewTag 2132
#define kColorDigit (213 / 255)
#define kBorderLineGrayColor [UIColor colorWithRed:kColorDigit green:kColorDigit blue:kColorDigit alpha:kColorDigit]
#define kLineBorderWidth 0.5

@implementation UIView (Shadow)

- (void) makeInsetShadow
{
    UIColor *color = [UIColor colorWithRed:(0.0) green:(0.0) blue:(0.0) alpha:0.5];
    [self createShadowViewWithRadius:3 Color:color Directions:shadowDirections];
}

- (void) makeInsetShadowWithRadius:(float)radius Alpha:(float)alpha
{
    UIColor *color = [UIColor colorWithRed:(0.0) green:(0.0) blue:(0.0) alpha:alpha];
    [self createShadowViewWithRadius:radius Color:color Directions:shadowDirections];
}

- (void) makeInsetShadowWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions
{
    [self createShadowViewWithRadius:radius Color:color Directions:directions];
}

- (void) createShadowViewWithRadius:(float)radius Color:(UIColor *)color Directions:(NSArray *)directions
{
    // Ignore duplicate direction
    NSMutableDictionary *directionDict = [[NSMutableDictionary alloc] init];
    for (NSString *direction in directions) [directionDict setObject:@"1" forKey:direction];
    
    for (NSString *direction in directionDict) {
        // Ignore invalid direction
        if ([shadowDirections containsObject:direction])
        {
            CAGradientLayer *shadow = [CAGradientLayer layer];
            
            if ([direction isEqualToString:@"top"]) {
                [shadow setStartPoint:CGPointMake(0.5, 0.0)];
                [shadow setEndPoint:CGPointMake(0.5, 1.0)];
                shadow.frame = CGRectMake(0, 0, self.bounds.size.width, radius);
            }
            else if ([direction isEqualToString:@"bottom"])
            {
                [shadow setStartPoint:CGPointMake(0.5, 1.0)];
                [shadow setEndPoint:CGPointMake(0.5, 0.0)];
                shadow.frame = CGRectMake(0, self.bounds.size.height - radius, self.bounds.size.width, radius);
            } else if ([direction isEqualToString:@"left"])
            {
                shadow.frame = CGRectMake(0, 0, radius, self.bounds.size.height);
                [shadow setStartPoint:CGPointMake(0.0, 0.5)];
                [shadow setEndPoint:CGPointMake(1.0, 0.5)];
            } else if ([direction isEqualToString:@"right"])
            {
                shadow.frame = CGRectMake(self.bounds.size.width - radius, 0, radius, self.bounds.size.height);
                [shadow setStartPoint:CGPointMake(1.0, 0.5)];
                [shadow setEndPoint:CGPointMake(0.0, 0.5)];
            }
            
            shadow.colors = [NSArray arrayWithObjects:(id)[color CGColor], (id)[[UIColor clearColor] CGColor], nil];
            [self.layer insertSublayer:shadow atIndex:0];
        }
    }
}

- (void)chx_setBorderLine {
    [self chx_setBorderLineColor:kBorderLineGrayColor edge:UIRectEdgeAll];
}

- (void)chx_setBorderLineColor:(UIColor *)aColor {
    [self chx_setBorderLineColor:kBorderLineGrayColor edge:UIRectEdgeAll];
}

- (void)chx_setBorderLineColor:(UIColor *)aColor edge:(UIRectEdge)edge {
    CGRect lineFrame = CGRectZero;
    
    if (edge & UIRectEdgeTop) {
        lineFrame = CGRectMake(CGRectGetMinX(self.bounds),
                               CGRectGetMinY(self.bounds),
                               CGRectGetWidth(self.bounds),
                               kLineBorderWidth);
        [self pr_addBorderLineWithColor:aColor frame:lineFrame];
    }
    
    if (edge & UIRectEdgeBottom) {
        lineFrame = CGRectMake(CGRectGetMinX(self.bounds),
                               CGRectGetMaxY(self.bounds) + kLineBorderWidth,
                               CGRectGetWidth(self.bounds),
                               kLineBorderWidth);
        [self pr_addBorderLineWithColor:aColor frame:lineFrame];
    }
    
    if (edge & UIRectEdgeLeft) {
        lineFrame = CGRectMake(CGRectGetMinX(self.bounds),
                               CGRectGetMinY(self.bounds),
                               kLineBorderWidth,
                               CGRectGetHeight(self.bounds));
        [self pr_addBorderLineWithColor:aColor frame:lineFrame];
    }
    
    if (edge & UIRectEdgeRight) {
        lineFrame = CGRectMake(CGRectGetMaxX(self.bounds) - kLineBorderWidth,
                               CGRectGetMinY(self.bounds),
                               kLineBorderWidth,
                               CGRectGetHeight(self.bounds));
        [self pr_addBorderLineWithColor:aColor frame:lineFrame];
    }
}

- (void)pr_addBorderLineWithColor:(UIColor *)aColor frame:(CGRect)aFrame {
    CALayer *line = [[CALayer alloc] init];
    line.backgroundColor = aColor.CGColor;
    line.frame = aFrame;
    [self.layer addSublayer:line];
}

// Auto layout
- (void)chx_setBorderLineConstraintsWithColor:(UIColor *)color edge:(UIRectEdge)edge lineSizeMultiplier:(CGFloat)multiplier {
    if (edge == UIRectEdgeNone) {
        return;
    }
    
    NSLayoutAttribute edgeLayoutAttribute = NSLayoutAttributeNotAnAttribute;
    NSLayoutAttribute centerLayoutAttribute = NSLayoutAttributeNotAnAttribute;
    NSLayoutAttribute sizeLayoutAttribute = NSLayoutAttributeNotAnAttribute;
    NSString *visualFormat = nil;
    
    if (edge & UIRectEdgeLeft) {
        edgeLayoutAttribute = NSLayoutAttributeLeft;
        centerLayoutAttribute = NSLayoutAttributeCenterY;
        sizeLayoutAttribute = NSLayoutAttributeHeight;
        visualFormat = @"[lineView(0.5)]";
        [self pr_addBorderLineConstraintWithEdgeLayoutAttribute:edgeLayoutAttribute centerLayoutAttribute:centerLayoutAttribute sizeLayoutAttribute:sizeLayoutAttribute visualFormat:visualFormat color:color edge:edge lineSizeMultiplier:multiplier];
    }
    
    if (edge & UIRectEdgeRight) {
        edgeLayoutAttribute = NSLayoutAttributeRight;
        centerLayoutAttribute = NSLayoutAttributeCenterY;
        sizeLayoutAttribute = NSLayoutAttributeHeight;
        visualFormat = @"[lineView(0.5)]";
        [self pr_addBorderLineConstraintWithEdgeLayoutAttribute:edgeLayoutAttribute centerLayoutAttribute:centerLayoutAttribute sizeLayoutAttribute:sizeLayoutAttribute visualFormat:visualFormat color:color edge:edge lineSizeMultiplier:multiplier];
    }
    
    if (edge & UIRectEdgeTop) {
        edgeLayoutAttribute = NSLayoutAttributeTop;
        centerLayoutAttribute = NSLayoutAttributeCenterX;
        sizeLayoutAttribute = NSLayoutAttributeWidth;
        visualFormat = @"V:[lineView(0.5)]";
        [self pr_addBorderLineConstraintWithEdgeLayoutAttribute:edgeLayoutAttribute centerLayoutAttribute:centerLayoutAttribute sizeLayoutAttribute:sizeLayoutAttribute visualFormat:visualFormat color:color edge:edge lineSizeMultiplier:multiplier];
    }
    
    if (edge & UIRectEdgeBottom) {
        edgeLayoutAttribute = NSLayoutAttributeBottom;
        centerLayoutAttribute = NSLayoutAttributeCenterX;
        sizeLayoutAttribute = NSLayoutAttributeWidth;
        visualFormat = @"V:[lineView(0.5)]";
        [self pr_addBorderLineConstraintWithEdgeLayoutAttribute:edgeLayoutAttribute centerLayoutAttribute:centerLayoutAttribute sizeLayoutAttribute:sizeLayoutAttribute visualFormat:visualFormat color:color edge:edge lineSizeMultiplier:multiplier];
    }
}

- (void)pr_addBorderLineConstraintWithEdgeLayoutAttribute:(NSLayoutAttribute)edgeLayoutAttribute centerLayoutAttribute:(NSLayoutAttribute)centerLayoutAttribute sizeLayoutAttribute:(NSLayoutAttribute)sizeLayoutAttribute visualFormat:(NSString *)visualFormat color:(UIColor *)color edge:(UIRectEdge)edge lineSizeMultiplier:(CGFloat)multiplier {
    UIView *lineView = [UIView new];
    lineView.backgroundColor = color ? color : kBorderLineGrayColor;
    [lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:lineView];
    
    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:lineView
                                                        attribute:edgeLayoutAttribute
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:edgeLayoutAttribute
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:lineView
                                                        attribute:centerLayoutAttribute
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:centerLayoutAttribute
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:lineView
                                                        attribute:sizeLayoutAttribute
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:sizeLayoutAttribute
                                                       multiplier:multiplier
                                                         constant:0]]
     ];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView)]];
    
}

- (void)chx_setDashborderLineColor:(UIColor *)color {
    [self chx_setDashborderLineColor:color edge:UIRectEdgeAll];
}

- (void)chx_setDashborderLineColor:(UIColor *)color edge:(UIRectEdge)edge {
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat endX = 0;
    CGFloat endY = 0;
    
    if (edge & UIRectEdgeTop) {
        startX = 0;
        startY = 0;
        endX = CGRectGetWidth(self.bounds);
        endY = 0;
        [self pr_addDashborderLineColor:color points:@[@(startX), @(startY), @(endX), @(endY)]];
    }
    
    if (edge & UIRectEdgeBottom) {
        startX = 0;
        startY = CGRectGetHeight(self.bounds);
        endX = CGRectGetWidth(self.bounds);
        endY = startY;
        [self pr_addDashborderLineColor:color points:@[@(startX), @(startY), @(endX), @(endY)]];
    }
    if (edge & UIRectEdgeLeft) {
        startX = 0;
        startY = 0;
        endX = 0;
        endY = CGRectGetHeight(self.bounds);
        [self pr_addDashborderLineColor:color points:@[@(startX), @(startY), @(endX), @(endY)]];
    }
    
    if (edge & UIRectEdgeRight) {
        startX = CGRectGetWidth(self.bounds);
        startY = 0;
        endX = startX;
        endY = CGRectGetHeight(self.bounds);
        [self pr_addDashborderLineColor:color points:@[@(startX), @(startY), @(endX), @(endY)]];
    }
    
}

// http://stackoverflow.com/questions/12701825/drawing-dashed-line-using-calayer
- (void)pr_addDashborderLineColor:(UIColor *)color points:(NSArray *)points {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[color CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:@[@10, @5]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, [points[0] floatValue], [points[1] floatValue]);
    CGPathAddLineToPoint(path, NULL, [points[2] floatValue], [points[3] floatValue]);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [self.layer addSublayer:shapeLayer];
}

- (void)chx_setBorderWidth:(CGFloat)width color:(UIColor *)borderColor {
    self.layer.borderWidth = width;
    self.layer.borderColor = [borderColor CGColor];
}

@end
