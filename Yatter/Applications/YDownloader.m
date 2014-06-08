//
//  YDownloader.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/08/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YDownloader.h"

@implementation YDownloader

- (BOOL)get:(NSURL *)url {
  LOG_METHOD;
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"GET"];
  
  NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
  if (conn) {
    self.buffer = [NSMutableData data];
    return YES;
  } else {
    return NO;
  }
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)receivedData {
  LOG_METHOD;
  [self.buffer appendData:receivedData];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
  LOG(@"Connection failed! Error -%@ %d %@", [error domain], [error code], [error localizedDescription]);
  self.buffer = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
  LOG(@"Succeed!! Received %d byted of data", [_buffer length]);
  if ([_dlDelegate respondsToSelector:@selector(downloader:didLoad:identifier:)]) {
    [_dlDelegate downloader:conn didLoad:_buffer identifier:self.identifier];
  }
}


@end
