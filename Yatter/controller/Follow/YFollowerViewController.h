//
//  YFollowerViewController.h
//  Yatter
//
//  Created by TomohikoYamada on 13/09/26.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YRootViewController.h"
#import "YFollowListDataManager.h"
#import "YUpdateFollowingStatus.h"
#import "YUserListDataManager.h"
#import "YSharedRowData.h"

@interface YFollowerViewController : YRootViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView *_tableView;
}

@property (readwrite) NSInteger page;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) YUpdateFollowingStatus *updateFollowStatus;
@property (nonatomic, strong) YUserListDataManager *userDataManager;
@property (nonatomic, strong) YSharedRowData *sharedUserListData;

@end
