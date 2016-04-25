//
//  ChatViewController.m
//  Infrared
//
//  Created by ToTank on 16/2/25.
//  Copyright © 2016年 史志勇. All rights reserved.
//

#import "ChatViewController.h"
#import "ImageDataPickerViewController.h"
#import "DataPickerViewController.h"
#import "MessageInputView.h"
#import "ZYCustomButton.h"
#import "CustomButton.h"
#import "SwitchView.h"
#import "RightLayerView.h"
#import "UIImageView+WebCache.h"
#import "ChatRecordItem.h"
#import "CommonUtils.h"
#import "ChatMessageCell.h"
#import "UIMessageObject.h"
#import "ZYHttpTool.h"
#import "LoadingView.h"

#include "WaveGenerator.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>



@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,ImageDataPickerViewControllerDelegate,DataPickerViewControllerDelegate,RightLayerDelegate>
{
    UITableView        *_tableView;
    MessageInputView   *_messageInputView;
    RightLayerView                  *_rightlayerView;
    UIImage                         *_myAvatarImage;
    
    float                   _systemValue;
    MPMusicPlayerController *_musicPlayer;

    
    ImageDataPickerViewController   *_modelPicker;
    DataPickerViewController        *_temperaturePicker;
    ImageDataPickerViewController   *_speedPicker;
    ImageDataPickerViewController   *_directionPicker;
    
    ZYCustomButton                  *_ZYCustonButton;
    SwitchView                      *_onoffSwitch;
    CustomButton                    *_modelBtn;
    CustomButton                    *_tmperatureBtn;
    CustomButton                    *_speedBtn;
    CustomButton                    *_directionBtn;
    NSMutableArray                  *_messageArray;
    //命令
    NSUInteger                      _onoffIndex;
    NSUInteger                      _modelIndex;
    NSUInteger                      _temperatureIndex;
    NSUInteger                      _speedIndex;
    NSUInteger                      _directionIndex;
    NSString                        *_chatContent;
    
    


}
@property (retain, nonatomic)   AVAudioPlayer           *player;

