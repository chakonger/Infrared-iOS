//
//  TelevisionView.m
//  Control
//
//  Created by lvjianxiong on 15/1/20.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//  插座

#import "TelevisionView.h"
#import "CustomButton.h"
#import "CommonUtils.h"
#import "CustomView.h"
#import "SwitchView.h"
#import "UIColor+ZYHex.h"


//#define AirIconWidth 92
//#define BtnWidth (AppFrameWidth-AirIconWidth)/4

@interface TelevisionView (){
    UIImageView         *_topLineImageView;
   // CustomView          *_bgView;
  //  UIImageView         *_iconImageView;
    SwitchView          *_onoffSwitch;
    CustomButton        *_timeBtn;
    CustomButton        *_secneBtn;
}

@end

@implementation TelevisionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
     
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnValueAction:) name:kYSShowChangeOnfImageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEleValueAction:) name:KYSShowIsOffEleNotification object:nil];
        
        self.backgroundColor = [UIColor whiteColor];
        
        _topLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AppFrameWidth, 0.5)];
        _topLineImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_topLineImageView];
        [CommonUtils drawLine:_topLineImageView withSize:CGSizeMake(AppFrameWidth, 0.5) withIsVirtual:NO];
        
        _onoffSwitch = [[SwitchView alloc] initWithFrame:CGRectMake(0, 0, BtnWidth*2, CGRectGetHeight(frame))];
       
        [self addSubview:_onoffSwitch];
        
       // _bgView = [[CustomView alloc] initWithFrame:CGRectMake(2*BtnWidth, 1, AirIconWidth, CGRectGetHeight(frame))];
       // _bgView.backgroundColor = [UIColor clearColor];
       // [_bgView setNeedLineTop:NO left:YES bottom:NO right:YES];
        //[_bgView setLineColorTop:nil left:[UIColor colorForHex:@"dddddd"] bottom:nil right:[UIColor colorForHex:@"dddddd"]];
        //[self addSubview:_bgView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDeviceMsgAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
       // UIImage *airImage = _IMAGE(@"control_blue");
      //  _iconImageView = [[UIImageView alloc] initWithImage:airImage];
       // _iconImageView.frame = CGRectMake((AirIconWidth-ImageWidth(airImage))/2, (CGRectGetHeight(frame)-ImageHeight(airImage))/2, ImageWidth(airImage), ImageHeight(airImage));
       // [_bgView addSubview:_iconImageView];
       // _iconImageView.userInteractionEnabled = YES;
        //[_iconImageView addGestureRecognizer:tap];
        
        _timeBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
        _timeBtn.frame = CGRectMake(CGRectGetMaxX(_onoffSwitch.frame), 1, BtnWidth, CGRectGetHeight(frame));
        [_timeBtn.titleLabel setFont:_FONT(12.0f)];
        _timeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_timeBtn setTitle:@"定时" forState:UIControlStateNormal];
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_timeBtn setImage:_IMAGE(@"time_normal") forState:UIControlStateNormal];
        [_timeBtn setImage:_IMAGE(@"time_selected") forState:UIControlStateHighlighted];
        [_timeBtn setImage:_IMAGE(@"time_selected") forState:UIControlStateHighlighted];
        [_timeBtn setNeedLineTop:NO left:YES bottom:NO right:YES];
        [_timeBtn setLineColorTop:nil left:[UIColor colorForHex:@"dddddd"] bottom:nil right:[UIColor colorForHex:@"dddddd"]];
        [_timeBtn addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_timeBtn];
        
        _secneBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeBtn.frame), 1, BtnWidth, CGRectGetHeight(frame))];
        [_secneBtn.titleLabel setFont:_FONT(12.0f)];
        _secneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_secneBtn setTitle:@"电量" forState:UIControlStateNormal];
        [_secneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_secneBtn setImage:_IMAGE(@"secne_normal") forState:UIControlStateNormal];
        [_secneBtn setImage:_IMAGE(@"secne_selected") forState:UIControlStateHighlighted];
        [_secneBtn setImage:_IMAGE(@"secne_selected") forState:UIControlStateHighlighted];
        [_secneBtn setNeedLineTop:NO left:NO bottom:NO right:NO];
        [_secneBtn setLineColorTop:nil left:nil bottom:nil right:nil];
        [_secneBtn addTarget:self action:@selector(secneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_secneBtn];
        
        self.layer.masksToBounds = YES;
        //设置边框及边框颜色
        self.layer.borderWidth = 0.5;
        self.layer.borderColor =[[UIColor colorForHex:@"dddddd"] CGColor];

        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:kYSShowChangeDevImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYSShowChangeOnfImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KYSShowIsOffEleNotification object:nil];
    
}

- (void)timeAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowDatePickerNotification object:button];
}

- (void)secneAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowSceneActionNotification object:button];
}

- (void)setDeviceMsgAction:(UITapGestureRecognizer *)gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowPushControlViewNotification object:gesture];
}

- (void)changeImageAction:(NSNotification *)notification{
  //  UIImage *image = (UIImage *)notification.object;
  //  _iconImageView.image = image;
}
- (void)changeEleValueAction:(NSNotification *)text
{
    if ([text.userInfo[@"devStatus"] isEqualToString:@"A002"]) {
        _secneBtn.enabled = NO;
        _secneBtn.backgroundColor = [UIColor colorForHex:@"E6E6E6"];
    }else
    {
        _secneBtn.enabled = YES;
        _secneBtn.backgroundColor = [UIColor clearColor];
        
    }
    
}


- (void)btnLastOrderAction:(NSString *)order{
    if ([order isEqualToString:@"0"]) {
        [_onoffSwitch changeBtnStateAction:NO];
    }else{
        [_onoffSwitch changeBtnStateAction:YES];
    }
}

- (void)changeBtnValueAction:(NSNotification *)notification{
    NSString *order = notification.object;
   
    if ([order isEqualToString:@"0"]) {
        [_onoffSwitch changeBtnStateAction:NO];
    }else{
        [_onoffSwitch changeBtnStateAction:YES];
    }
}

@end
