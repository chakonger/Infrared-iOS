//
//  DeviceItem.h
//  Infrared
//
//  Created by ToTank on 16/2/24.
//  Copyright © 2016年 史志勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DeviceItem : NSManagedObject

@property (nonatomic, retain) NSString * bigType;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * xHBG;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * fixTypeID;
@property (nonatomic, retain) NSString * idID;
@property (nonatomic, retain) NSString * visible;
@property (nonatomic, retain) NSString * trans2eLevel;
@property (nonatomic, retain) NSString * devTypeID;
@property (nonatomic, retain) NSString * panelType;
@property (nonatomic, retain) NSString * sorting;
@property (nonatomic, retain) NSString * devType;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * typeName;

@end

@interface DeviceItemVO : NSObject

@property (nonatomic, retain) NSString * bigType;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * XHBG;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * fixTypeID;
@property (nonatomic, retain) NSString * idID;
@property (nonatomic, retain) NSString * visible;
@property (nonatomic, retain) NSString * trans2eLevel;
@property (nonatomic, retain) NSString * devTypeID;
@property (nonatomic, retain) NSString * panelType;
@property (nonatomic, retain) NSString * sorting;
@property (nonatomic, retain) NSString * devType;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * typeName;


@end


@interface DeviceItemDB : NSObject
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void )initManagedObjectContext;

/*!
 保存数据到本地
 @property  vo
 */
- (void)saveDeviceAction:(NSArray *)deviceArray;

/*!
 获取本地缓存数据
 */
- (NSMutableArray *)getAllDeviceAction;

/*!
 获取设备名称信息
 */
- (DeviceItemVO *)getDeviceAction:(NSString *)ID;

/*!
 移除本地数据
 */
- (void)removeAllDeviceAction;

///*!
// 移除特地的一条记录
// */
//- (void)removeDeviceByAction:(NSString *)ID;
///*!
// 修改本地数据
// @property  vo
// */
//- (void)updateDeviceAction:(DeviceItemVO *)vo;
//
@end
