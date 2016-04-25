//
//  AirView.h
//  Control
//
//  Created by lvjianxiong on 15/1/20.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirView : UIView

@property (nonatomic ,copy)NSString *infraTypeId;

- (void)btnLastStateAction:(NSString *)lastOrder;

@end
