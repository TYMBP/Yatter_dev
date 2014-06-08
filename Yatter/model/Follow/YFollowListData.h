//
//  YFollowListData.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/12/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTableViewRowData.h"

@interface YFollowListData : YTableViewRowData

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *followStatus;
@property (nonatomic, strong) NSString *userAccount;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIcon;

@end
