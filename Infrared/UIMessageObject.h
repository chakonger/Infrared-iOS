//
//  UIMessageObject.h
//  WeiMi
//
//  Created by hwb on 14-6-30.
//
//

#import <Foundation/Foundation.h>
#import "messageKit.h"



@interface UIMessageObject : NSObject

@property (nonatomic, strong) NSString *content;//文字消息内容
@property (nonatomic, assign) int read;//已读状态
@property (nonatomic, assign) long time;//收发时间（秒）
@property (nonatomic, assign) MessageType msgType;//@{MessageType}文字、图片.....
@property (nonatomic, assign) MessageStatus msgStatus;//@{MessageStatus}消息（UI气泡）状态
@property (nonatomic, assign) MessageReceiveType sendOrRecv;//@{MessageReceiveType}接收or发送

@property (nonatomic, strong) NSString *thumbImgPath;//本地缩略图存放路径
@property (nonatomic, strong) NSString *bigImgPath;//本地原图存放路径
@property (nonatomic, strong) NSString *bigImgURL;//原图服务器URL地址
@property (nonatomic, strong) NSString* thumbimg_url; //缩略图的url

@property (nonatomic, strong) NSString *displayTime;//显示时间

@property (nonatomic, assign) long chat_id; //唯一标识某一条聊天

@property (nonatomic, strong) NSString* str_display_for_notify;

@property (nonatomic, strong) NSString *iconName;

@property (nonatomic, strong)NSString *devTypeID;

@end
