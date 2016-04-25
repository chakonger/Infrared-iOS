//
//  SwitchView.m
//  Control
//
//  Created by lvjianxiong on 15/1/20.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import "SwitchView.h"
#import "UIColor+ZYHex.h"

@interface SwitchView (){
    UILabel     *_onLabel;
    UILabel     *_offLabel;
}

@end

@implementation SwitchView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width  = frame.size.width;
        CGFloat height = frame.size.height;
        UIImage *btnOffImage = _IMAGE(@"switch_off");
        UIImage *btnOnImage = _IMAGE(@"switch_on");
        _onoffBtn = [[UIButton alloc] initWithFrame:CGRectMake((width-ImageWidth(btnOffImage))/2, (height-ImageHeight(btnOffImage))/2, ImageWidth(btnOffImage), ImageHeight(btnOffImage))];
        [_onoffBtn setImage:btnOffImage forState:UIControlStateNormal];
        [_onoffBtn setImage:btnOnImage forState:UIControlStateHighlighted];
        [_onoffBtn setImage:btnOnImage forState:UIControlStateSelected];
        [_onoffBtn addTarget:self action:@selector(onoffAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_onoffBtn];
        
        _onLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_onoffBtn.frame)-29, (height-20)/2, 20, 20)];
        _onLabel.textColor = [UIColor blackColor];
        _onLabel.textAlignment = NSTextAlignmentRight;
        _onLabel.text = @"关";
        _onLabel.font = _FONT(14.0f);
        [self addSubview:_onLabel];
        
        _offLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_onoffBtn.frame)+9, (height-20)/2, 20, 20)];
        _offLabel.textColor = [UIColor blackColor];
        _offLabel.text = @"开";
        _offLabel.font = _FONT(14.0f);
        [self addSubview:_offLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnAction:) name:kYSShowOnOffChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYSShowOnOffChangeNotification object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)onoffAction:(UIButton *)button{
    if (button.selected) {
        [button setSelected:NO];
        _offLabel.textColor = [UIColor colorForHex:@"999999"];        
    }else{

        _offLabel.textColor = [UIColor colorWithRed:0 green:0.62 blue:0.21 alpha:1];
        [button setSelected:YES];
    }
    [_delegate operateAction:_devFlag withOpenOrClose:button.selected];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowOnOffSwitchNotification object:self];
}

- (void)changeBtnAction:(NSNotification *)notification{
    NSNumber *num = notification.object;
    if (num<=0) {
        [_onoffBtn setSelected:NO];
        _offLabel.textColor = [UIColor colorForHex:@"999999"];
    }else{
        _offLabel.textColor = [UIColor colorWithRed:0 green:0.62 blue:0.21 alpha:1];
        [_onoffBtn setSelected:YES];
    }
    
}

- (void)changeBtnStateAction:(BOOL)flag{
    if (flag) {
        _offLabel.textColor = [UIColor colorWithRed:0 green:0.62 blue:0.21 alpha:1];
        [_onoffBtn setSelected:YES];
    }else{
        [_onoffBtn setSelected:NO];
        _offLabel.textColor = [UIColor colorForHex:@"999999"];

    }
   
}

@end
