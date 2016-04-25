//
//  CustomButton.h
//  YSApp
//
//  Created by lvjianxiong on 14/12/5.
//  Copyright (c) 2014年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

//编号
@property (nonatomic, strong) NSString *customTag;
//是否需要线条
@property (nonatomic, assign) BOOL needLineTop;
@property (nonatomic, assign) BOOL needLineLeft;
@property (nonatomic, assign) BOOL needLineBottom;
@property (nonatomic, assign) BOOL needLineRight;

//线条宽度
@property (nonatomic, assign) CGFloat lineWidthTop;
@property (nonatomic, assign) CGFloat lineWidthLeft;
@property (nonatomic, assign) CGFloat lineWidthBottom;
@property (nonatomic, assign) CGFloat lineWidthRight;

//线条颜色
@property (nonatomic, strong) UIColor *lineColorTop;
@property (nonatomic, strong) UIColor *lineColorLeft;
@property (nonatomic, strong) UIColor *lineColorBottom;
@property (nonatomic, strong) UIColor *lineColorRight;

//圆角
@property (nonatomic, assign) CGFloat radiusTopLeft;
@property (nonatomic, assign) CGFloat radiusTopRight;
@property (nonatomic, assign) CGFloat radiusBottomLeft;
@property (nonatomic, assign) CGFloat radiusBottomRight;

//内部填充颜色
@property (nonatomic, strong) UIColor *fillColor;

//根据自身情况进行裁剪
@property (nonatomic, assign) BOOL clipsToBoundsWithBorder;

-(void)setNeedLineTop:(BOOL)needTop left:(BOOL)needLeft bottom:(BOOL)needBottom right:(BOOL)needRight;
-(void)setLineColorTop:(UIColor *)colorTop left:(UIColor *)colorLeft bottom:(UIColor *)colorBottom right:(UIColor *)colorRight;
-(void)setLineWidthTop:(CGFloat)widthTop left:(CGFloat)widthLeft bottom:(CGFloat)widthBottom right:(CGFloat)widthRight;
-(void)setRadiusTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight;

@end
