//
//  YSharedData.m
//  Yatter
//
//  Created by TomohikoYamada on 13/07/30.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YSharedData.h"

@implementation YSharedData {
  NSMutableDictionary *dictionary;
  NSMutableDictionary *state;
}

static YSharedData *sharedData = nil;

- (id)init {
  LOG_METHOD;
  self = [super init];
  if (self) {
    dictionary = [[NSMutableDictionary alloc] init];
//    state = [[NSMutableDictionary alloc] init];
    [self setLoginState:[NSNumber numberWithBool:NO] forkey:@"loginStatus"];
  }
  return self;
}

+ (id)sharedManager {
  @synchronized(self) {
    if (sharedData == nil) {
      sharedData = [[self alloc] init];
    }
  }
  return sharedData;
}

- (void)setData:(id)obj forkey:(id)akey {
  @synchronized(dictionary) {
    [dictionary setObject:obj forKey:akey];
    NSNotification *n = [NSNotification notificationWithName:@"login" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
  }
}

- (id)getDataForKey:(id)obj {
  id retval = [dictionary objectForKey:obj];
  return retval != [NSNull null] ? retval : nil;
}

- (void)removeDataForKey:(id)akey {
  @synchronized(dictionary) {
    [dictionary removeObjectForKey:akey];
  }
}

- (void)setLoginState:(id)obj forkey:(id)akey {
  LOG_METHOD;
  @synchronized(dictionary) {
    [dictionary setObject:obj forKey:akey];
  }
//  NSNumber *a = [self getLoginState:@"loginStatus"];
//  LOG(@"yloginStats %@",a);
}

- (id)getLoginState:(id)akey {
  LOG_METHOD;
  id retval = [dictionary objectForKey:akey];
  return retval != [NSNull null] ? retval : nil;
}

@end
