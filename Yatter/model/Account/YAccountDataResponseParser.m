//
//  YAccountDataResponseParser.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountDataResponseParser.h"
#import "YAccountDataManager.h"
#import "YAccountData.h"

@implementation YAccountDataResponseParser {
  NSMutableData *_responseData;
}

- (id)init {
  LOG_METHOD;
  self = [super init];
  if (self) {
    _responseData = [[NSMutableData alloc] initWithCapacity:0];
    _accountData = [YAccountDataManager sharedManager];
    _followingDataManager = [YFollowingDataManager sharedManager];
  }
  return self;
}

- (void)connectionAPI {
  LOG_METHOD;
  NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
  
  NSArray *acData = [_accountData createFetchRequest];
  YAccountData *model = [acData objectAtIndex:0];
  NSNumber *userID = [model valueForKey:@"accountID"];
  [mutableDic setObject:userID forKey:@"user_id"];
  LOG(@"mutableDic:%@",mutableDic);
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
  NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  LOG(@"bodyString:%@",bodyString);
  NSURL *url = [NSURL URLWithString:FOLLOWUSER_URL];
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
  [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  NSMutableData *success = [NSMutableData data];
  [success appendData:data];
  NSString *response = [[NSString alloc] initWithData:success encoding:NSASCIIStringEncoding];
  LOG(@"response:%@",response);
  [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  LOG_METHOD;
  if (!_responseData) {
  //tweetCellData取得へ
    LOG(@"_response null");
    return;
  } else {
    NSString *json_str = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    LOG(@"jsonObject:%@",jsonObject);
    
    //followdataをsqliteに追加処理
    [_followingDataManager setFollowingData:jsonObject];
    LOG(@"following_id upload!");
    NSNotification *n = [NSNotification notificationWithName:@"setFollowDataFinish" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
  }
}


//0923コメントアウト　現在未使用と思われ、あとで削除予定
//- (void)connectionAPI {
//  LOG_METHOD;
//  
//  NSString *boundary = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
//  NSMutableData *body = [[NSMutableData alloc] init];
//  
//  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//  [body appendData:[@"Content-Disposition: form-data; name=\"json\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//  [body appendData:[@"Content-Type: application/json; charset=UTF-8\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//  [body appendData:[@"Content-Transfer-Encoding: 8bit\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
// 
//  NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
//  //userID(仮)
//  NSNumber *n = [NSNumber numberWithInt:2];
//  [mutableDic setObject:n forKey:@"n"];
//  NSError *error = nil;
//  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
//  NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//  LOG(@"bodyString:%@",bodyString);
//  NSURL *url = [NSURL URLWithString:ACCOUNT_API];
//  
//  [body appendData:[[NSString stringWithFormat:@"%@\r\n", bodyString] dataUsingEncoding:NSUTF8StringEncoding]];
//  NSDictionary *requestHeader = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [NSString stringWithFormat:@"%d",[body length]],@"Content-Length",
//                                 [NSString stringWithFormat:@"multipart/form-data,boundary=%@",boundary],@"Content-Type",nil];
//  
//  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
//                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                 timeoutInterval:10.0];
//  
//  [req setAllHTTPHeaderFields:requestHeader];
//  [req setHTTPMethod:@"POST"];
//  [req setHTTPBody:body];
//  
//  [NSURLConnection connectionWithRequest:req delegate:self];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//  [_responseData setLength:0];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//  [_responseData appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//  LOG_METHOD;
//  NSString *json_str = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
//  NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
//  LOG(@"data: %@", data);
//  NSError *error = nil;
//  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//  LOG(@"jsonObject:%@",jsonObject);
//  
//  [_accountData addData:jsonObject];
//}

@end
