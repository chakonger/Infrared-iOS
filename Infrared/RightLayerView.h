//
//  RightLayerView.h
//  Control
//
//  Created by lvjianxiong on 15/1/28.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RightLayerDelegate <NSObject>

@required
- (void)pushAboutViewController:(NSInteger)tag;

@end


@interface RightLayerView : UIView

@property (nonatomic, assign) id<RightLayerDelegate> delegate;
//圆角
@property (nonatomic, assign) CGFloat radiusTopLeft;
@property (nonatomic, assign) CGFloat radiusTopRight;
@property (nonatomic, assign) CGFloat radiusBottomLeft;
@property (nonatomic, assign) CGFloat radiusBottomRight;

-(void)setRadiusTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight;

@end
