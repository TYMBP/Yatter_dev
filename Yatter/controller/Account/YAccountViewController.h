//
//  YAccountViewController.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/01.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YRootViewController.h"
#import "YAccountData.h"
#import "YAccountDataManager.h"
#import "YAccountEditorShareData.h"

@interface YAccountViewController : YRootViewController <UITableViewDelegate, UITableViewDataSource> {
  UIImageView *_picture;
  UILabel *_accountBase;
  UITextView *_accountName;
  UITextView *_accountInfo;
  UITableView *_tableView;
  NSMutableArray *_userInfo;
  NSMutableArray *_userTweetData;
  YAccountDataManager *_accountData;
  YAccountEditorShareData *_accountSharedData;
}

@end
