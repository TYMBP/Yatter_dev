//
//  YUserListData.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

// 131214 YuserListDataに統一 あとで削除予定

#import "YTableViewRowData.h"

@interface YUserListData : YTableViewRowData

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *followStatus;
@property (nonatomic, strong) NSString *userAccount;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIcon;

@end
