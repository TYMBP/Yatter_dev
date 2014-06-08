//
//  YImageURL.m
//  Yatter
//
//  Created by TomohikoYamada on 13/08/12.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YImageURL.h"

@implementation YImageURL {
  NSMutableDictionary *dictionary;
}

static YImageURL *imageUrlData = nil;

//- (id)init {
//  self = [super init];
//  if (self) {
//    LOG_METHOD;
//    dictionary = [[NSMutableDictionary alloc] init];
//  }
//  return self;
//}

+ (id)imageUrlManager {
  LOG_METHOD;
  @synchronized(self) {
    if (imageUrlData == nil) {
      imageUrlData = [[self alloc] init];
    }
  }
  return imageUrlData;
}

- (void)setUrl:(id)object forKey:(id)key {
    dictionary = [[NSMutableDictionary alloc] init];
  @synchronized(self) {
    [dictionary setObject:object forKey:key];
    LOG_METHOD;
    LOG(@"imageUrl:%@",[dictionary objectForKey:@"URL"]);
//    NSNotification *n = [NSNotification notificationWithName:@"url" object:self];
//    [[NSNotificationCenter defaultCenter] postNotification:n];
  }
}

- (id)getUrlForKey:(id)obj {
  LOG_METHOD;
  LOG(@"geturl  imageUrl:%@",[dictionary objectForKey:@"URL"]);
  id retval = [dictionary objectForKey:obj];
  return retval != [NSNull null] ? retval : nil;
}

- (void)removeUrlForKey:(id)key {
  @synchronized(dictionary) {
    [dictionary removeObjectForKey:key];
  }
}

@end
