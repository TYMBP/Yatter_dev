//
//  YAccountEditorShareData.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/15.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountEditorShareData.h"

@implementation YAccountEditorShareData {
  NSMutableArray *_accountData;
}

static YAccountEditorShareData *sharedData = nil;

+ (id)sharedManager {
  @synchronized(self) {
    if (sharedData == nil) {
      sharedData = [[self alloc] init];
    }
  }
  return sharedData;
}

- (id)init {
  self = [super init];
  if (self) {
    _accountData = [NSMutableArray array];
  }
  return self;
}

- (void)setData:(NSMutableArray *)array {
  LOG_METHOD;
  @synchronized(_accountData) {
    _accountData = array;
  }
}

- (void)refreshData:(NSString *)str key:(NSInteger)key {
  [_accountData replaceObjectAtIndex:key withObject:str];
//  LOG(@"%s %@",__func__, [_accountData objectAtIndex:key]);
}
  
- (NSMutableArray *)getData {
  return _accountData;
}

@end
