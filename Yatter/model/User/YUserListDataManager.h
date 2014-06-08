//
//  YUserListDataManager.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUserListData.h"

@class FMDatabase;

@interface YUserListDataManager : NSObject

@property (nonatomic,strong) NSMutableArray *channels;
@property (nonatomic,strong) YUserListData *userData;
@property (nonatomic,strong) NSMutableArray *results;
@property (nonatomic,copy) NSString *dbPath;

+ (YUserListDataManager *)sharedManager;
- (FMDatabase *)getConnection;
- (void)addUserData:(YUserListData *)usersData;
- (NSArray *)getUserRowData;
- (NSString *)getDbFilePath;
- (void)deleteUserList;
//- (void)updateFollowStatus:(NSDictionary *)dic;

@end
