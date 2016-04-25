//
//  ViewListItem.m
//  Infrared
//
//  Created by ToTank on 16/2/25.
//  Copyright © 2016年 史志勇. All rights reserved.
//

#import "ViewListItem.h"
#import "AppDelegate.h"

@implementation ViewListItem

@dynamic bigType;

@dynamic brand;

@dynamic idID;


@dynamic devType;

@dynamic typeName;

@dynamic lastInst;

@end

@implementation ViewListItemVO

@synthesize bigType;

@synthesize brand;
@synthesize idID;

@synthesize devType;
@synthesize typeName;
@synthesize lastInst;

@end

@implementation ViewListItemDB

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

- (void)saveDeviceAction:(ViewListItemVO *)vo{
    NSError *error;
     ViewListItem *deviceItem = [NSEntityDescription insertNewObjectForEntityForName:@"ViewListItem" inManagedObjectContext:self.managedObjectContext];
    
        deviceItem.brand = [[NSNull null] isEqual:vo.brand]?@"":vo.brand;
    
        deviceItem.bigType = [[NSNull null] isEqual:vo.bigType]?@"":vo.bigType;
        deviceItem.brand = vo.brand;
        deviceItem.idID = vo.idID;
        deviceItem.lastInst = [[NSNull null] isEqual:vo.lastInst]?@"":vo.lastInst;
    
        deviceItem.devType = vo.devType;
        deviceItem.typeName = vo.typeName;
   
    if (![self.managedObjectContext save:&error]) {
        //  NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
}

- (NSMutableArray *)getAllDeviceAction
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entiry = [NSEntityDescription entityForName:@"ViewListItem" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"idID" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entiry];
    NSError *error;
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *msgArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (ViewListItem *item in msgArray) {
        ViewListItemVO *deviceItem = [[ViewListItemVO alloc] init];
        deviceItem.devType = item.devType;
        deviceItem.brand = item.brand;
        
        deviceItem.bigType = item.bigType;
        deviceItem.brand = item.brand;
        deviceItem.idID = item.idID;
        deviceItem.lastInst = item.lastInst;
        deviceItem.typeName = item.typeName;
        [resultArray addObject:deviceItem];
    }
    return resultArray;
    
}
- (void)removeDeviceByAction:(NSString *)ID
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ViewListItem" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" idID = %@ ",ID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjectsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (ViewListItem *deviceItem in fetchedObjectsArray) {
        [self.managedObjectContext deleteObject:deviceItem];
    }
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error: %@", [error localizedDescription]);
}

/*!
 获取设备名称信息
 */
- (ViewListItemVO *)getDeviceAction:(NSString *)ID
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entiry = [NSEntityDescription entityForName:@"ViewListItem" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" idID =%@ ",ID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entiry];
    NSError *error;
    NSArray *msgArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    ViewListItemVO *deviceItem = nil;
    if ([msgArray count]>0) {
        ViewListItem *vo = [msgArray objectAtIndex:0];
        deviceItem.devType = vo.devType;
        deviceItem.bigType = vo.bigType;
        deviceItem.brand = vo.brand;
        deviceItem.typeName = vo.typeName;
        deviceItem.lastInst = vo.lastInst;
    }
    return deviceItem;
    
}





-(void)removeAllDeviceAction
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ViewListItem" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjectsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (ViewListItem *deviceItem in fetchedObjectsArray) {
        [self.managedObjectContext deleteObject:deviceItem];
    }
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error: %@", [error localizedDescription]);
}


-(void)updateDeviceAction:(ViewListItemVO *)vo
{

    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"ViewListItem" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" idID = %@  ",vo.idID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSError * requestError = nil;
    NSArray * deviceArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    if ([deviceArray count] > 0) {
        ViewListItem * deviceItem = [deviceArray lastObject];
        // 更新数据
        deviceItem.devType = vo.devType;
        deviceItem.bigType = vo.bigType;
        deviceItem.brand = vo.brand;
        deviceItem.typeName = vo.typeName;
        deviceItem.lastInst = vo.lastInst;
        NSError * savingError = nil;
        if ([self.managedObjectContext save:&savingError]) {
            //  NSLog(@"successfully saved the context");
        }else {
            // NSLog(@"failed to save the context error = %@", savingError);
        }
    }else {
        // NSLog(@"could not find any person entity in the context");
    }
}



@end
