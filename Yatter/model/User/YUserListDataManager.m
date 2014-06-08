//
//  YUserListDataManager.m
//
//
//  Created by Tomohiko Yamada on 2013/10/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YUserListDataManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "YUtil.h"
#import "YFollowingDataManager.h"
#import "YFollowingData.h"

@implementation YUserListDataManager {
  NSURLConnection *_connection;
  NSInteger _count;
  YUserListDataManager *_usersData;
  YFollowingDataManager *_followingDataManager;
}

static YUserListDataManager *sharedInstance = nil;

+ (YUserListDataManager *)sharedManager {
  @synchronized(self) {
    if (sharedInstance == nil) {
      sharedInstance = [[self alloc] init];
    }
  }
  return sharedInstance;
}

- (id)init {
  LOG_METHOD;
  self = [super init];
  if (self) {
    FMDatabase *db = [self getConnection];
    [db open];
    [db executeUpdate:SQL_USERLIST_DELETE];
    [db executeUpdate:SQL_ENUM_DELETE];
    [db executeUpdate:SQL_USERLIST_CREATE];
    [db executeUpdate:SQL_ENUM_CREATE];
    [db executeUpdate:SQL_ENUM_INSERT];
    [db close];
  }
  return self;
}

- (FMDatabase *)getConnection {
  if (self.dbPath == nil) {
    self.dbPath = [self getDbFilePath];
  }
  return [FMDatabase databaseWithPath:self.dbPath];
}

- (NSString *)getDbFilePath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *dir = [paths objectAtIndex:0];
  return [dir stringByAppendingPathComponent:DB_FIME_NAME];
}

- (void)addUserData:(YUserListData *)usersData {
  LOG_METHOD;
  NSNumber *val = usersData.userId;
  LOG(@"YamadaTest:userData.userId %@",val);
  int num = [val intValue];
  NSNumber *valUserId = [NSNumber numberWithInt:num];
  NSNumber *followType = [NSNumber numberWithInt:0];
  
  //followStatusの取得
  _followingDataManager = [YFollowingDataManager sharedManager];
  NSArray *followArray = [_followingDataManager getFollowerData];
  for (YFollowingData *data in followArray) {
    if ([valUserId isEqualToNumber:data.followingID]) {
      followType = [NSNumber numberWithInt:1];
      LOG(@"YamadaTest:followType %@", followType);
    }
  }
  FMDatabase *db = [self getConnection];
  [db open];
  [db setShouldCacheStatements:YES];
  //foreign_keys set
  FMResultSet *rs = [db executeQuery:SQL_FOREIGNKEY_CHECK];
  int enabled = [rs intForColumnIndex:0];
  if (!enabled) {
    [db executeUpdate:SQL_FOREIGNKEY_SET];
    FMResultSet *rs2 = [db executeQuery:SQL_FOREIGNKEY_CHECK];
    if ([rs2 next]) {
      enabled = [rs2 intForColumnIndex:0];
//      LOG(@"Yamada:foreign set:%d",enabled);
    }
  }
  //userIconの設定確認 ->nullならdefaultに設定
  NSString *icon = usersData.userIcon;
  if ([icon isEqual:[NSNull null]]) {
    LOG(@"icon:null");
    icon = @"default";
  } else if ([icon isEqualToString:@""]) {
    LOG(@"icon:空");
    icon = @"default";
    //icon = @"default";
  } else {
    LOG(@"else");
    icon = usersData.userIcon;
  }
//  LOG(@"YamadaTest:userId %@", usersData.userId);
  if ([db executeUpdate:SQL_USERLIST_INSERT,usersData.userId, usersData.userName, icon, followType]) {
    LOG(@"add:insert userID:%@ follow:%@",usersData.userId, followType);
  } else {
    LOG(@"add:nil");
    usersData = nil;
  }
//  NSArray *chk = [self getUserRowData];
//  LOG(@"YamadaTest:chk %d", chk.count);
  [db close];
}

- (NSArray *)getUserRowData {
  LOG_METHOD;
  FMDatabase *db = [self getConnection];
  [db open];
  FMResultSet *results = [db executeQuery:SQL_USERLIST_SELECT];
  NSMutableArray *userDatas = [[NSMutableArray alloc] initWithCapacity:0];
//  NSMutableArray *userDatas = [NSMutableArray array];

  while ([results next]) {
    YUserListData *userData = [[YUserListData alloc] init];
    int listUserId = [results intForColumnIndex:1];
    userData.userId = [NSNumber numberWithInt:listUserId];
    userData.userName = [results stringForColumnIndex:2];
    userData.userIcon = [results stringForColumnIndex:3];
    int status = [results intForColumnIndex:4];
    userData.followStatus = [NSNumber numberWithInt:status];
    LOG(@"YamadaTest:userData.userId %@", userData.userId);
    [userDatas addObject:userData];
  }
  [db close];
  return userDatas;
}

// 1020変更　削除予定
//- (void)updateFollowStatus:(NSDictionary *)dic {
//  LOG_METHOD;
//  NSNumber *followStatus = [dic objectForKey:@"buttonTag"];
//  NSNumber *followId = [dic objectForKey:@"followId"];
//  if ([followStatus isEqualToNumber:[NSNumber numberWithInt:0]]) {
//    LOG(@"YamadaTest:followStatus=0 %@",followStatus);
//    
//  } else {
//    LOG(@"YamadaTest:followStatus=1 %@", followStatus);
//  }
//  
//}

- (void)deleteUserList {
  LOG_METHOD;
  FMDatabase *db = [self getConnection];
  [db open];
  [db executeUpdate:SQL_USERLIST_DELETE];
  [db close];
}

@end
