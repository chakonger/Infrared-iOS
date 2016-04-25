//
//  AircleanerView.m
//  Control
//
//  Created by kucababy on 15/5/24.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import "AircleanerView.h"
#import "CustomImageView.h"
#import "CustomButton.h"
#import "CommonUtils.h"
#import "CustomView.h"
#import "SwitchView.h"
#import "UIColor+ZYHex.h"

//#define AirCleanerIconWidth 92
//#define BtnWidth (AppFrameWidth-AirCleanerIconWidth)/4

@interface AircleanerView (){
    
    UIImageView         *_topLineImageView;
    CustomView          *_bgView;
    UIImageView         *_iconImageView;
    SwitchView          *_onoffSwitch;
    CustomButton        *_timeBtn;
    CustomButton        *_secneBtn;
    
    CustomButton        *_modelBtn; //模式
    CustomButton        *_sleepBtn; //睡眠
    CustomButton        *_speedBtn; //风速
    CustomButton        *_ionBtn;   //负离子
    
    
}

@end


@implementation AircleanerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageAction:) name:kYSShowChangeDevImageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeControlValueAction:) name:kYSShowChangeOnfImageNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEleValueAction:) name:KYSShowIsOffEleNotification object:nil];
 //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changebutOnAction:) name:kYSShowPustNOendleNotification object:nil];
        
        
        _topLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AppFrameWidth, 0.5)];
        _topLineImageView.backgroundColor = [UIColor colorForHex:@"999999"];
        [self addSubview:_topLineImageView];
        [CommonUtils drawLine:_topLineImageView withSize:CGSizeMake(AppFrameWidth, 0.5) withIsVirtual:NO];
        
        _onoffSwitch = [[SwitchView alloc] initWithFrame:CGRectMake(0, 0, BtnWidth*2, CGRectGetHeight(frame)/2)];
        [self addSubview:_onoffSwitch];
        
        _bgView = [[CustomView alloc] initWithFrame:CGRectMake(2*BtnWidth, 1, AirCleanerIconWidth, CGRectGetHeight(frame)-1)];
        _bgView.backgroundColor = [UIColor clearColor];
        [_bgView setNeedLineTop:NO left:YES bottom:YES right:YES];
        [_bgView setLineColorTop:nil left:[UIColor colorForHex:@"dddddd"] bottom:[UIColor colorForHex:@"dddddd"] right:[UIColor colorForHex:@"dddddd"]];
        [self addSubview:_bgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDeviceMsgAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        UIImage *airImage = _IMAGE(@"mydevice_kongqijinghua_n");
        _iconImageView = [[UIImageView alloc] initWithImage:airImage];
        _iconImageView.frame = CGRectMake((AirCleanerIconWidth-ImageWidth(airImage))/2, (CGRectGetHeight(frame)-ImageHeight(airImage))/2, ImageWidth(airImage), ImageHeight(airImage));
        [_bgView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        [_iconImageView addGestureRecognizer:tap];
        
        _timeBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
        _timeBtn.frame = CGRectMake(CGRectGetMaxX(_bgView.frame), 1, BtnWidth, CGRectGetHeight(frame)/2);
        [_timeBtn.titleLabel setFont:_FONT(12.0f)];
        _timeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_timeBtn setTitle:@"定时" forState:UIControlStateNormal];
        [_timeBtn setTitle:@"定时" forState:UIControlStateDisabled];
        [_timeBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
        [_timeBtn setImage:_IMAGE(@"time_normal") forState:UIControlStateNormal];
        [_timeBtn setImage:_IMAGE(@"time_selected") forState:UIControlStateHighlighted];
        [_timeBtn setImage:_IMAGE(@"time_selected") forState:UIControlStateSelected];
        [_timeBtn setImage:_IMAGE(@"time_selected") forState:UIControlStateDisabled];
        [_timeBtn setBackgroundImage:[CommonUtils imageWithColor:[UIColor colorForHex:@"666666"]] forState:UIControlStateDisabled];
        [_timeBtn setNeedLineTop:NO left:NO bottom:NO right:YES];
        [_timeBtn setLineColorTop:nil left:nil bottom:nil right:[UIColor colorForHex:@"dddddd"]];
        [_timeBtn addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_timeBtn];
        [_timeBtn setEnabled:NO];
        
        _secneBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeBtn.frame), 1, BtnWidth, CGRectGetHeight(frame)/2)];
        [_secneBtn.titleLabel setFont:_FONT(12.0f)];
        _secneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_secneBtn setTitle:@"电量" forState:UIControlStateNormal];
        [_secneBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
        [_secneBtn setImage:_IMAGE(@"secne_normal") forState:UIControlStateNormal];
        [_secneBtn setImage:_IMAGE(@"secne_selected") forState:UIControlStateHighlighted];
        [_secneBtn setImage:_IMAGE(@"secne_selected") forState:UIControlStateHighlighted];
        [_secneBtn setNeedLineTop:NO left:NO bottom:NO right:NO];
        [_secneBtn setLineColorTop:nil left:nil bottom:nil right:nil];
        [_secneBtn addTarget:self action:@selector(secneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_secneBtn];
        
        _modelBtn = [[CustomButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_secneBtn.frame), BtnWidth, CGRectGetHeight(frame)/2-1)];
        [_modelBtn.titleLabel setFont:_FONT(12.0f)];
        _modelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_modelBtn setTitle:@"启/停" forState:UIControlStateNormal];
        [_modelBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
        [_modelBtn setImage:_IMAGE(@"model_normal") forState:UIControlStateNormal];
        [_modelBtn setImage:_IMAGE(@"model_selected") forState:UIControlStateHighlighted];
        [_modelBtn setImage:_IMAGE(@"model_selected") forState:UIControlStateHighlighted];
        [_modelBtn setNeedLineTop:YES left:NO bottom:YES right:YES];
        [_modelBtn setLineColorTop:[UIColor colorForHex:@"dddddd"] left:nil bottom:[UIColor colorForHex:@"dddddd"] right:[UIColor colorForHex:@"dddddd"]];
        _modelBtn.tag = 1;
        [_modelBtn addTarget:self action:@selector(sendCMDAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_modelBtn];
        
        _sleepBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_modelBtn.frame), CGRectGetMaxY(_secneBtn.frame), BtnWidth, CGRectGetHeight(frame)/2-1)];
        [_sleepBtn.titleLabel setFont:_FONT(12.0f)];
        _sleepBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sleepBtn setTitle:@"自动" forState:UIControlStateNormal];
        [_sleepBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
        UIImage *aimage = [UIImage imageNamed:@"auto_normal"];
        [_sleepBtn setImage:aimage forState:UIControlStateNormal];
        [_sleepBtn setImage:aimage forState:UIControlStateHighlighted];
        [_sleepBtn setImage:aimage forState:UIControlStateHighlighted];
        [_sleepBtn setNeedLineTop:YES left:NO bottom:YES right:NO];
        _sleepBtn.tag = 2;
        [_sleepBtn setLineColorTop:[UIColor colorForHex:@"dddddd"] left:nil bottom:[UIColor colorForHex:@"dddddd"] right:nil];
        [_sleepBtn addTarget:self action:@selector(sendCMDAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sleepBtn];
        
        _speedBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bgView.frame), CGRectGetMaxY(_secneBtn.frame), BtnWidth, CGRectGetHeight(frame)/2-1)];
        [_speedBtn.titleLabel setFont:_FONT(12.0f)];
        _speedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_speedBtn setTitle:@"风速" forState:UIControlStateNormal];
        [_speedBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
        [_speedBtn setImage:_IMAGE(@"device_speed") forState:UIControlStateNormal];
        [_speedBtn setImage:_IMAGE(@"device_speed") forState:UIControlStateHighlighted];
        [_speedBtn setImage:_IMAGE(@"device_speed") forState:UIControlStateHighlighted];
        [_speedBtn setNeedLineTop:YES left:NO bottom:YES right:YES];
        _speedBtn.tag = 3;
        [_speedBtn setLineColorTop:[UIColor colorForHex:@"dddddd"] left:nil bottom:[UIColor colorForHex:@"dddddd"] right:[UIColor colorForHex:@"dddddd"]];
        [_speedBtn addTarget:self action:@selector(sendCMDAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_speedBtn];
        
        _ionBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_speedBtn.frame), CGRectGetMaxY(_secneBtn.frame), BtnWidth, CGRectGetHeight(frame)/2-1)];
        [_ionBtn.titleLabel setFont:_FONT(12.0f)];
        _ionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_ionBtn setTitle:@"睡眠" forState:UIControlStateNormal];
        [_ionBtn setTitleColor:[UIColor colorForHex:@"999999"] forState:UIControlStateNormal];
        [_ionBtn setImage:_IMAGE(@"device_sleep") forState:UIControlStateNormal];
        [_ionBtn setImage:_IMAGE(@"device_sleep") forState:UIControlStateHighlighted];
        [_ionBtn setImage:_IMAGE(@"device_sleep") forState:UIControlStateHighlighted];
        [_ionBtn setNeedLineTop:YES left:NO bottom:YES right:NO];
        _ionBtn.tag = 4;
        [_ionBtn setLineColorTop:[UIColor colorForHex:@"dddddd"] left:nil bottom:[UIColor colorForHex:@"dddddd"] right:nil];
        [_ionBtn addTarget:self action:@selector(sendCMDAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_ionBtn];
        
        
        
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

//#define kYSShowQTActionNotification         @"ysshowqtaction"
//#define kYSShowAutoActionNotification       @"ysshowautoaction"
//#define kYSShowSpeedActionNotification      @"ysshowspeedaction"
//#define kYSShowSleepActionNotification      @"ysshowsleepaction"


- (void)dealloc{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:kYSShowChangeDevImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kYSShowChangeBtnImageNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KYSShowIsOffEleNotification object:nil];
}

