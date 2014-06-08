//
//  YMyFollowerCount.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/12/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YMyFollowerCount.h"
#import "YAccountDataManager.h"
#import "YAccountData.h"

@implementation YMyFollowerCount

- (id)initWithTarget:(id)target selector:(SEL)selector {
  LOG_METHOD;
  self = [super initWithTarget:target selector:selector];
  if (self) {
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    YAccountDataManager *myData = [YAccountDataManager sharedManager];
    NSArray *acData = [myData createFetchRequest];
    YAccountData *model = [acData objectAtIndex:0];
    NSNumber *userID = [model valueForKey:@"accountID"];
    [mutableDic setObject:userID forKey:@"user_id"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
    NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LOG(@"bodyString:%@",bodyString);
    NSURL *url = [NSURL URLWithString:FOLLOWER_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];

    NSData *requestData = [NSData dataWithBytes:[bodyString UTF8String] length:[bodyString length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];;
    [NSURLConnection connectionWithRequest:request delegate:self];
  }
  return self;
}

- (void)connectionDidFinish:(NSError *)error {
  LOG_METHOD;
  if (error) {
    return;
  }
  if (200 != self.statusCode) {
    LOG_METHOD;
    return;
  }
}

@end
