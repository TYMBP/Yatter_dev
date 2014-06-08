//
//  YFollowingDataManager.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFollowingData.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface YFollowingDataManager : NSObject {
  YFollowingData *_followingData;
}

@property (nonatomic, copy) NSString *dbPath;

+ (YFollowingDataManager *)sharedManager;
- (void)setFollowingData:(NSDictionary *)follow;
- (FMDatabase *)getConnection;
- (void)addFollowingData:(YFollowingData *)data;
- (NSString *)getDbFilePath;
- (NSArray *)getFollowerData;
- (NSArray *)searchFolloerData:(NSString *)num;
- (void)deleteFollowingData;
- (NSArray *)followUserCount;

@end
