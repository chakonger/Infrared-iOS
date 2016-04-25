//
//  DeviceItem.m
//  Infrared
//
//  Created by ToTank on 16/2/24.
//  Copyright © 2016年 史志勇. All rights reserved.
//

#import "DeviceItem.h"
#import "AppDelegate.h"

@implementation DeviceItem

@dynamic bigType;
@dynamic model;
@dynamic xHBG;
@dynamic brand;
@dynamic fixTypeID;
@dynamic idID;
@dynamic visible;
@dynamic trans2eLevel;
@dynamic devTypeID;
@dynamic panelType;
@dynamic sorting;
@dynamic devType;
@dynamic status;
@dynamic typeName;
@end

@implementation DeviceItemVO

@synthesize bigType;
@synthesize model;
@synthesize XHBG;
@synthesize brand;
@synthesize fixTypeID;
@synthesize idID;
@synthesize visible;
@synthesize trans2eLevel;
@synthesize devTypeID;
@synthesize panelType;
@synthesize sorting;
@synthesize devType;
@synthesize status;
@synthesize typeName;

@end
@implementation DeviceItemDB

- (void )initManagedObjectContext
{
    while(TRUE){
        //////////////////////////////////////////////////////////////////////////////////////
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Infrared" withExtension:@"momd"];
        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        if(managedObjectModel ==Nil){
            sleep(1);continue;
        }
        AppDelegate *appdelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSURL *storeURL = [[appdelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"Infrared.sqlite"];
        
        NSError *error = nil;
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        if(persistentStoreCoordinator == Nil){
            sleep(1);continue;
        }
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            //   NSLog(@"NewsItemDB initManageObjectContext error=%@",error);
            sleep(1);continue;
        }
        ////////////////////////////////////////////////////////////////////////////////////////
        
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
        if (self.managedObjectContext != nil) {
            return ;
        }
        sleep(1);
    }
}

- (void)saveDeviceAction:(NSArray *)deviceArray{
    NSError *error;
    for (DeviceItemVO *vo in deviceArray) {
        DeviceItem *deviceItem = [NSEntityDescription insertNewObjectForEntityForName:@"DeviceItem" inManagedObjectContext:self.managedObjectContext];
        deviceItem.model = vo.model;
        deviceItem.xHBG = vo.XHBG;
        deviceItem.brand = [[NSNull null] isEqual:vo.brand]?@"":vo.brand;
        deviceItem.fixTypeID = vo.fixTypeID;
        deviceItem.bigType = [[NSNull null] isEqual:vo.bigType]?@"":vo.bigType;
        deviceItem.brand = vo.brand;
        deviceItem.idID = vo.idID;
        deviceItem.visible = vo.visible;
        deviceItem.devTypeID = vo.devTypeID;
        deviceItem.panelType = vo.panelType;
        deviceItem.sorting = vo.sorting;
        deviceItem.devType = vo.devType;
        deviceItem.status = vo.status;
        deviceItem.typeName = vo.typeName;
    }
    if (![self.managedObjectContext save:&error]) {
        //  NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
}

/*!
 获取本地缓存数据
 */
- (NSMutableArray *)getAllDeviceAction
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entiry = [NSEntityDescription entityForName:@"DeviceItem" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"idID" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entiry];
    NSError *error;
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *msgArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (DeviceItem *item in msgArray) {
        DeviceItemVO *deviceItem = [[DeviceItemVO alloc] init];
        deviceItem.devType = item.devType;
        deviceItem.model = item.model;
        deviceItem.XHBG = item.xHBG;
        deviceItem.brand = item.brand;
        deviceItem.fixTypeID = item.fixTypeID;
        deviceItem.bigType = item.bigType;
        deviceItem.brand = item.brand;
        deviceItem.idID = item.idID;
        deviceItem.visible = item.visible;
        deviceItem.devTypeID = item.devTypeID;
        deviceItem.panelType = item.panelType;
        deviceItem.sorting = item.sorting;
        deviceItem.status = item.status;
        deviceItem.typeName = item.typeName;
        [resultArray addObject:deviceItem];
    }
    return resultArray;

}

/*!
 获取设备名称信息
 */
- (DeviceItemVO *)getDeviceAction:(NSString *)ID
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entiry = [NSEntityDescription entityForName:@"DeviceItem" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" idID =%@ ",ID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entiry];
    NSError *error;
    NSArray *msgArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    DeviceItemVO *deviceItem = nil;
    if ([msgArray count]>0) {
        DeviceItem *item = [msgArray objectAtIndex:0];
        deviceItem.devType = item.devType;
        deviceItem.model = item.model;
        deviceItem.XHBG = item.xHBG;
        deviceItem.brand = item.brand;
        deviceItem.fixTypeID = item.fixTypeID;
        deviceItem.bigType = item.bigType;
        deviceItem.brand = item.brand;
        deviceItem.idID = item.idID;
        deviceItem.visible = item.visible;
        deviceItem.devTypeID = item.devTypeID;
        deviceItem.panelType = item.panelType;
        deviceItem.sorting = item.sorting;
        deviceItem.status = item.status;
        deviceItem.typeName = item.typeName;
    }
    return deviceItem;

}
- (void)removeAllDeviceAction{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceItem" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjectsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (DeviceItem *deviceItem in fetchedObjectsArray) {
        [self.managedObjectContext deleteObject:deviceItem];
    }
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error: %@", [error localizedDescription]);
}









@end

