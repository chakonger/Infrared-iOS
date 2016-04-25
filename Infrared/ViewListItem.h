//
//  ViewListItem.h
//  Infrared
//
//  Created by ToTank on 16/2/25.
//  Copyright © 2016年 史志勇. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ViewListItem : NSManagedObject

@property (nonatomic, retain) NSString * devType;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSString * bigType;
@property (nonatomic, retain) NSString * idID;
@property (nonatomic, retain) NSString * lastInst;

@end

@interface ViewListItemVO : NSObject

@property (nonatomic, retain) NSString * devType;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSString * bigType;
@property (nonatomic, retain) NSString * idID;
@property (nonatomic, retain) NSString * lastInst;

@end

@interface ViewListItemDB : NSObject
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void )initManagedObjectContext;

/*!
 保存数据到本地
 @property  vo
 */
- (void)saveDeviceAction:(ViewListItemVO *)vo;

/*!
 获取本地缓存数据
 */
- (NSMutableArray *)getAllDeviceAction;

/*!
 获取设备名称信息
 */
- (ViewListItemVO *)getDeviceAction:(NSString *)ID;

/*!
 移除本地数据
 */
- (void)removeAllDeviceAction;

/*!
 移除特地的一条记录
 */
- (void)removeDeviceByAction:(NSString *)ID;
/*!
 修改本地数据
 @property  vo
 */
- (void)updateDeviceAction:(ViewListItemVO *)vo;

@end;
