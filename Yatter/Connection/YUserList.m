//
//  YUserList.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YUserList.h"
#import "YApplication.h"
#import "YAccountDataManager.h"
#import "YAccountData.h"
#import "YSharedRowData.h"

@implementation YUserList {
  YAccountDataManager *_myData;
  YSharedRowData *_sharedUserListData;
  NSInteger count;
}

- (id)initWithTarget:(id)target selector:(SEL)selector {
  LOG_METHOD;
  self = [super initWithTarget:target selector:selector];
  if (self) {
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    _myData = [YAccountDataManager sharedManager];
    NSArray *acData = [_myData createFetchRequest];
    YAccountData *model = [acData objectAtIndex:0];
    NSNumber *userID = [model valueForKey:@"accountID"];
    [mutableDic setObject:userID forKey:@"user_id"];
    
    _sharedUserListData = [YSharedRowData sharedManaber];
    count = [_sharedUserListData getUserListData];
    NSNumber *n = [NSNumber numberWithInteger:count];
    [mutableDic setObject:n forKey:@"n"];
    LOG(@"YamadaTest:UserList mutableDic:%@",mutableDic);
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
    NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LOG(@"%s bodyStrign %@", __func__, bodyString);
    NSURL *url = [NSURL URLWithString:USER_LIST_API];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSData *requestData = [NSData dataWithBytes:[bodyString UTF8String] length:[bodyString length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
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
