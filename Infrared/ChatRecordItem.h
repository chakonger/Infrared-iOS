//
//  ChatRecordItem.h
//  Control
//
//  Created by kucababy on 15/2/28.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChatRecordItem : NSManagedObject

@property (nonatomic, retain) NSNumber * uid;           //登录者本人的ID
@property (nonatomic, retain) NSString * friendId;      //好友的ID
@property (nonatomic, retain) NSString * msgType;       //消息类型0文本，1语音，2图片，3emoji
@property (nonatomic, retain) NSString * msgTime;       //发送消息的时间
@property (nonatomic, retain) NSString * mineMsg;       //我的消息
@property (nonatomic, retain) NSString * friendMsg;     //朋友发的消息
@property (nonatomic, retain) NSString * isComeMsg;     //是否是朋友的消息0我的消息，1朋友发的消息
@property (nonatomic, retain) NSString * nativePath;    //语音或图片的本地路径
@property (nonatomic, retain) NSString * saveTime;      //
@property (nonatomic, retain) NSString * voiceTime;     //
@property (nonatomic, retain) NSDate   * time;          //时间
@property (nonatomic, retain) NSString * order;         //发送命令
@property (nonatomic, retain) NSString * bigType;       //大类型
@property (nonatomic, retain) NSString * devType;       //设备类型
@property (nonatomic, retain) NSString * devName;       //设备名称
@property (nonatomic, retain) NSString * devTypeID;  //设备ID
@property (nonatomic, retain) NSString * iconName;     //设备图片;
@end

@interface ChatRecordItemVO : NSObject

@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * friendId;
@property (nonatomic, retain) NSString * msgType;
@property (nonatomic, retain) NSString * msgTime;
@property (nonatomic, retain) NSString * mineMsg;
@property (nonatomic, retain) NSString * friendMsg;
@property (nonatomic, retain) NSString * isComeMsg;
@property (nonatomic, retain) NSString * nativePath;
@property (nonatomic, retain) NSString * saveTime;
@property (nonatomic, retain) NSString * voiceTime;
@property (nonatomic, retain) NSDate   * time;
@property (nonatomic, retain) NSString * order;
@property (nonatomic, retain) NSString * bigType;       //大类型
@property (nonatomic, retain) NSString * devType;       //设备类型
@property (nonatomic, retain) NSString * devName;     //设备名称
@property (nonatomic, retain) NSString * iconName;   //设备图片
@property (nonatomic, retain) NSString * devTypeID;  //设备ID

@end

@interface ChatRecordDB : NSObject

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void )initManagedObjectContext;

/*!
 添加消息内容到数据库
 */
- (void)setMsgAction:(ChatRecordItemVO *)vo;

/*!
 获取发送的最后一条命令
 */
- (NSString *)getLastOrderAction:(NSNumber *)uid withFriendId:(NSString *)friendId withIsCome:(NSString *)isCome;

/*!
 获取消息内容
 */
- (NSMutableArray *)getMsgAction:(NSNumber *)uid withFriendId:(NSString *)friendId;

/*!
 删除消息
 */
- (void)removeMsgAction:(NSNumber *)uid withFriendId:(NSString *)friendId;



@end
