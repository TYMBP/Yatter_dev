//
//  YTweetRowDataManager.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/07/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YTweetRowData.h"
#import "ydownloader.h"
#import "YSharedRowData.h"
#import "YSharedData.h"
#import "YAccountDataManager.h"
#import "YFollowingDataManager.h"

@class FMDatabase;

@interface YTweetRowDataManager : NSObject <YDownloaderDelegate> {
  YSharedRowData *sharedRowData;
  //0901
  YSharedData *sharedData;
  YAccountDataManager *_accountData;
  YFollowingDataManager *_followData;
  BOOL loginFlag;
}

@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic, strong) YTweetRowData *tweetDataBase;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) NSMutableDictionary *imageCache;
@property (nonatomic, strong) NSMutableDictionary *downloaderManager;

-(FMDatabase *)getConnection;
- (NSArray *)add;
- (void)getTweetData;
//- (void)connectionAPI;
- (void)addTweetData:(YTweetRowData *)tweetData;
- (NSArray *)getTweetRowData;
//0816 reset
- (void)resetTweetData;
//0818 data delete
- (void)deleteTweetData;
//0831 pullrefresh
- (void)refreshTweetData:(NSInteger)n;

@end
