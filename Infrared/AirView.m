//
//  AirView.m
//  Control
//
//  Created by lvjianxiong on 15/1/20.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//  空调

#import "AirView.h"
#import "CustomImageView.h"
#import "CustomButton.h"
#import "CommonUtils.h"
#import "CustomView.h"
#import "SwitchView.h"
#import "UIColor+ZYHex.h"



@interface AirView (){
    
    UIImageView         *_topLineImageView;
    //CustomView          *_bgView;
   // UIImageView         *_iconImageView;
    SwitchView          *_onoffSwitch;
    CustomButton        *_timeBtn;
    CustomButton        *_secneBtn;
    CustomButton        *_modelBtn;
    CustomButton        *_temperatureBtn;
    CustomButton        *_speedBtn;
    CustomButton        *_directionBtn;
    
    
}

@end

@implementation AirView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       // self.backgroundColor = [UIColor clearColor];
        
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageAction:) name:kYSShowChangeDevImageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnValueAction:) name:kYSShowChangeBtnImageNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEleValueAction:) name:KYSShowIsOffEleNotification object:nil];
        
 //       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changebutOnAction:) name:kYSShowPustNOendleNotification object:nil];
        
        _topLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AppFrameWidth, 0.5)];
        _topLineImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_topLineImageView];
        [CommonUtils drawLine:_topLineImageView withSize:CGSizeMake(AppFrameWidth, 0.5) withIsVirtual:NO];
        
        _onoffSwitch = [[SwitchView alloc] initWithFrame:CGRectMake(0, 0, BtnWidth*2, CGRectGetHeight(frame)/2)];
        [self addSubview:_onoffSwitch];
        
       // _bgView = [[CustomView alloc] initWithFrame:CGRectMake(2*BtnWidth, 1, AirIconWidth, CGRectGetHeight(frame)-1)];
      //  _bgView.backgroundColor = [UIColor clearColor];
       // [_bgView setNeedLineTop:NO left:YES bottom:YES right:YES];
       // [_bgView setLineColorTop:nil left:[UIColor colorForHex:@"dddddd"] bottom:[UIColor colorForHex:@"dddddd"] right:[UIColor colorForHex:@"dddddd"]];
       // [self addSubview:_bgView];
        
       // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDeviceMsgAction:)];
       // tap.numberOfTapsRequired = 1;
       // tap.numberOfTouchesRequired = 1;
        
       // UIImage *airImage = _IMAGE(@"air_normal");
       // _iconImageView = [[UIImageView alloc] initWithImage:airImage];
       // _iconImageView.frame = CGRectMake((AirIconWidth-ImageWidth(airImage))/2, (CGRectGetHeight(frame)-ImageHeight(airImage))/2, ImageWidth(airImage), ImageHeight(airImage));
       // [_bgView addSubview:_iconImageView];
       // _iconImageView.userInteractionEnabled = YES;
       // [_iconImageView addGestureRecognizer:tap];
        
        _timeBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
        _timeBtn.frame = CGRectMake(CGRectGetMaxX(_onoffSwitch.frame), 1, BtnWidth, CGRectGetHeight(frame)/2);
        [_timeBtn.titleLabel setFont:_FONT(14.0f)];
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
        
        _secneBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeBtn.frame), 1, BtnWidth, CGRectGetHeight(frame)/2)];
        [_secneBtn.titleLabel setFont:_FONT(14.0f)];
        _secneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_secneBtn setTitle:@"电量" forState:UIControlStateNormal];
        [_secneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_secneBtn setImage:_IMAGE(@"secne_normal") forState:UIControlStateNormal];
        [_secneBtn setImage:_IMAGE(@"secne_selected") forState:UIControlStateHighlighted];
        [_secneBtn setImage:_IMAGE(@"secne_selected") forState:UIControlStateSelected];
        [_secneBtn setNeedLineTop:NO left:NO bottom:NO right:NO];
        [_secneBtn setLineColorTop:nil left:nil bottom:nil right:nil];
        [_secneBtn addTarget:self action:@selector(secneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_secneBtn];
        
        _modelBtn = [[CustomButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_secneBtn.frame), BtnWidth, CGRectGetHeight(frame)/2-1)];
        [_modelBtn.titleLabel setFont:_FONT(14.0f)];
        _modelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_modelBtn setTitle:@"模式" forState:UIControlStateNormal];
        [_modelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_modelBtn setImage:_IMAGE(@"model_normal") forState:UIControlStateNormal];
        [_modelBtn setImage:_IMAGE(@"model_selected") forState:UIControlStateHighlighted];
        [_modelBtn setImage:_IMAGE(@"model_selected") forState:UIControlStateHighlighted];
        [_modelBtn setNeedLineTop:YES left:YES bottom:YES right:YES];
        [_modelBtn setLineColorTop:[UIColor colorForHex:@"dddddd"] left:[UIColor colorForHex:@"dddddd"] bottom:[UIColor colorForHex:@"dddddd"] right:[UIColor colorForHex:@"dddddd"]];
        [_modelBtn addTarget:self action:@selector(modelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_modelBtn];
        
        _temperatureBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_modelBtn.frame), CGRectGetMaxY(_secneBtn.frame), BtnWidth, CGRectGetHeight(frame)/2-1)];
        [_temperatureBtn.titleLabel setFont:_FONT(14.0f)];
        _temperatureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_temperatureBtn setTitle:@"24" forState:UIControlStateNormal];//℃
        [_temperatureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        NSData *aData = [aString dataUsingEncoding: NSUTF8StringEncoding];
        UIImage *aimage = [UIImage imageNamed:@"direction_direction"];
        [_temperatureBtn setImage:aimage forState:UIControlStateNormal];
        [_temperatureBtn setImage:aimage forState:UIControlStateHighlighted];
        [_temperatureBtn setImage:aimage forState:UIControlStateHighlighted];
        [_temperatureBtn setNeedLineTop:YES left:NO bottom:YES right:YES];
        [_temperatureBtn setLineColorTop:[UIColor colorForHex:@"dddddd"] left:nil bottom:[UIColor colorForHex:@"dddddd"] right:[UIColor colorForHex:@"dddddd"]];
        [_temperatureBtn addTarget:self action:@selector(temperatureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_temperatureBtn];
        
        _speedBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_onoffSwitch.frame), CGRectGetMaxY(_secneBtn.frame), BtnWidth, CGRectGetHeight(frame)/2-1)];
        [_speedBtn.titleLabel setFont:_FONT(14.0f)];
        _speedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_speedBtn setTitle:@"风速" forState:UIControlStateNormal];
        [_speedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_speedBtn setImage:_IMAGE(@"auto_normal") forState:UIControlStateNormal];
        [_speedBtn setImage:_IMAGE(@"auto_selected") forState:UIControlStateHighlighted];
        [_speedBtn setImage:_IMAGE(@"auto_selected") forState:UIControlStateHighlighted];
        [_speedBtn setNeedLineTop:YES left:NO bottom:YES right:YES];
        [_speedBtn setLineColorTop:[UIColor colorForHex:@"dddddd"] left:nil bottom:[UIColor colorForHex:@"dddddd"] right:[UIColor colorForHex:@"dddddd"]];
        [_speedBtn addTarget:self action:@selector(speedAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_speedBtn];
        
        _directionBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_speedBtn.frame), CGRectGetMaxY(_secneBtn.frame), BtnWidth, CGRectGetHeight(frame)/2-1)];
        [_directionBtn.titleLabel setFont:_FONT(14.0f)];
        _directionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_directionBtn setTitle:@"风向" forState:UIControlStateNormal];
        [_directionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_directionBtn setImage:_IMAGE(@"auto_normal") forState:UIControlStateNormal];
        [_directionBtn setImage:_IMAGE(@"auto_selected") forState:UIControlStateHighlighted];
        [_directionBtn setImage:_IMAGE(@"auto_selected") forState:UIControlStateHighlighted];
        [_directionBtn setNeedLineTop:YES left:NO bottom:YES right:NO];
        [_directionBtn setLineColorTop:[UIColor colorForHex:@"dddddd"] left:nil bottom:[UIColor colorForHex:@"dddddd"] right:nil];
        [_directionBtn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_directionBtn];
        
        self.backgroundColor = [UIColor whiteColor];
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
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kYSShowChangeDevImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYSShowChangeBtnImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KYSShowIsOffEleNotification object:nil];
    
    
}

