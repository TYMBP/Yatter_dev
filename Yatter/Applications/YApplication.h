//
//  YApplication.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/08/29.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YURLOperation.h"
//#import "YSharedRowData.h"

@interface YApplication : NSObject

+ (id)application;
- (void)addURLOperation:(YURLOperation *)urlOperation;
//@property (nonatomic, strong, readonly) YSharedRowData *sharedData;

@end
