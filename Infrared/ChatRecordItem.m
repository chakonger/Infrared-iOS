//
//  ChatRecordItem.m
//  Control
//
//  Created by kucababy on 15/2/28.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import "ChatRecordItem.h"
#import "CommonUtils.h"
#import "AppDelegate.h"


@implementation ChatRecordItem

@dynamic uid;
@dynamic friendId;
@dynamic msgType;
@dynamic msgTime;
@dynamic mineMsg;
@dynamic friendMsg;
@dynamic isComeMsg;
@dynamic nativePath;
@dynamic saveTime;
@dynamic voiceTime;
@dynamic time;
@dynamic order;
@dynamic bigType;
@dynamic devType;
@dynamic devName;
@dynamic iconName;
@dynamic devTypeID;

@end

@implementation ChatRecordItemVO

@synthesize uid;
@synthesize friendId;
@synthesize msgType;
@synthesize msgTime;
@synthesize mineMsg;
@synthesize friendMsg;
@synthesize isComeMsg;
@synthesize nativePath;
@synthesize saveTime;
@synthesize voiceTime;
@synthesize time;
@synthesize order;
@synthesize bigType;
@synthesize devType;
@synthesize devName;
@synthesize iconName;
@synthesize devTypeID;

@end

@implementation ChatRecordDB

- (void )initManagedObjectContext
{
    while(TRUE){
        //////////////////////////////////////////////////////////////////////////////////////
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Infrared" withExtension:@"momd"];
        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        if(managedObjectModel ==Nil){
            sleep(1);continue;
        }
        
        AppDelegate *appdelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
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

- (void)setMsgAction:(ChatRecordItemVO *)vo{
    NSError *error;
    ChatRecordItem *msgItem = [NSEntityDescription insertNewObjectForEntityForName:@"ChatRecordItem" inManagedObjectContext:self.managedObjectContext];
    msgItem.uid = vo.uid;
    msgItem.friendId = vo.friendId;
    msgItem.msgType = vo.msgType;
    msgItem.msgTime = vo.msgTime;
    msgItem.mineMsg = vo.mineMsg;
    msgItem.friendMsg = vo.friendMsg;
    msgItem.isComeMsg = vo.isComeMsg;
    msgItem.nativePath = vo.nativePath;
    msgItem.saveTime = vo.saveTime;
    msgItem.voiceTime = vo.voiceTime;
    msgItem.order = vo.order;
    msgItem.time = vo.time;
    msgItem.bigType = vo.bigType;
    msgItem.devType = vo.devType;
    msgItem.devName = vo.devName;
    msgItem.iconName = vo.iconName;
    msgItem.devTypeID = vo.devTypeID;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
}

- (NSString *)getLastOrderAction:(NSNumber *)uid withFriendId:(NSString *)friendId withIsCome:(NSString *)isCome{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entiry = [NSEntityDescription entityForName:@"ChatRecordItem" inManagedObjectContext:self.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" uid = %@ and friendId = %@ and isComeMsg= %@ ",uid,friendId,isCome];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entiry];
    NSError *error;
    NSArray *msgArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    ChatRecordItemVO *msgItem = nil;
    if ([msgArray count]>0) {
        ChatRecordItem *item = [msgArray objectAtIndex:0];
        msgItem = [[ChatRecordItemVO alloc] init];
        msgItem.uid = item.uid;
        msgItem.friendId = item.friendId;
        msgItem.msgType = item.msgType;
        msgItem.msgTime = item.msgTime;
        msgItem.mineMsg = item.mineMsg;
        msgItem.friendMsg = item.friendMsg;
        msgItem.isComeMsg = item.isComeMsg;
        msgItem.nativePath = item.nativePath;
        msgItem.saveTime = item.saveTime;
        msgItem.voiceTime = item.voiceTime;
        msgItem.order = item.order;
        msgItem.time = item.time;
        msgItem.bigType = item.bigType;
        msgItem.devType = item.devType;
        msgItem.devName = item.devName;
        msgItem.iconName = item.iconName;
        msgItem.devTypeID = item.devTypeID;
    }
    return msgItem.order;
}

- (NSMutableArray *)getMsgAction:(NSNumber *)uid withFriendId:(NSString *)friendId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entiry = [NSEntityDescription entityForName:@"ChatRecordItem" inManagedObjectContext:self.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" uid = %@ and friendId = %@ ",uid,friendId];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"_PK" ascending:YES];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entiry];
    //[fetchRequest setFetchLimit:20];//只显示最近的20条
    NSError *error;
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *msgArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (ChatRecordItem *item in msgArray) {
        ChatRecordItemVO *msgItem = [[ChatRecordItemVO alloc] init];
        msgItem.uid = item.uid;
        msgItem.friendId = item.friendId;
        msgItem.msgType = item.msgType;
        msgItem.msgTime = item.msgTime;
        msgItem.mineMsg = item.mineMsg;
        msgItem.friendMsg = item.friendMsg;
        msgItem.isComeMsg = item.isComeMsg;
        msgItem.nativePath = item.nativePath;
        msgItem.saveTime = item.saveTime;
        msgItem.voiceTime = item.voiceTime;
        msgItem.order = item.order;
        msgItem.time = item.time;
        msgItem.bigType = item.bigType;
        msgItem.devType = item.devType;
        msgItem.devName = item.devName;
        msgItem.iconName = item.iconName;
        msgItem.devTypeID = item.devTypeID;
        [resultArray addObject:msgItem];
    }
    return resultArray;
}

- (void)removeMsgAction:(NSNumber *)uid withFriendId:(NSString *)friendId{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatRecordItem" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" uid = %@ and friendId = %@ ",uid,friendId];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjectsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (ChatRecordItem *chatRecordItem in fetchedObjectsArray) {
        [self.managedObjectContext deleteObject:chatRecordItem];
    }
    if (![self.managedObjectContext save:&error])
        NSLog(@"Error: %@", [error localizedDescription]);
}


@end