- (void)timeAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowDatePickerNotification object:button];
}

- (void)secneAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowSceneActionNotification object:button];
}

- (void)modelAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowModelPickerNotification object:button];
}

- (void)temperatureAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowTemperatureNotification object:button];
}

- (void)speedAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowSpeedNotification object:button];
}

- (void)directionAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowDirectionNotification object:button];
}

- (void)setDeviceMsgAction:(UITapGestureRecognizer *)gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowPushControlViewNotification object:gesture];
}

- (void)changeImageAction:(NSNotification *)notification{
   // UIImage *image = (UIImage *)notification.object;
   // _iconImageView.image = image;
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



- (void)btnLastStateAction:(NSString *)lastOrder{
    if (lastOrder.length != 6) {
        lastOrder = @"100800";
    }
    NSString *openOrder = [lastOrder substringToIndex:1];
    NSString *modelOrder = [lastOrder substringWithRange:NSMakeRange(1, 1)];
    NSString *temperatureOrder = [lastOrder substringWithRange:NSMakeRange(2, 2)];
    NSString *speedOrder = [lastOrder substringWithRange:NSMakeRange(4, 1)];
    NSString *directionOrder = [lastOrder substringWithRange:NSMakeRange(5, 1)];
    NSUInteger modexIndex = [kModelKeyArray indexOfObject:modelOrder];
    NSUInteger temperatureIndex = [kTemperatureKeyArray indexOfObject:temperatureOrder];
    NSUInteger speedIndex = [kSpeedKeyArray indexOfObject:speedOrder];
    NSUInteger directionIndex = [kDirectionKeyArray indexOfObject:directionOrder];
    modexIndex = (modexIndex==NSNotFound)?0:modexIndex;
    temperatureIndex = (temperatureIndex==NSNotFound)?0:temperatureIndex;
    speedIndex = (speedIndex==NSNotFound)?0:speedIndex;
    directionIndex = (directionIndex==NSNotFound)?0:directionIndex;
    
    if ([openOrder isEqualToString:@"0"]) {
        [_onoffSwitch changeBtnStateAction:NO];
    }else{
        [_onoffSwitch changeBtnStateAction:YES];
    }
    
    NSString *model_value = [kModelValueArray objectAtIndex:modexIndex];
    UIImage *model_image = [kModelArray objectAtIndex:modexIndex];
    [_modelBtn setImage:model_image forState:UIControlStateNormal];
    [_modelBtn setImage:model_image forState:UIControlStateSelected];
    [_modelBtn setImage:model_image forState:UIControlStateHighlighted];
    [_modelBtn setTitle:model_value forState:UIControlStateNormal];
    
    NSString *temperature_value = [kTemperatureValueArray objectAtIndex:temperatureIndex];
    temperature_value = [NSString stringWithFormat:@"%@",temperature_value];//℃
    [_temperatureBtn setTitle:temperature_value forState:UIControlStateNormal];
    [_temperatureBtn setTitle:temperature_value forState:UIControlStateHighlighted];
    [_temperatureBtn setTitle:temperature_value forState:UIControlStateSelected];
    
    NSString *speed_value = [kSpeedValueArray objectAtIndex:speedIndex];
    UIImage *speed_image = [kSpeedArray objectAtIndex:speedIndex];
    [_speedBtn setImage:speed_image forState:UIControlStateNormal];
    [_speedBtn setImage:speed_image forState:UIControlStateSelected];
    [_speedBtn setImage:speed_image forState:UIControlStateHighlighted];
    [_speedBtn setTitle:speed_value forState:UIControlStateNormal];
    
    
    NSString *direction_value = [kDirectionValueArray objectAtIndex:directionIndex];
    UIImage *direction_image = [kDirectionArray objectAtIndex:directionIndex];
    [_directionBtn setImage:direction_image forState:UIControlStateNormal];
    [_directionBtn setImage:direction_image forState:UIControlStateSelected];
    [_directionBtn setImage:direction_image forState:UIControlStateHighlighted];
    [_directionBtn setTitle:direction_value forState:UIControlStateNormal];
}

- (void)changeBtnValueAction:(NSNotification *)notification{
   // NSLog(@"notification%@",notification.object);
    
   
    NSString *lastInst = notification.object;
    NSArray *arr = [lastInst componentsSeparatedByString:@"and"];
    if (arr[1] == self.infraTypeId) {
        
        NSString *lastOrder = arr[0];
    
    if (lastOrder.length==6) {
        NSString *openOrder = [lastOrder substringToIndex:1];
        NSString *modelOrder = [lastOrder substringWithRange:NSMakeRange(1, 1)];
        NSString *temperatureOrder = [lastOrder substringWithRange:NSMakeRange(2, 2)];
        NSString *speedOrder = [lastOrder substringWithRange:NSMakeRange(4, 1)];
        NSString *directionOrder = [lastOrder substringWithRange:NSMakeRange(5, 1)];
        NSUInteger modexIndex = [kModelKeyArray indexOfObject:modelOrder];
        NSUInteger temperatureIndex = [kTemperatureKeyArray indexOfObject:temperatureOrder];
        NSUInteger speedIndex = [kSpeedKeyArray indexOfObject:speedOrder];
        NSUInteger directionIndex = [kDirectionKeyArray indexOfObject:directionOrder];
        
        modexIndex = (modexIndex==NSNotFound)?0:modexIndex;
        temperatureIndex = (temperatureIndex==NSNotFound)?0:temperatureIndex;
        speedIndex = (speedIndex==NSNotFound)?0:speedIndex;
        directionIndex = (directionIndex==NSNotFound)?0:directionIndex;
        
        if ([openOrder isEqualToString:@"0"]) {
            [_onoffSwitch changeBtnStateAction:NO];
        }else{
            [_onoffSwitch changeBtnStateAction:YES];
        }
        
        NSString *model_value = [kModelValueArray objectAtIndex:modexIndex];
        UIImage *model_image = [kModelArray objectAtIndex:modexIndex];
        [_modelBtn setImage:model_image forState:UIControlStateNormal];
        [_modelBtn setImage:model_image forState:UIControlStateSelected];
        [_modelBtn setImage:model_image forState:UIControlStateHighlighted];
        [_modelBtn setTitle:model_value forState:UIControlStateNormal];
        
        NSString *temperature_value = [kTemperatureValueArray objectAtIndex:temperatureIndex];
        temperature_value = [NSString stringWithFormat:@"%@",temperature_value];//℃
        [_temperatureBtn setTitle:temperature_value forState:UIControlStateNormal];
        [_temperatureBtn setTitle:temperature_value forState:UIControlStateHighlighted];
        [_temperatureBtn setTitle:temperature_value forState:UIControlStateSelected];
        
        NSString *speed_value = [kSpeedValueArray objectAtIndex:speedIndex];
        UIImage *speed_image = [kSpeedArray objectAtIndex:speedIndex];
        [_speedBtn setImage:speed_image forState:UIControlStateNormal];
        [_speedBtn setImage:speed_image forState:UIControlStateSelected];
        [_speedBtn setImage:speed_image forState:UIControlStateHighlighted];
        [_speedBtn setTitle:speed_value forState:UIControlStateNormal];
        
        
        NSString *direction_value = [kDirectionValueArray objectAtIndex:directionIndex];
        UIImage *direction_image = [kDirectionArray objectAtIndex:directionIndex];
        [_directionBtn setImage:direction_image forState:UIControlStateNormal];
        [_directionBtn setImage:direction_image forState:UIControlStateSelected];
        [_directionBtn setImage:direction_image forState:UIControlStateHighlighted];
        [_directionBtn setTitle:direction_value forState:UIControlStateNormal];
    }
   }
}

-(void)changebutOnAction:(NSNotification *)notification
{
    if ([notification.userInfo[@"text"] isEqualToString:@"endled"]) {
        _secneBtn.enabled = NO;
        _timeBtn.enabled = NO;
        _onoffSwitch.userInteractionEnabled = NO;
        _modelBtn.enabled = NO;
        _speedBtn.enabled = NO;
        _temperatureBtn.enabled = NO;
        _directionBtn.enabled = NO;
        
    }
    
}



@end
