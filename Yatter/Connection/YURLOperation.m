//
//  YURLOperation.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/28.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YURLOperation.h"
#import "YApplication.h"

@implementation YURLOperation {
  __unsafe_unretained id _target;
  SEL _selector;
  NSURLConnection *_connection;
  NSMutableURLRequest *_request;
  NSMutableData *_data;
  NSError *_error;
}

- (id)initWithTarget:(id)target selector:(SEL)selector {
  LOG_METHOD;
  self = [super init];
  if (self) {
    _target = target;
    _selector = selector;
    _name = NSStringFromClass([self class]);
    _executing = NO;
    _finished = NO;
    _cancelled = NO;
    _timeoutInterVal = 15;
  }
  return self;
}

- (void)start {
  LOG_METHOD;
  [[NSThread currentThread] setName:_name];
  if (_cancelled || _finished)
    return;
  self.executing = YES;
  
  _request.timeoutInterval = _timeoutInterVal;
  _connection = [NSURLConnection connectionWithRequest:_request delegate:self];
  [_connection start];
  NSPort *dummyPort = [NSPort port];
  [[NSRunLoop currentRunLoop] addPort:dummyPort forMode:NSDefaultRunLoopMode];
  do {
    LOG_METHOD;
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
  } while (self.isExecuting);
  [[NSRunLoop currentRunLoop] removePort:dummyPort forMode:NSDefaultRunLoopMode];
}

- (BOOL)isConcurrent {
  LOG_METHOD;
  return YES;
}

- (void)cancel {
  LOG_METHOD;
  [_connection cancel];
  
  self.cancelled = YES;
  self.executing = NO;
  self.finished = YES;
  _target = nil;
  _selector = nil;
}

- (void)end {
  LOG_METHOD;
  _connection = nil;
  self.executing = NO;
  self.finished = YES;
  if (_target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (_target) {
      LOG_METHOD;
      [_target performSelectorOnMainThread:_selector withObject:self waitUntilDone:NO];
    }
#pragma clang diagnostic pop
  }
  _target = nil;
  _selector = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  LOG_METHOD;
  if (_cancelled || _finished)
    return;
  _statusCode = [(NSHTTPURLResponse *)response statusCode];
  _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  LOG_METHOD;
  if (_cancelled || _finished)
    return;
//  NSMutableData *success = [NSMutableData data];
//  [success appendData:data];
//  NSString *response = [[NSString alloc] initWithData:success encoding:NSASCIIStringEncoding];
//  LOG(@"response %@",response);
  [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  LOG_METHOD;
  if (_cancelled || _finished)
    return;
  NSString *str = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
  LOG(@"%s YamadaTest:str %@",__func__, str);
  [self connectionDidFinish:nil];
  [self end];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  LOG_METHOD
  _error = error;
  [self connectionDidFinish:error];
  [self end];
}

- (void)connectionDidFinish:(NSError *)error {
  LOG_METHOD;
}


@end
