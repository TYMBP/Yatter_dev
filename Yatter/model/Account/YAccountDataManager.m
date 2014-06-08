//
//  YAccountDataManager.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountDataManager.h"
#import "YAccountData.h"

@implementation YAccountDataManager {
  YAccountData *dataObject;
}

static YAccountDataManager *sharedInstance = nil;

+ (YAccountDataManager *)sharedManager {
  @synchronized(self) {
    if (sharedInstance == nil) {
      sharedInstance = [[self alloc] init];
    }
  }
  return sharedInstance;
}

- (id)init {
  self = [super init];
  if (self) {
    LOG_METHOD;
    [self loadManagedObjectContext];
  }
  return self;
}

- (void)loadManagedObjectContext {
  LOG_METHOD;
  if (_context != nil)
    return;
  NSPersistentStoreCoordinator *aCoodinator = [self coodinator];
  if (aCoodinator != nil) {
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:aCoodinator];
  }
}

- (NSPersistentStoreCoordinator *)coodinator {
  LOG_METHOD;
  if (_coordinator != nil) {
    return _coordinator;
  }
  NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  _storeURL = [NSURL fileURLWithPath:[directory stringByAppendingPathComponent:@"YAccountData.sqlite"]];
  LOG(@"storeURL:%@", _storeURL);
  NSError *error = nil;
  _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
  if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:_storeURL options:nil error:&error]) {
    LOG(@"Unresolved error %@ %@", error, [error userInfo]);
    abort();
  }
  return _coordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
  LOG_METHOD;
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"YAccountData" ofType:@"momd"];
  NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  return _managedObjectModel;
}

- (void)addData:(NSDictionary *)dic {
  LOG_METHOD;
  LOG(@"dic:%@", dic);
  int i = [self countEntityData];
  LOG(@"i = %d", i);
  if (i != 0) {
    [self deleteData];
  }
  NSString *user;
  NSString *summary;
  NSString *icon;
  NSNumber *userID;
  //モデルをグローバル変数に変更テスト
    dataObject = (YAccountData *)[NSEntityDescription insertNewObjectForEntityForName:@"AccountData" inManagedObjectContext:_context];
  if (dataObject == nil) {
  return;
  }
  for (NSDictionary *obj in dic) {
    NSString *castID = [obj objectForKey:@"id"];
    int i = [castID intValue];
    userID = [NSNumber numberWithInt:i];
    //userID = [obj objectForKey:@"id"];
    user = [obj objectForKey:@"user_name"];
    summary = [obj objectForKey:@"user_summary"];
    icon = [obj objectForKey:@"icon_image"];
    LOG(@"userID:%@", userID);
    LOG(@"username:%@", user);
    LOG(@"summary:%@", summary);
    LOG(@"icon:%@", icon);
  }
  [dataObject setValue:userID forKey:@"accountID"];
  [dataObject  setValue:user forKey:@"accountName"];
  [dataObject setValue:summary forKey:@"accountSummary"];
  if ([icon isEqual:[NSNull null]]) {
    LOG(@"icon:null");
    icon = @"default";
    [dataObject setValue:icon forKey:@"accountIcon"];
  } else if ([icon isEqualToString:@""]) {
    LOG(@"icon:空");
    icon = @"default";
    [dataObject setValue:icon forKey:@"accountIcon"];
  } else {
    LOG(@"else");
    [dataObject setValue:icon forKey:@"accountIcon"];
  }
  NSError *error = nil;
  if (![_context save:&error]) {
    LOG(@"error = %@", error);
  } else {
    LOG(@"Insert Completed");
  }
  LOG(@"dataObject %@", dataObject);
}