- (void)timeAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowDatePickerNotification object:button];
}

- (void)secneAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowSceneActionNotification object:button];
}

/*
 Integer statues = (Integer) iv_switch.getTag();
 if (statues == STATUE_OFF) {
 inst = "T_ON";
 show = "开";
 iv_switch.setTag(STATUE_ON);
 iv_switch.setImageResource(R.drawable.new_switch_on);
 } else if (statues == STATUE_ON) {
 inst = "T_OFF";
 show = "关";
 iv_switch.setTag(STATUE_OFF);
 iv_switch.setImageResource(R.drawable.new_switch_off);
 }
 break;
 case R.id.ll_kgkj_onoff:
 inst = "T_ONOFF";
 show = "启/停";
 break;
 case R.id.ll_kgkj_speed:
 inst = "T_FANSPEED";
 show = "风速";
 break;
 case R.id.ll_kgkj_auto:
 inst = "T_AUTO";
 show = "自动";
 break;
 case R.id.ll_kgkj_sleep:
 inst = "T_SLEEP";
 show = "睡眠";
 break;
 case R.id.ll_kgkj_uv:
 inst = "T_UV";
 show = "紫外线";
 break;
 case R.id.ll_kgkj_ions:
 inst = "T_ION";
 show = "负离子";
 break;
 */
