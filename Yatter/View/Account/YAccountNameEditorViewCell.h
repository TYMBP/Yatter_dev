//
//  YAccountNameEditorViewCell.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/14.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountTableViewCell.h"
#import "YAccountEditorShareData.h"

@interface YAccountNameEditorViewCell : YAccountTableViewCell<UITextFieldDelegate> {
  UITextField *_textField;
  NSMutableString *_replaceText;
  YAccountEditorShareData *_accountData;
//  //バリデーションやめた
//  NSString *_userName;
}
@end
