//
//  YAccountNameEditorViewCell.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/14.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountNameEditorViewCell.h"

@implementation YAccountNameEditorViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _accountData = [YAccountEditorShareData sharedManager];
      _textField = [[UITextField alloc] initWithFrame:CGRectZero];
      _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      _textField.delegate = self;
      [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)setUpRowData:(NSString *)rowdata rowIndexPath:(NSInteger)row {
//  LOG(@"rowdata:%@", rowdata);
  _textField.frame = CGRectMake(10, 0, self.contentView.bounds.size.width -30, self.contentView.bounds.size.height);
  _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _textField.text = rowdata;
  [_textField becomeFirstResponder];
  
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  LOG_METHOD;
  
  int maxInputLength = 30;
  _replaceText = [_textField.text mutableCopy];
  // 入力済みのテキストと入力が行われたテキストを結合
  [_replaceText replaceCharactersInRange:range withString:string];
//  //バリデーション　やめた
//	NSRange match = [_replaceText rangeOfString:@"^[a-zA-Z0-9]{0,30}$" options:NSRegularExpressionSearch];
//	if (match.location != NSNotFound) {
//		NSLog(@"Found: %@",[_replaceText substringWithRange:match]);
//	} else {
//		NSLog(@"Not Found");
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"入力エラー" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//	}

  if ([_replaceText length] > maxInputLength) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"入力文字数制限" message:@"アカウント名は30文字以内です" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    return NO;
  } else {
//  //バリデーション　やめた
//    if ([_replaceText isEqualToString:_userName]) {
//      LOG(@"user name nochange!");
//      NSNotification *n = [NSNotification notificationWithName:@"noChangeUserName" object:self];
//      [[NSNotificationCenter defaultCenter] postNotification:n];
//    } else {
//      LOG(@"user name change!");
//      NSNotification *n = [NSNotification notificationWithName:@"changeUserName" object:self];
//      [[NSNotificationCenter defaultCenter] postNotification:n];
//    }
    [_accountData refreshData:_replaceText key:0];
    return YES;
  }
  
  
}

@end