- (void)sendCMDAction:(CustomButton *)button{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param removeAllObjects];
    switch (button.tag) {
        case 1://启/停
            //T_ONOFF 启/停
            [param setValue:@"T_ONOFF" forKey:@"order"];
            [param setValue:@"启/停" forKey:@"content"];
            break;
        case 2://自动
            //T_AUTO    自动
            [param setValue:@"T_AUTO" forKey:@"order"];
            [param setValue:@"自动" forKey:@"content"];
            break;
        case 3://风速
            //T_FANSPEED    风速
            [param setValue:@"T_FANSPEED" forKey:@"order"];
            [param setValue:@"风速" forKey:@"content"];
            break;
        case 4://睡眠
            //T_SLEEP   睡眠
            [param setValue:@"T_SLEEP" forKey:@"order"];
            [param setValue:@"睡眠" forKey:@"content"];
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowKJCMDActionNotification object:param];
}

/*
- (void)autoAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowAutoActionNotification object:button];
}

- (void)speedAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowSpeedActionNotification object:button];
}

- (void)sleepAction:(CustomButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowSleepActionNotification object:button];
}
*/

- (void)setDeviceMsgAction:(UITapGestureRecognizer *)gesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowPushControlViewNotification object:gesture];
}


- (void)changeImageAction:(NSNotification *)notification{
    UIImage *image = (UIImage *)notification.object;
    _iconImageView.image = image;
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
-(void)changebutOnAction:(NSNotification *)notification
{
    if ([notification.userInfo[@"text"] isEqualToString:@"endled"]) {
        _secneBtn.enabled = NO;
        _timeBtn.enabled = NO;
        _onoffSwitch.userInteractionEnabled = NO;
        _modelBtn.enabled = NO;
        _sleepBtn.enabled = NO;
        _speedBtn.enabled = NO;
        _ionBtn.enabled = NO;
        
        
//        SwitchView          *_onoffSwitch;
//        CustomButton        *_timeBtn;
//        CustomButton        *_secneBtn;
//        CustomButton        *_modelBtn;
//        CustomButton        *_temperatureBtn;
//        CustomButton        *_speedBtn;
//        CustomButton        *_directionBtn;
        
    }

}


- (void)btnLastStateAction:(NSString *)lastOrder{
//    if ([openOrder isEqualToString:@"0"]) {
//        [_onoffSwitch changeBtnStateAction:NO];
//    }else{
//        [_onoffSwitch changeBtnStateAction:YES];
//    }
}

- (void)changeControlValueAction:(NSNotification *)notification{
    NSString *order = notification.object;
    if ([order isEqualToString:@"T_OFF"]) {
        [_onoffSwitch changeBtnStateAction:NO];
    }else{
        [_onoffSwitch changeBtnStateAction:YES];
    }
}


@end
