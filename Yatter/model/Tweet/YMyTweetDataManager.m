//
//  YMyTweetDataManager.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/29.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YMyTweetDataManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "YAccountData.h"
#import "YAccountDataManager.h"
#import "YUtil.h"

@implementation YMyTweetDataManager {
  NSMutableData *statusData;
  NSURLConnection *connection;
  NSInteger count;
  YAccountDataManager *_accountData;
}

- (id)init {
  LOG_METHOD;
  self = [super init];
  if (self) {
    FMDatabase *db = [self getConnection];
    [db open];
    [db executeUpdate:SQL_MYTWEET_DELETE];
    [db executeUpdate:SQL_MYTWEET_CREATE];
    [db close];
    _myTweetData = [[YMyTweetData alloc] init];
    statusData = [[NSMutableData alloc] initWithCapacity:0];
    _accountData = [YAccountDataManager sharedManager];
  }
  return self;
}

- (UIImageView *)makeImageView:(CGRect)rect image:(UIImage *)image {
  LOG_METHOD;
  UIImageView *imageView = [[UIImageView alloc] init];
  [imageView setFrame:rect];
  [imageView setImage:image];
  [imageView setContentMode:UIViewContentModeScaleAspectFill];
  return imageView;
}

- (void)setTweet:(NSMutableArray *)data {
  for (NSDictionary *obj in data) {
    _myTweetData.status = [obj objectForKey:@"status"];
    _myTweetData.userName = [obj objectForKey:@"user_id"];
    _myTweetData.createdAt = [obj objectForKey:@"created_at"];
    NSString *image = [obj objectForKey:@"image_name"];
   
    if ([image isEqual:[NSNull null]]) {
      LOG_METHOD;
      _myTweetData.imgName = image;
    } else {
      NSString *bitly = [YUtil getShortUrl:image];
      LOG(@"bitly:%@", bitly);
      _myTweetData.imgName = bitly;
    }
    
    LOG(@"status:%@",_myTweetData.status);
    LOG(@"username:%@",_myTweetData.userName);
    LOG(@"createdAt:%@",_myTweetData.createdAt);
    LOG(@"imgName:%@",_myTweetData.imgName);
    [self addTweetData:_myTweetData];
  }
}

- (void)deleteMyTweet {
  LOG_METHOD;
    FMDatabase *db = [self getConnection];
    [db open];
    [db executeUpdate:SQL_MYTWEET_DELETE];
    [db close];
}

//- (void)refreshTweetData:(NSInteger)n {
//  
//  LOG(@"%s %d",__func__,n);
//  [sharedRowData refreshData:0];
//  [sharedData setLoginState:[NSNumber numberWithBool:YES] forkey:@"loginStatus"];
//  count = [sharedRowData getData];
//  FMDatabase *db = [self getConnection];
//  [db open];
//  [db executeUpdate:SQL_DELETE];
//  [db executeUpdate:SQL_CREATE];
//  [db close];
////  [self connectionAPI2];
////  [self connectionAPI];
//}


//SQLiteへ追加
- (void)addTweetData:(YMyTweetData *)tweetData {
  LOG_METHOD;
  FMDatabase *db = [self getConnection];
  [db open];
  
  [db setShouldCacheStatements:YES];
  if ([db executeUpdate:SQL_MYTWEET_INSERT,tweetData.userName,tweetData.status, tweetData.imgName, tweetData.createdAt]) {
    LOG(@"add:insert");
  
  } else {
    LOG(@"nil");
    tweetData = nil;
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

//SQLよりTweetData取得
- (NSArray *)getTweetRowData {
  LOG_METHOD;
  FMDatabase * db = [self getConnection];
  [db open];
  FMResultSet *results = [db executeQuery:SQL_MYTWEET_SELECT];
  NSMutableArray *tweetDatas = [[NSMutableArray alloc] initWithCapacity:0];
  
  while ([results next]) {
    YMyTweetData *tweetData = [[YMyTweetData alloc] init];
    tweetData.userName = [results stringForColumnIndex:1];
//    LOG(@"username:%@",tweetData.username);
    tweetData.status = [results stringForColumnIndex:2];
//    LOG(@"status:%@",tweetData.status);
    tweetData.imgName = [results stringForColumnIndex:3];
    tweetData.createdAt = [results stringForColumnIndex:4];
    [tweetDatas addObject:tweetData];
    
  }
  [db close];
  return tweetDatas;
}

@end
