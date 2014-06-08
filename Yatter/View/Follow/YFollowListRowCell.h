//
//  YFollowListRowCell.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/12/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTableViewRowDataCell.h"
//#import "YFollowListData.h"
#import "YUserListData.h"
#import "YUpdateFollow.h"
#import "YFollowingDataManager.h"

@interface YFollowListRowCell : YTableViewRowDataCell

@property (nonatomic, strong) YUpdateFollow *updateConnection;
@property (nonatomic, strong) NSMutableDictionary *muDic;
@property (nonatomic, strong) NSDictionary *updateList;
@property (nonatomic, strong) YFollowingDataManager *followingDataManager;

- (void)setupRowData:(YUserListData *)rowData;

@end
