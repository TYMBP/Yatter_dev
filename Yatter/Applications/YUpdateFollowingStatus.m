//
//  YUpdateFollowingStatus.m
//  Yatter
//
//  Created by tomohiko on 2013/10/20.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YUpdateFollowingStatus.h"

@implementation YUpdateFollowingStatus {
  NSMutableDictionary *dictionary;
}

static YUpdateFollowingStatus *sharedData = nil;

+ (id)sharedManager {
  @synchronized(self) {
    if (sharedData == nil) {
      sharedData = [[self alloc] init];
    }
  }
  return sharedData;
}

- (id)init {
  LOG_METHOD;
  self = [super init];
  if (self) {
    dictionary = [[NSMutableDictionary alloc] init];
    [self setFollwStatus:[NSNumber numberWithBool:NO] forkey:@"followStatus"];
  }
  return self;
}

- (void)setFollwStatus:(id)obj forkey:(id)akey {
  @synchronized(dictionary) {
    [dictionary setObject:obj forKey:akey];
  }
}

- (id)getFollowStatusForKey:(id)obj {
  @synchronized(dictionary) {
    id retval = [dictionary objectForKey:obj];
    return retval != [NSNull null] ? retval : nil;
  }
}

- (void)removeFollowStatusForKey:(id)obj {
  @synchronized(dictionary) {
    [dictionary removeObjectForKey:obj];
  }
}

@end
