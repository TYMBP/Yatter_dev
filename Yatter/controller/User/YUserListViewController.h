//
//  YUserListViewController.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/06.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YRootViewController.h"
#import "YUserListData.h"
#import "YUpdateFollowingStatus.h"
#import "YUserListDataManager.h"
#import "YSharedRowData.h"

@interface YUserListViewController : YRootViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView *_tableView;
}

@property (readwrite) NSInteger page;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) YUpdateFollowingStatus *updateFollowStatus;
@property (nonatomic, strong) YUserListDataManager *userDataManager;
@property (nonatomic, strong) YSharedRowData *sharedUserListData;

@end
