//
//  YURLOperation.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/28.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YURLOperation : NSOperation <NSURLConnectionDataDelegate>

@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic, getter = isCancelled) BOOL cancelled;
@property (strong, readonly) NSString *name;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (strong, readonly) NSData *data;
@property (nonatomic, strong) NSError *error;
@property (unsafe_unretained, readonly) NSInteger statusCode;
@property (nonatomic) NSTimeInterval timeoutInterVal;

- (id)initWithTarget:(id)target selector:(SEL)selector;
- (void)end;

//子クラスで実装する。メインスレッドではない。
- (void)connectionDidFinish:(NSError *)error;

@end
