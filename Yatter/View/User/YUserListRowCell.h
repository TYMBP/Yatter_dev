//
//  YUserListRowCell.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTableViewRowDataCell.h"
#import "YUserListData.h"
#import "YUserListButton.h"
#import "YAccountDataManager.h"
#import "YUpdateFollow.h"
#import "YUserListDataManager.h"
#import "YFollowingDataManager.h"

@interface YUserListRowCell : YTableViewRowDataCell {
  __strong UIImageView *_userIconView;
  __strong UILabel *_userNameLabel;
  __strong UILabel *_userAccountLabel;
  __strong UILabel *_baseLabel;
  __strong YUserListButton *_followButton;
}

@property (nonatomic, strong) YUserListDataManager *userListDataManager;
@property (nonatomic, strong) YAccountDataManager *accountDataManager;
@property (nonatomic, strong) YFollowingDataManager *followingDataManager;
@property (nonatomic, strong) YUpdateFollow *updateConnection;
@property (nonatomic, strong) NSMutableDictionary *muDic;

- (NSMutableDictionary *)getFollowerId;
- (void)setupRowData:(YUserListData *)rowData;

@end

