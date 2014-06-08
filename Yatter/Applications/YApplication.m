//
//  YApplication.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/08/29.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YApplication.h"
#import "YAppDelegate.h"

@implementation YApplication {
  NSOperationQueue *_urlOperationQueue;
}

+ (id)application {
  return [(YAppDelegate *)[[UIApplication sharedApplication] delegate] application];
}

- (id)init {
  self = [super init];
  if (self) {
//    _sharedData = [YSharedRowData sharedManaber];
    _urlOperationQueue = [[NSOperationQueue alloc] init];
    [_urlOperationQueue addObserver:self forKeyPath:@"operationCount" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
  }
  return self;
}

- (void)addURLOperation:(YURLOperation *)urlOperation {
  LOG_METHOD;
  [_urlOperationQueue addOperation:urlOperation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  LOG_METHOD;
  @synchronized (self) {
    int operationCount = [_urlOperationQueue operationCount];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = operationCount == 0 ? NO:YES;
  }
}



@end
