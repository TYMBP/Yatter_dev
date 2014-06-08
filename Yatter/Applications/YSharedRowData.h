//
//  YSharedRowData.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/08/29.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSharedRowData : NSObject

+ (id)sharedManaber;
- (void)setData:(NSInteger)n;
- (void)refreshData:(NSInteger)n;
- (NSInteger)getData;
- (void)setPageNumber:(NSInteger)number;
//- (NSInteger)getPageNumber;
- (void)setTweetCount:(NSInteger)n;
//- (NSInteger)getTweetCount;
- (void)setMyTweetCount:(NSInteger)n;
- (NSInteger)getMyTweetData;
- (void)setUserListCount:(NSInteger)n;
- (NSInteger)getUserListData;
- (void)refreshUserListData:(NSInteger)n;
- (void)setFollowListCount:(NSInteger)n;
- (void)setFollowFlag:(NSInteger)n;
- (NSInteger)getFollowListData;
- (NSInteger)getFollowFlgData;

@end
