//
//  YAccountDataResponseParser.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//
//  followユーザーを取得する非同期実装

#import <Foundation/Foundation.h>
#import "YFollowingDataManager.h"

@class YAccountDataManager;

@interface YAccountDataResponseParser : NSObject {
  YFollowingDataManager *_followingDataManager;
}

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) YAccountDataManager *accountData;

- (void)connectionAPI;

@end
