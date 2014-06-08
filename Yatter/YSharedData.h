//
//  YSharedData.h
//  Yatter
//
//  Created by TomohikoYamada on 13/07/30.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSharedData : NSObject

+ (id)sharedManager;

- (void)setData:(id)anObject forkey:(id)akey;
- (id)getDataForKey:(id)akey;
- (void)removeDataForKey:(id)akey;
- (void)setLoginState:(id)obj forkey:(id)akey;
- (id)getLoginState:(id)akey;

@end
