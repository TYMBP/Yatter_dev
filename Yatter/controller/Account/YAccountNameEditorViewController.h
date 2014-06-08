//
//  YAccountNameEditorViewController.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAccountData.h"
#import "YAccountDataManager.h"
//#import "YAccountDataResponseParser.h"
#import "YAccountNameEditorViewCell.h"
#import "YAccountEditorShareData.h"

@interface YAccountNameEditorViewController : UITableViewController <UITextFieldDelegate> {
  YAccountDataManager *_accountData;
  YAccountEditorShareData *_accountSharedData;
  NSMutableArray *_userInfo;
}

@end
