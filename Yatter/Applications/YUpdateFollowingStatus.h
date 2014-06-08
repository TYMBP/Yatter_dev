//
//  YUpdateFollowingStatus.h
//  Yatter
//
//  Created by tomohiko on 2013/10/20.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUpdateFollowingStatus : NSObject

+ (id)sharedManager;

- (void)setFollwStatus:(id)obj forkey:(id)akey;
- (id)getFollowStatusForKey:(id)obj;
- (void)removeFollowStatusForKey:(id)obj;

@end
