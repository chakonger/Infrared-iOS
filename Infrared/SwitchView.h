//
//  SwitchView.h
//  Control
//
//  Created by lvjianxiong on 15/1/20.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchViewDelegate <NSObject>

- (void)operateAction:(NSString *)friendId withOpenOrClose:(BOOL)operOrClose;//YES为open，NO为close

@end

@interface SwitchView : UIView


@property (nonatomic, assign) id<SwitchViewDelegate> delegate;

@property (nonatomic, strong) UIButton    *onoffBtn;

@property (nonatomic, strong) NSString    *devFlag;

- (void)onoffAction:(UIButton *)button;

- (void)changeBtnStateAction:(BOOL)flag;


@end
