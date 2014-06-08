//
//  YAccountPrEditorViewController.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/15.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAccountData.h"
#import "YAccountDataManager.h"
//#import "YAccountDataResponseParser.h"
#import "YAccountPrEditorCell.h"
#import "YAccountEditorShareData.h"

@interface YAccountPrEditorViewController : UITableViewController {
  YAccountDataManager *_accountData;
  YAccountEditorShareData *_accountSharedData;
  NSMutableArray *_userInfo;
}

@end
