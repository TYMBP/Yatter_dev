//
//  YFollowingDataManager.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YFollowingDataManager.h"

@implementation YFollowingDataManager

static YFollowingDataManager *sharedInstance = nil;

+ (YFollowingDataManager *)sharedManager {
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
    [db executeUpdate:SQL_FOLLOWING_DELETE];
    [db executeUpdate:SQL_FOLLOWING_CREATE];
    [db close];
    _followingData = [[YFollowingData alloc] init];
  }
  return self;
}

- (void)setFollowingData:(NSDictionary *)follow {
  LOG_METHOD;
  LOG(@"following %@",follow);
  for (NSDictionary *obj in follow) {
    _followingData.followingID = [obj objectForKey:@"following_id"];
    _followingData.followerName = [obj objectForKey:@"following_name"];
//    _followingData.followerIcon = [obj objectForKey:@"following_icon"];
    //アイコン画像の設定
    NSString *icon = [obj objectForKey:@"following_icon"];
    if ([icon isEqual:[NSNull null]]) {
      LOG(@"icon:null");
      icon = @"default";
      _followingData.followerIcon = icon;
    } else if ([icon isEqualToString:@""]) {
      LOG(@"icon:空");
      icon = @"default";
      _followingData.followerIcon = icon;
    } else {
      LOG(@"else");
      _followingData.followerIcon = icon;
    }
    LOG(@"YamadaTest:followerIcon %@",_followingData.followerIcon);
    [self addFollowingData:_followingData];
  }
}

- (void)addFollowingData:(YFollowingData *)data {
  LOG_METHOD;
  LOG(@"YamadaTest:addFollowingdata %@", data.followerName);
  LOG(@"YamadaTest:addFollowingdata: %@", data.followingID);
  LOG(@"YamadaTest:addFollowingdata: %@", data.followerIcon);
//  NSString *stringId = [_followingData.followingID stringValue];
  
  FMDatabase *db = [self getConnection];
  [db open];
  [db setShouldCacheStatements:YES];
//  1019 変数名変更
//  if ([db executeUpdate:SQL_FOLLOWING_INSERT, _followingData.followingID,_followingData.followerName,_followingData.followerIcon]) {
  if ([db executeUpdate:SQL_FOLLOWING_INSERT, data.followingID, data.followerName, data.followerIcon]) {
    LOG(@"%s following data insert OK!",__func__);
  } else {
    LOG(@"following data insert NG!");
    data = nil;
  }
  [db close];
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

//dbからfollowingIDの取得
- (NSArray *)getFollowerData {
  LOG_METHOD;
  FMDatabase *db = [self getConnection];
  [db open];
  FMResultSet *result = [db executeQuery:SQL_FOLLOWING_SELECT];
  NSMutableArray *followerDatas = [[NSMutableArray alloc] initWithCapacity:0];
  
  while ([result next]) {
    YFollowingData *followerData = [[YFollowingData alloc] init];
    followerData.followingID = [result objectForColumnIndex:1];
    followerData.followerName = [result stringForColumnIndex:2];
    followerData.followerIcon = [result stringForColumnIndex:3];
    LOG(@"%@",followerData.followingID);
    LOG(@"%@",followerData.followerName);
    LOG(@"%@",followerData.followerIcon);
    [followerDatas addObject:followerData];
  }
  return followerDatas;
}

//dbからfollowerを検索
- (NSArray *)searchFolloerData:(NSString *)num {
  LOG_METHOD;
  LOG(@"num:%@",num);
//  int n = [num intValue];
  FMDatabase *db = [self getConnection];
  [db open];
  FMResultSet *result = [db executeQuery:SQL_FOLLOWING_SEARCH,num];
  NSMutableArray *searchData = [[NSMutableArray alloc] initWithCapacity:0];
  while ([result next]) {
    YFollowingData *followerData = [[YFollowingData alloc] init];
    followerData.followerName = [result stringForColumnIndex:2];
    followerData.followerIcon = [result stringForColumnIndex:3];
    LOG(@"%@",followerData.followerName);
    LOG(@"%@",followerData.followerIcon);
    [searchData addObject:followerData];
  }
  return searchData;
}

//dbからfollow数の取得
- (NSArray *)followUserCount {
  LOG_METHOD;
  FMDatabase *db = [self getConnection];
  [db open];
  FMResultSet *result = [db executeQuery:SQL_FOLLOWING_SELECT];
  NSMutableArray *searchData = [[NSMutableArray alloc] initWithCapacity:0];
  while ([result next]) {
    YFollowingData *followerData = [[YFollowingData alloc] init];
    followerData.followerName = [result stringForColumnIndex:2];
    [searchData addObject:followerData];
    LOG(@"searchData: %d", searchData.count);
  }
  return searchData;
}
- (void)deleteFollowingData {
  LOG_METHOD;
  FMDatabase *db = [self getConnection];
  [db open];
  [db executeUpdate:SQL_FOLLOWING_DELETE];
  [db close];
}

@end
