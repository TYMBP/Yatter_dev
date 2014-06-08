//
//  YTweetRowDataManager.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/07/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTweetRowDataManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "YAccountData.h"

@implementation YTweetRowDataManager {
  NSMutableData *statusData;
  NSURLConnection *connection;
  NSInteger count;
//  FMDatabase *db;
}

- (id)init {
  LOG_METHOD;
  self = [super init];
  if (self) {
    self.imageCache = nil;
    self.downloaderManager = nil;
    FMDatabase *db = [self getConnection];
    [db open];
    [db executeUpdate:SQL_DELETE];
    [db executeUpdate:SQL_CREATE];
    [db close];
    _tweetDataBase = [[YTweetRowData alloc] init];
    statusData = [[NSMutableData alloc] initWithCapacity:0];
    sharedRowData = [YSharedRowData sharedManaber];
    sharedData = [YSharedData sharedManager];
    _accountData = [YAccountDataManager sharedManager];
    _followData = [YFollowingDataManager sharedManager];
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


- (NSArray *)add {
  LOG_METHOD;
  int dataCount = [_results count];
  LOG(@"dataCount:%d",dataCount);
  for (int i = 0; i < dataCount; i++) {
    YTweetRowData *tweetData = [[YTweetRowData alloc] init];
    tweetData.username = @"username";
    tweetData.status = @"status";
    tweetData.createdAt = @"createdAt";
    tweetData.imgName = @"imgName";
    [_results addObject:tweetData];
  }
return _results;
}

- (void)deleteTweetData {
  LOG_METHOD;
    FMDatabase *db = [self getConnection];
    [db open];
    [db executeUpdate:SQL_DELETE];
    [db close];
}

- (void)getTweetData {
  LOG_METHOD;
  count = [sharedRowData getData];
  [self connectionAPI2];
//  [self connectionAPI];
}

//0816 投稿時のdataリセット
- (void)resetTweetData {
  LOG_METHOD;
  [sharedData setLoginState:[NSNumber numberWithBool:NO] forkey:@"loginStatus"];
  [self connectionAPI2];
//  [self connectionAPI];
}

- (void)refreshTweetData:(NSInteger)n {
  
  LOG(@"%s %d",__func__,n);
  [sharedRowData refreshData:0];
  [sharedData setLoginState:[NSNumber numberWithBool:YES] forkey:@"loginStatus"];
  count = [sharedRowData getData];
  FMDatabase *db = [self getConnection];
  [db open];
  [db executeUpdate:SQL_DELETE];
  [db executeUpdate:SQL_CREATE];
  [db close];
  [self connectionAPI2];
//  [self connectionAPI];
}
//0922実装　connectionAPIから移行
- (void)connectionAPI2 {
  LOG_METHOD;
  NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
  
  NSArray *acData = [_accountData createFetchRequest];
  YAccountData *model = [acData objectAtIndex:0];
  NSNumber *userID = [model valueForKey:@"accountID"];
  [mutableDic setObject:userID forKey:@"user_id"];
  
  NSNumber *n = [NSNumber numberWithInteger:count];
  [mutableDic setObject:n forKey:@"n"];
  NSURL *url = [NSURL URLWithString:STATUS_API];
  LOG(@"mutableDic:%@",mutableDic);
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
  NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  LOG(@"bodyString:%@",bodyString);
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];

  NSData *requestData = [NSData dataWithBytes:[bodyString UTF8String] length:[bodyString length]];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:requestData];;
  [NSURLConnection connectionWithRequest:request delegate:self];  
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  LOG_METHOD;
  [statusData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  LOG_METHOD;
  [statusData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  LOG_METHOD;
  NSString *json_str = [[NSString alloc] initWithData:statusData encoding:NSUTF8StringEncoding];
  NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
  
  NSError *error = nil;
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
  LOG(@"jsonObject:%@",jsonObject);
  _results = [[NSMutableArray alloc] init];
  
  for (NSDictionary *obj in jsonObject) {
    _tweetDataBase.status = [obj objectForKey:@"status"];
    _tweetDataBase.username = [obj objectForKey:@"user_id"];
    _tweetDataBase.createdAt = [obj objectForKey:@"created_at"];
    NSString *image = [obj objectForKey:@"image_name"];
   
//    if ([image length] == 6) {
    if ([image isEqual:[NSNull null]]) {
      LOG_METHOD;
      _tweetDataBase.imgName = image;
    } else {
      NSString *bitly =  [self getShortUrl:image];
      LOG(@"bitly:%@", bitly);
      _tweetDataBase.imgName = bitly;
    }
    
    LOG(@"status:%@",_tweetDataBase.status);
    LOG(@"username:%@",_tweetDataBase.username);
    LOG(@"createdAt:%@",_tweetDataBase.createdAt);
    LOG(@"imgName:%@",_tweetDataBase.imgName);
    //[_results addObject:obj];
    [self addTweetData:_tweetDataBase];
  }
  //0901セル追加のログイン前処理の分岐
  NSNumber *num = [sharedData getLoginState:@"loginStatus"];
  loginFlag = [num boolValue];
  LOG(@"loginStatus:%d",loginFlag);
  if (loginFlag == YES) {
    LOG(@"num %@",num);
    NSNotification *n = [NSNotification notificationWithName:@"addTweetCell" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
  } else {
    //0729変更　->0901修正
//    [sharedData setData:[NSNumber numberWithBool:YES] forkey:@"loginFlag"];
    NSNotification *n = [NSNotification notificationWithName:@"connectionFinish" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
  }
}

//SQLiteへ追加
- (FMDatabase *)getConnection {
  if (self.dbPath == nil) {
    self.dbPath = [YTweetRowDataManager getDbFilePath];
  }
  return [FMDatabase databaseWithPath:self.dbPath];
}

+ (NSString *)getDbFilePath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *dir = [paths objectAtIndex:0];
  return [dir stringByAppendingPathComponent:DB_FIME_NAME];
}

- (void)addTweetData:(YTweetRowData *)tweetData {
  FMDatabase *db = [self getConnection];
  [db open];
  
  [db setShouldCacheStatements:YES];
  
  if ([db executeUpdate:SQL_INSERT,_tweetDataBase.username,_tweetDataBase.status, _tweetDataBase.imgName, _tweetDataBase.createdAt]) {
    LOG(@"add:insert");
  
  } else {
    LOG(@"nil");
    tweetData = nil;
  }
  [db close];
}
//SQLよりTweetData取得
- (NSArray *)getTweetRowData {
  LOG_METHOD;
  FMDatabase * db = [self getConnection];
  [db open];
  FMResultSet *results = [db executeQuery:SQL_SELECT];
  NSMutableArray *tweetDatas = [[NSMutableArray alloc] initWithCapacity:0];
  
  while ([results next]) {
    YTweetRowData *tweetData = [[YTweetRowData alloc] init];
    tweetData.username = [results stringForColumnIndex:1];
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

//短縮URL
- (NSString *)getShortUrl:(NSString *)name {
  LOG_METHOD;
  NSString *baseUrl = IMAGE_URL;
  NSString *img = [name stringByAppendingString:@".jpg"];
  NSString *imagePath = [baseUrl stringByAppendingString:img];
  LOG(@"imagePath:%@",imagePath);
//  NSURL* imageUrl = [NSURL URLWithString:imagePath];
  NSString *userName = @"o_2e5efhtlbd";
  NSString *apiKey = @"R_ad26e2ac923b1656bfe25d556a3c53f3";
  NSString *escaped = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,(__bridge CFStringRef)imagePath, NULL,(__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?&login=%@&apiKey=%@&longUrl=%@", userName, apiKey, escaped]];
  NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
  LOG(@"result:%@",result);
  NSData *jsonData = [result dataUsingEncoding:NSUnicodeStringEncoding];

  NSError *error = nil;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
//  NSDictionary *dic = [result JSONValue];
  if ([[dic objectForKey:@"status_code"] intValue] == 200) {
    LOG(@"dic;%@",[[dic objectForKey:@"data"] objectForKey:@"url"]);
    return [[dic objectForKey:@"data"] objectForKey:@"url"];
  }
  return nil;
}

//0807画像DL用コメントアウト
//- (void)downloader:(NSURLConnection *)conn didLoad:(NSMutableData *)data identifier:(id)identifier {
//  NSLog(@"%s",__func__);
//  NSIndexPath *indexPath = identifier;
//  NSLog(@"index = %d",[indexPath row]);
//  UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//  if (cell != nil) {
//    UIImageView *iv = [self makeImageView:CGRectMake(50, 50, 200, 150) image:[UIImage imageWithData:data]];
//    [cell addSubview:iv];
//    [self.imageCache setObject:[UIImage imageWithData:data] forKey:indexPath];
//    [self.downloaderManager removeObjectForKey:indexPath];
//  }
//}

@end