@property (nonatomic, strong)ChatRecordDB *itemDB;
@property (nonatomic, strong)ChatRecordItemVO *vo;
@property (nonatomic, strong)ViewListItemDB *ListDB;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.title = self.listItemVO.typeName;
     _player = [[AVAudioPlayer alloc]init];
    
    _messageArray = [NSMutableArray array];
    _onoffIndex = 0;
    _modelIndex = 0;
    _temperatureIndex = 8;
    _speedIndex = 0;
    _directionIndex = 0;
    
    if ([self.listItemVO.bigType isEqualToString:@"KGHW"]) {
        //查找最后一条指令  lastInst

        if (self.listItemVO.lastInst.length != 0) {
            NSString *lastinst = [NSString stringWithFormat:@"%@",self.listItemVO.lastInst];
            _modelIndex = [[lastinst substringWithRange:NSMakeRange(1, 1)] integerValue ];
            _temperatureIndex =[[lastinst substringWithRange:NSMakeRange(2, 2)] integerValue ];
            _speedIndex =[[lastinst substringWithRange:NSMakeRange(4, 1)] integerValue ];
            _directionIndex =[[lastinst substringWithRange:NSMakeRange(5, 1)] integerValue ];
        }
        
    }

    
    
    _modelPicker = [ImageDataPickerViewController alertControllerWithTitle:@"模式" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    _modelPicker.tag = 1;
    _modelPicker.delegate = self;
    _modelPicker.dataArray = kModelArray;
    
    _temperaturePicker = [DataPickerViewController alertControllerWithTitle:@"温度" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    _temperaturePicker.tag = 2;
    _temperaturePicker.delegate = self;
    _temperaturePicker.dataArray = kTemperatureArray;
    
    _speedPicker = [ImageDataPickerViewController alertControllerWithTitle:@"风速" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    _speedPicker.tag = 3;
    _speedPicker.delegate = self;
    _speedPicker.dataArray = kSpeedArray;
    
    _directionPicker = [ImageDataPickerViewController alertControllerWithTitle:@"风向" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    _directionPicker.tag = 4;
    _directionPicker.delegate = self;
    _directionPicker.dataArray = kDirectionArray;
//    [self setupBackBarButton];
//    [self  setupRemoveButton];
    [self setup];
    _rightlayerView = [[RightLayerView alloc] initWithFrame:CGRectMake(ViewControllerViewWidth-160, 60, 150, 57)];
    [_rightlayerView setRadiusTopLeft:4.0 topRight:4.0 bottomLeft:4.0 bottomRight:4.0];
    _rightlayerView.delegate = self;
    
    [self.view addSubview:_rightlayerView];
    
    _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    _systemValue = _musicPlayer.volume;
    [_musicPlayer setVolume:1.0];
    [self setupDeleteButton];
    
    
}

-(void)setup
{
    
    CGFloat cy = 40;
    CGRect tableFrame = CGRectMake(0.0f, cy, ViewControllerViewWidth, ViewControllerViewHeight - INPUT_HEIGHT -NAVIGATIONBAR_PLUS_STATUSBAR_HEIGHT - cy);
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.editing = YES;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    //[_tableView setBackgroundColor:[UIColor colorForHex:@"#e5e5e5"]];
    
    
    
    [self.view addSubview:_tableView];
    
    
    //实际隐藏tabBar;
    CGRect inputFrame = CGRectMake(0.0f, ViewControllerViewHeight-INPUT_HEIGHT, ViewControllerViewWidth, INPUT_HEIGHT);
    
    _messageInputView = [[MessageInputView alloc] initWithFrame:inputFrame  withBigType:self.listItemVO withIsChat:NO];
    [self.view addSubview:_messageInputView];
    
}




#pragma mark- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIMessageObject* message = [_messageArray objectAtIndex:indexPath.row];
    float height = [ChatMessageCell neededHeightForMessage:message
                                           messageCellType:[ChatMessageCell messageCellTypeForMessage:message]
                                                 timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BubbleMessageType bubbleMessageType = [self messageTypeForRowAtIndexPath:indexPath];
    UIMessageObject* message = [_messageArray objectAtIndex:indexPath.row];
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    ChatMessageCellType bubbleViewType = [ChatMessageCell messageCellTypeForMessage:message];
    
    NSString* CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d", bubbleMessageType, hasTimestamp, bubbleViewType];
    ChatMessageCell* cell = (ChatMessageCell*)[tableView dequeueReusableCellWithIdentifier:CellID];
    if(!cell)
    {
        cell = [[ChatMessageCell alloc] initWithBubbleMessageType:bubbleMessageType
                                                     hasTimestamp:hasTimestamp
                                                   bubbleViewType:bubbleViewType
                                                         delegate:nil
                                                  reuseIdentifier:CellID];
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (hasTimestamp) {
        [cell setTimestamp:message.displayTime];
    }
    if (message) {
        [cell setMessage:message];
        if ([message.iconName rangeOfString:@"http"].location != NSNotFound) {
            UIImageView * imageview = [[UIImageView alloc]init];
            [imageview sd_setImageWithURL:[NSURL URLWithString:message.iconName] placeholderImage:nil];
            
            [cell setAvatar:(bubbleMessageType == BubbleMessageTypeOutgoing) ? _myAvatarImage : imageview.image];
        }else{
            [cell setAvatar:(bubbleMessageType == BubbleMessageTypeOutgoing) ? _myAvatarImage : _IMAGE(message.iconName)];
        }
        
    }
    cell.bubbleView.delegate = nil;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIMessageObject *m = [_messageArray objectAtIndex:indexPath.row];
    if (m && m.msgType == MessageType_Tips) {
        return NO;
    }
    
    if (m.displayTime && m.displayTime.length > 0) {
        return YES;
    }
    return NO;
}

- (BubbleMessageType )messageTypeForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIMessageObject *messageObject = [_messageArray objectAtIndex:indexPath.row];
    if(messageObject.sendOrRecv == MessageReceiveType_Send) {
        return BubbleMessageTypeOutgoing;
    }else {
        return BubbleMessageTypeIncoming;
    }
}

//懒加载
-(ChatRecordDB *)itemDB
{
    if (!_itemDB) {
        _itemDB = [[ChatRecordDB alloc]init];
        [_itemDB initManagedObjectContext];
    }
    
    return _itemDB;
}

-(ViewListItemDB *)ListDB
{
    if (!_ListDB) {
        _ListDB = [[ViewListItemDB alloc]init];
        [_ListDB initManagedObjectContext];
    }
  
    return _ListDB;

}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_rightlayerView setHidden:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchViewAction:) name:kYSShowOnOffSwitchNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showModelPicker:) name:kYSShowModelPickerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTemperaturePicker:) name:kYSShowTemperatureNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSpeedPicker:) name:kYSShowSpeedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDirectionPicker:) name:kYSShowDirectionNotification object:nil];
    
    /*
     通用面板指令
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendPustInstAction:) name:KYSShowPustInstUnivelNotification object:nil];
    


}

- (void)showModelPicker:(NSNotification *)notification{
    _modelBtn = (CustomButton *)notification.object;
    
    [self presentViewController:_modelPicker animated:YES completion:nil];
    
}

- (void)showTemperaturePicker:(NSNotification *)notification{
    _tmperatureBtn = (CustomButton *)notification.object;
    
    [self presentViewController:_temperaturePicker animated:YES completion:nil];
    
}

- (void)showSpeedPicker:(NSNotification *)notification{
    _speedBtn = (CustomButton *)notification.object;
    
    [self presentViewController:_speedPicker animated:YES completion:nil];
    
}

- (void)showDirectionPicker:(NSNotification *)notification{
    _directionBtn = (CustomButton *)notification.object;
    
    [self presentViewController:_directionPicker animated:YES completion:nil];
}

-(void)sendPustInstAction:(NSNotification *)notification
{
    _ZYCustonButton = (ZYCustomButton*)notification.object;
    if ([_ZYCustonButton.inst isEqualToString:@"timer"]) {
        //跳转到定时界面
        
        
    }else if([_ZYCustonButton.inst isEqualToString:@"meter"])
    {
        //跳转电量界面
        
        
    }else if ([_ZYCustonButton.type isEqualToString:@"url"])
    {
        //跳转到webView界面
        
        
    }else
    {
        //发送指令
        [self saveMsgAction:_ZYCustonButton.titleLabel.text withOrder:@"" withIsCome:@"1" withMsgType:MessageType_Text]; //存入数据库 发送内容
        
        [self sendMsgAction:_ZYCustonButton.inst]; //发送内容
        [self getMsgAction:nil];
        
        
    }
    
}

//删除设备
-(void)pushAboutViewController:(NSInteger)tag
{
    
    
    
}



//  开关发送命令
- (void)switchViewAction:(NSNotification *)notification{
    //空调开关 0，1
    _onoffSwitch = (SwitchView *)notification.object;
    NSString *content = @"";
    NSString *order = @"";
    NSString *isOpen = @"0";
        if (_onoffSwitch.onoffBtn.selected) {
            isOpen = @"1";
            content = [NSString stringWithFormat:@"开_%@_%@℃_%@_%@",[kModelValueArray objectAtIndex:_modelIndex],[kTemperatureValueArray objectAtIndex:_temperatureIndex],[kSpeedValueArray objectAtIndex:_speedIndex],[kDirectionValueArray objectAtIndex:_directionIndex]];
        }else{
            isOpen = @"0";
            content = [NSString stringWithFormat:@"关_%@_%@℃_%@_%@",[kModelValueArray objectAtIndex:_modelIndex],[kTemperatureValueArray objectAtIndex:_temperatureIndex],[kSpeedValueArray objectAtIndex:_speedIndex],[kDirectionValueArray objectAtIndex:_directionIndex]];
        }
        
        order = [NSString stringWithFormat:@"%@%lu%@%lu%lu",isOpen,_modelIndex,[kTemperatureKeyArray objectAtIndex:_temperatureIndex],_speedIndex,_directionIndex];
   
    //清空聊天记录
    
    [self saveMsgAction:content withOrder:order withIsCome:@"1" withMsgType:MessageType_Text]; //存入数据库\ 发送内容

    [self sendMsgAction:order]; //发送内容
    [self getMsgAction:nil]; //聊天获取信息
}

// 模式 风速 风向
#pragma mark- ImageDataPickerViewControllerDelegate
- (void)pickViewDidSelectRowData:(NSInteger)index withTag:(NSInteger)tag{
    switch (tag) {
        case 1:{
            [_modelBtn setImage:nil forState:UIControlStateNormal];
            [_modelBtn setImage:nil forState:UIControlStateSelected];
            [_modelBtn setImage:nil forState:UIControlStateHighlighted];
            [_modelBtn setTitle:nil forState:UIControlStateNormal];
            _modelIndex = index;
            NSString *value = [kModelValueArray objectAtIndex:index];
            UIImage *image = [kModelArray objectAtIndex:index];
            [_modelBtn setImage:image forState:UIControlStateNormal];
            [_modelBtn setImage:image forState:UIControlStateSelected];
            [_modelBtn setImage:image forState:UIControlStateHighlighted];
            [_modelBtn setTitle:value forState:UIControlStateNormal];
            break;
        }
        case 2:{
            
            _temperatureIndex = index;
            NSString *value = [kTemperatureValueArray objectAtIndex:_temperatureIndex];
            [_tmperatureBtn setTitle:value forState:UIControlStateNormal];
            break;
        }
        case 3:{
            [_speedBtn setImage:nil forState:UIControlStateNormal];
            [_speedBtn setImage:nil forState:UIControlStateSelected];
            [_speedBtn setImage:nil forState:UIControlStateHighlighted];
            [_speedBtn setTitle:nil forState:UIControlStateNormal];
            _speedIndex = index;
            NSString *value = [kSpeedValueArray objectAtIndex:index];
            UIImage *image = [kSpeedArray objectAtIndex:index];
            [_speedBtn setImage:image forState:UIControlStateNormal];
            [_speedBtn setImage:image forState:UIControlStateSelected];
            [_speedBtn setImage:image forState:UIControlStateHighlighted];
            [_speedBtn setTitle:value forState:UIControlStateNormal];
            break;
        }
        case 4:{
            [_directionBtn setImage:nil forState:UIControlStateNormal];
            [_directionBtn setImage:nil forState:UIControlStateSelected];
            [_directionBtn setImage:nil forState:UIControlStateHighlighted];
            [_directionBtn setTitle:nil forState:UIControlStateNormal];
            _directionIndex = index;
            NSString *value = [kDirectionValueArray objectAtIndex:index];
            UIImage *image = [kDirectionArray objectAtIndex:index];
            [_directionBtn setImage:image forState:UIControlStateNormal];
            [_directionBtn setImage:image forState:UIControlStateSelected];
            [_directionBtn setImage:image forState:UIControlStateHighlighted];
            [_directionBtn setTitle:value forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowOnOffChangeNotification object:[NSNumber numberWithInt:1]];
    NSString *content = [NSString stringWithFormat:@"开_%@_%@℃_%@_%@",[kModelValueArray objectAtIndex:_modelIndex],[kTemperatureValueArray objectAtIndex:_temperatureIndex],[kSpeedValueArray objectAtIndex:_speedIndex],[kDirectionValueArray objectAtIndex:_directionIndex]];
    NSString *order = [NSString stringWithFormat:@"1%lu%@%lu%lu",_modelIndex,[kTemperatureKeyArray objectAtIndex:_temperatureIndex],_speedIndex,_directionIndex];
    [self saveMsgAction:content withOrder:order withIsCome:@"1" withMsgType:MessageType_Text];
    
    [self sendMsgAction:order];
    [self getMsgAction:nil];
    
}

// 温度
#pragma mark- DataPickerViewControllerDelegate
- (void)pickViewDidSelectRowData:(NSInteger)selectedIndex withDataTag:(NSInteger)tag{
    _temperatureIndex = selectedIndex;
    NSString *value = [kTemperatureValueArray objectAtIndex:selectedIndex];
    value = [NSString stringWithFormat:@"%@℃",value];
    [_tmperatureBtn setTitle:value forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kYSShowOnOffChangeNotification object:[NSNumber numberWithInt:1]];
    NSString *content = [NSString stringWithFormat:@"开_%@_%@℃_%@_%@",[kModelValueArray objectAtIndex:_modelIndex],[kTemperatureValueArray objectAtIndex:_temperatureIndex],[kSpeedValueArray objectAtIndex:_speedIndex],[kDirectionValueArray objectAtIndex:_directionIndex]];
    NSString *order = [NSString stringWithFormat:@"1%lu%@%lu%lu",_modelIndex,[kTemperatureKeyArray objectAtIndex:_temperatureIndex],_speedIndex,_directionIndex];
    [self saveMsgAction:content withOrder:order withIsCome:@"1" withMsgType:MessageType_Text];
    
    [self sendMsgAction:order];
    [self getMsgAction:nil];
}

- (void)saveMsgAction:(NSString *)content withOrder:(NSString *)order withIsCome:(NSString *)isCome withMsgType:(NSInteger)msgtype{
   //清除上次对话
    if ([isCome isEqualToString:@"1"]) {
         [self delRecordAction];
    }
    
    
    NSString *time = [CommonUtils formatDate:@"yyyy-MM-dd HH:mm:ss" date:[NSDate date]];
    ChatRecordItemVO *vo = [[ChatRecordItemVO alloc]init];
    vo.uid = [NSNumber numberWithLongLong:[self.listItemVO.idID longLongValue]];
    vo.friendId = @"";
    vo.msgType  = [NSString stringWithFormat:@"%zd",msgtype];
    vo.msgTime = time;
    vo.mineMsg = @"";
    vo.friendMsg = content;
    vo.isComeMsg = isCome;
    vo.nativePath = @"";
    vo.saveTime = time;
    vo.voiceTime = time;
    vo.devTypeID = @"";
    vo.time = [NSDate date];
    vo.order = order;
    vo.bigType = self.listItemVO.bigType;
    vo.devType = self.listItemVO.devType;
    [self.itemDB setMsgAction:vo];
    
}

- (void)getMsgAction:(id)sender{
    
   
    [_messageArray removeAllObjects];
    
    NSString *friendId = @"";
    
    NSArray *chatArray = [self.itemDB getMsgAction:[NSNumber numberWithLongLong:[ self.listItemVO.idID longLongValue] ]withFriendId:friendId];
    
    for (ChatRecordItemVO *item in chatArray) {
        
        UIMessageObject *m = [[UIMessageObject alloc]init] ;
        m.content = item.friendMsg;
        m.time = time(0);
        m.devTypeID = item.devTypeID;
        m.msgType = item.msgType.integerValue;
        m.msgStatus = MessageStatus_Sending;
        m.displayTime = [CommonUtils formatDate:@"yyyy-MM-dd HH:mm:ss" date:item.time];
        if ([item.isComeMsg isEqualToString:@"1"]) {
            m.sendOrRecv = MessageReceiveType_Send;
            
            UIImage *image =_IMAGE(@"default_avatar");
            _myAvatarImage = image;
            
            
        }else{
            m.sendOrRecv = MessageReceiveType_Receive;
            
            m.iconName = @"control_blue";
            
        }
        
        m.chat_id = time(0);
        [_messageArray addObject:m];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
         [_tableView reloadData];
    });
       
}
- (void)sendMsgAction:(NSString *)content
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"IDA0" forKey:@"CMD"];
    [params setValue:Token forKey:@"TOKEN"];
    [params setValue:self.listItemVO.idID forKey:@"typeID"];
    [params setValue:content forKey:@"inst"];
    [params setValue:@"100" forKey:@"actionID"];
    [ZYHttpTool postWithURL:DevidUrl params:params success:^(id json) {
    
        
       NSString *param = [NSString stringWithFormat:@"%@", [[[json objectForKey:@"param"] firstObject] objectForKey:@"param"]];
        if (param != nil  ) {
            //返回
            
           [self saveArrayWith:param];
        }

        
    } failure:^(NSError *error) {
       
    }];
    
    if ([self.listItemVO.bigType isEqualToString:@"KGHW"]) {
        
        self.listItemVO.lastInst = content;
        [self.ListDB updateDeviceAction:self.listItemVO];
        
        
    }
    

}

//生成音频文件
- (void)makeWaveAction:(NSString *)pwd{
    
    NSString *name = [NSString stringWithFormat:@"infrad.wav"];
    const char *pConstChar =  [pwd UTF8String];
   
    NSString *tmpPath = [self getFilepath:name];
    
    const char *pathChar =  [tmpPath UTF8String];
    
    WaveGenerator wg(pConstChar,20000);//修改频率
    std::vector<uint8_t> wavVec;
    FILE *fp = NULL;
    wavVec.clear();
    wavVec = wg.getWaveData();
    
    fp = fopen(pathChar, "wb+");
   
    if (fp == NULL) {
        printf("fopen error.\n");
        return;
    }
    
    for(vector<uint8_t> :: iterator iter = wavVec.begin();iter != wavVec.end(); iter++){
        uint8_t data = *iter;
        fwrite(&data, 1, 1, fp);
    }
    fflush(fp);
    fclose(fp);
     sleep(2);
    
    if(tmpPath)
    {
        
      
        NSURL *fileUrl = [NSURL fileURLWithPath:tmpPath];
        for(int i=0;i<2;i++){
            [self play:fileUrl];
            NSLog(@"++++++++++++++++++++++");
            sleep(1.2);
        }
        
         [self saveMsgAction:@"红外指令已发送" withOrder:@"" withIsCome:@"0" withMsgType:MessageType_Text];
        [self getMsgAction:nil];
    
    }
    
    
    

    
    
}




- (NSString *)getFilepath:(NSString *)name{
    //获取路径
    //二进制文件名称
    NSString *myDirectory = [self diskPath];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
    [fileManage changeCurrentDirectoryPath:myDirectory];
    NSString *wavpath = [myDirectory stringByAppendingPathComponent:name];
    
    return wavpath;
}
/*!
 生成路径
 */
