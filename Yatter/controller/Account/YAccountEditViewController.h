//
//  YAccountEditViewController.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YAccountData.h"
#import "YAccountDataManager.h"
#import "YAccountEditViewCell.h"
#import "YAccountEditorShareData.h"

@interface YAccountEditViewController : UITableViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
  YAccountDataManager *_accountData;
  YAccountEditorShareData *_accountSharedData;
  NSMutableArray *_userInfo;
  NSString *_uploadFileName;
  NSMutableData *_statusData;
  UIImage *_iconImage;
}

@property (nonatomic, strong) UIImage *picture;

- (void)updateAccountData;

@end
