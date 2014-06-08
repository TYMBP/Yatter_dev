//
//  YMyTweetDataManager.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/29.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMyTweetData.h"

@class FMDatabase;

@interface YMyTweetDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic, strong) YMyTweetData *myTweetData;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, copy) NSString *dbPath;

- (void)setTweet:(NSMutableArray *)data;
-(FMDatabase *)getConnection;
- (void)addTweetData:(YMyTweetData *)tweetData;
- (NSArray *)getTweetRowData;
- (NSString *)getDbFilePath;
- (void)deleteMyTweet;
//- (void)refreshTweetData:(NSInteger)n;

@end