- (NSString *)diskPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"/audio"];
    return myDirectory;
}


- (void)play:(NSURL *)url{
    //播放开始后，loading，等待服务端通知
    if ([self isHeadsetPluggedIn]) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            _player = [_player initWithContentsOfURL:url error:nil];
            _player.volume = 1.0f;
            
            [_player play];
        });
    }
    
}
//判断是否有耳机插入
- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)delRecordAction{
    //    removeMsgAction
    
    ChatRecordDB *db = [[ChatRecordDB alloc] init];
    [db initManagedObjectContext];
    [db removeMsgAction:[NSNumber numberWithLongLong:[self.listItemVO.idID longLongValue]] withFriendId:@""];
}

-(void)saveArrayWith:(NSString *)str
{
    NSString *haedstr = [str substringToIndex:2];
    NSString *langStr = [str substringFromIndex:2];
    int StrCount = (int)(langStr.length/4);
    NSMutableArray *strArray = [NSMutableArray array];
    for ( int i = 0; i < StrCount; i++) {
        
        NSString *arrstr = [langStr substringToIndex:4];
        
        langStr = [langStr substringFromIndex:4];
       
        [strArray addObject:arrstr];
        
    }
   
    NSMutableArray *FFary = [NSMutableArray array];
    
    for (NSString *str in strArray) {
        
        NSMutableString *str1 = [[NSMutableString alloc]initWithString:[str substringFromIndex:2]];
        
        NSString *str2  = [str substringToIndex:2];
       
        [str1 insertString:str2 atIndex:2] ;
        
        [FFary addObject:str1];
        
    }
    NSString *paramStr = [NSString stringWithFormat:@"%@%@",haedstr,[FFary componentsJoinedByString:@""]];
    
    [self makeWaveAction:paramStr];
    

}





-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [_musicPlayer setVolume:_systemValue];


}

- (void)setupDeleteButton
{
    UIImage *backNormalImage = [UIImage imageNamed:@"dele"];
    UIImage *backSelectedImage = [UIImage imageNamed:@"dele"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(-10, 0, backNormalImage.size.width, backNormalImage.size.height);
    [leftButton setImage:backNormalImage forState:UIControlStateNormal];
    [leftButton setImage:backSelectedImage forState:UIControlStateHighlighted];
    [leftButton setImage:backSelectedImage forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(DeleteDived) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItems = @[leftItem];
}

-(void)DeleteDived
{
    [self.ListDB removeDeviceByAction:self.listItemVO.idID];
    [self.navigationController popViewControllerAnimated:YES];
}









@end
