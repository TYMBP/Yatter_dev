//
//  YAccountDataManager.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface YAccountDataManager : NSObject {
  NSURL *_storeURL;
}

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

+ (YAccountDataManager *)sharedManager;
  - (void)loadManagedObjectContext;
- (void)addData:(NSDictionary *)dic;
- (void)updateData:(NSDictionary *)dic;
- (NSArray *)createFetchRequest;

@end
