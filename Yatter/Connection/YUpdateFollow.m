//
//  YUpdateFollow.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/13.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YUpdateFollow.h"
#import "YApplication.h"
#import "YAccountDataManager.h"
#import "YAccountData.h"
#import "YSharedRowData.h"
#import "YUserListRowCell.h"
#import "YFollowListRowCell.h"

@implementation YUpdateFollow {
  __unsafe_unretained id _target;
  YAccountDataManager *_myData;
  YSharedRowData *_sharedMyRowData;
  YUserListRowCell *_userListCell;
}

- (id)initWithTarget:(id)target selector:(SEL)selector {
  LOG_METHOD;
  _target = (id)target;
  NSMutableDictionary *para = [_target getFollowerId];
  NSNumber *followId = [para objectForKey:@"followId"];
  NSNumber *state = [para objectForKey:@"buttonTag"];
  LOG(@"YamadaTest:followId %@", followId);
  LOG(@"YamadaTest:state %@", state);
  
//  _userListCell = (YUserListRowCell *)target;
//  NSMutableDictionary *para = [_userListCell getFollowerId];
//  NSNumber *followId = [para objectForKey:@"followId"];
//  NSNumber *state = [para objectForKey:@"buttonTag"];
  
  self = [super initWithTarget:target selector:selector];
  if (self) {
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    _myData = [YAccountDataManager sharedManager];
    NSArray *acData = [_myData createFetchRequest];
    YAccountData *model = [acData objectAtIndex:0];
    NSNumber *userID = [model valueForKey:@"accountID"];
    [mutableDic setObject:userID forKey:@"userId"];
    [mutableDic setObject:followId forKey:@"followId"];
    [mutableDic setObject:state forKey:@"state"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
    NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    LOG(@"%s bodyStrign %@", __func__, bodyString);
    NSURL *url = [NSURL URLWithString:UPDATE_FOLLOW_API];
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
