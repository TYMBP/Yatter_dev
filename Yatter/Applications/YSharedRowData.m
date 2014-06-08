//
//  YSharedRowData.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/08/29.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YSharedRowData.h"

@implementation YSharedRowData {
  NSMutableDictionary *dictionary;
  NSMutableDictionary *myTweetDic;
  NSMutableDictionary *userListDic;
  NSMutableDictionary *followListDic;
  NSInteger count;
  NSInteger myTweetCount;
  NSInteger userListCount;
  NSInteger followListCount;
  NSInteger followFlg;
}

static YSharedRowData *sharedData = nil;

- (id)init {
  LOG_METHOD;
  self = [super init];
  if (self) {
    LOG_METHOD;
    count = 0;
    myTweetCount = 0;
    userListCount = 0;
    followListCount = 0;
    followFlg = 0;
    dictionary = [[NSMutableDictionary alloc] init];
    myTweetDic = [[NSMutableDictionary alloc] init];
    userListDic = [[NSMutableDictionary alloc] init];
    followListDic = [[NSMutableDictionary alloc] init];
  }
  return self;
}

+ (id)sharedManaber {
  @synchronized(self) {
    if (sharedData == nil) {
      sharedData = [[self alloc] init];
    }
  }
  return sharedData;
}
//mainタイムライン
- (void)setData:(NSInteger)n {
  @synchronized(dictionary) {
    NSInteger set = n;
    count = count + set;
    LOG(@"setData count:%d", count);
    
    NSNotification *notification = [NSNotification notificationWithName:@"setCount" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
  }
}
//myTweetタイムライン
- (void)setMyTweetCount:(NSInteger)n {
  @synchronized(myTweetDic) {
    NSInteger set = n;
    myTweetCount = myTweetCount + set;
    LOG(@"setMyTweetCount%d",myTweetCount);
  }
}

//userList
- (void)setUserListCount:(NSInteger)n {
  @synchronized(userListDic) {
    NSInteger set = n;
    userListCount = userListCount + set;
    LOG(@"setMyTweetCount%d",userListCount);
  }
}

//followList
- (void)setFollowFlag:(NSInteger)n {
  followFlg = n;
}

//main
- (void)refreshData:(NSInteger)n {
  @synchronized(dictionary) {
    count = 0;
    NSInteger set = n;
    count = count + set;
    LOG(@"refreshData count:%d", count);
    
    NSNotification *notification = [NSNotification notificationWithName:@"setCount"object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
  }
}

//userList
- (void)refreshUserListData:(NSInteger)n {
  @synchronized(userListDic) {
    userListCount = n;
    LOG(@"refreshData count:%d", userListCount);
  }
}

//followList or followerList
- (void)setFollowListCount:(NSInteger)n {
  @synchronized(followListDic) {
    NSInteger set = n;
    LOG(@"YamadaTest:n %d", n);
    followListCount = followListCount + set;
  }
}

//main
- (NSInteger)getData {
  return count;
}

//myTweet
- (NSInteger)getMyTweetData {
  return myTweetCount;
}

//userList
- (NSInteger)getUserListData {
  return userListCount;
}

//followList
- (NSInteger)getFollowListData {
  return userListCount;
}

//followList
- (NSInteger)getFollowFlgData {
  return followFlg;
}

- (void)setPageNumber:(NSInteger)number {
}

//- (NSInteger)getPageNumber {
//  return self;
//}

- (void)setTweetCount:(NSInteger)n {
  
}

//- (NSInteger)getTweetCount {
//  return self;
//}

@end