//　クローズ様子みて削除 0920
//- (void)addData {
//  LOG_METHOD;
//  YAccountData *aDataObject = (YAccountData *)[NSEntityDescription insertNewObjectForEntityForName:@"AccountData" inManagedObjectContext:_context];
//  if (aDataObject == nil) {
//    return;
//  }
//  [aDataObject setValue:@"test" forKey:@"accountName"];
//  [aDataObject setValue:@"test" forKey:@"accountSummary"];
//  
//  NSError *error = nil;
//  if (![_context save:&error]) {
//    LOG(@"error = %@", error);
//  } else {
//    LOG(@"Insert Completed");
//  }
//}

- (void)updateData:(NSDictionary *)dic {
  LOG_METHOD;
  LOG(@"dic:%@", dic);

  NSString *user;
  NSString *summary;
//  NSString *icon;
  NSNumber *userID;
  
//  YAccountData *aDataObject = (YAccountData *)[NSEntityDescription insertNewObjectForEntityForName:@"AccountData" inManagedObjectContext:_context];
  
  if (dataObject == nil) {
    return;
  }
  for (NSDictionary *obj in dic) {
    NSString *castID = [obj objectForKey:@"id"];
    int i = [castID intValue];
    userID = [NSNumber numberWithInt:i];
    user = [obj objectForKey:@"user_name"];
    summary = [obj objectForKey:@"user_summary"];
    LOG(@"userID:%@", userID);
    LOG(@"username:%@", user);
    LOG(@"summary:%@", summary);
  }
  [dataObject setValue:userID forKey:@"accountID"];
  [dataObject setValue:user forKey:@"accountName"];
  [dataObject setValue:summary forKey:@"accountSummary"];
//  if ([icon isEqual:[NSNull null]]) {
//    LOG(@"icon:null");
//    icon = @"default";
//    [aDataObject setValue:icon forKey:@"accountIcon"];
//  } else {
//    LOG(@"else");
//    [aDataObject setValue:icon forKey:@"accountIcon"];
//  }
  NSError *error = nil;
  if (![_context save:&error]) {
    LOG(@"error = %@", error);
  } else {
    LOG(@"Insert Completed");
  }
  LOG(@"DataObject %@", dataObject);
}

- (int)countEntityData {
  LOG_METHOD;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"AccountData" inManagedObjectContext:_context];
  [fetchRequest setEntity:entityDescription];
  
  NSError *error = nil;
  int count = [_context countForFetchRequest:fetchRequest error:&error];
  if (error) {
    LOG(@"error occurred.error = %@", error);
  }
  return count;
}

- (void)deleteData {
  LOG_METHOD;
  //if (![NSThread isMainThread]) {
  //  LOG_METHOD;
    NSPersistentStore *st = [_coordinator persistentStoreForURL:_storeURL];
    BOOL ret;
    NSError *error;
    error = nil;
    ret = [_coordinator removePersistentStore:st error:&error];
    if (ret == NO) {
      LOG(@"Unresolved error %@ %@", error, [error userInfo]);
    }
    error = nil;
    ret = [[NSFileManager defaultManager] removeItemAtURL:_storeURL error:&error];
    if (ret == NO) {
      LOG(@"Unresolved error %@ %@", error, [error userInfo]);
    }
    if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:_storeURL options:nil error:&error]) {
      LOG(@"Unresolved error %@ %@", error, [error userInfo]);
      abort();
    }
  //}
}

- (NSArray *)createFetchRequest {
  LOG_METHOD;
  NSArray *result;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"AccountData" inManagedObjectContext:_context];
  [fetchRequest setEntity:entityDescription];
  result = [_context executeFetchRequest:fetchRequest error:nil];

// debug用
//  YAccountData *model = [result objectAtIndex:0];
//  NSNumber *number = [model valueForKey:@"accountID"];
//  NSString *user = [model valueForKey:@"accountName"];
//  NSString *summary = [model valueForKey:@"accountSummary"];
//  NSString *icon = [model valueForKey:@"accountIcon"];
//  LOG(@"id %@", number);
//  LOG(@"user %@", user);
//  LOG(@"summary %@", summary);
//  LOG(@"icon %@", icon);
  
  return result;

}

@end