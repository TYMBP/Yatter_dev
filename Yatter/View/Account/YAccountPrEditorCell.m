//
//  YAccountPrEditorCell.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountPrEditorCell.h"

@implementation YAccountPrEditorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
      _accountData = [YAccountEditorShareData sharedManager];
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_textView];
  }
  return self;
}

- (void)setUpRowData:(NSString *)rowdata rowIndexPath:(NSInteger)row {
  _textView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width -30, 145);
  _textView.text = rowdata;
  [_textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  LOG_METHOD;
  int maxInputLength = 300;
  // 入力済みのテキストを取得
  _replaceText = [textView.text mutableCopy];
  // 入力済みのテキストと入力が行われたテキストを結合
  [_replaceText replaceCharactersInRange:range withString:text];
 
  if ([_replaceText length] > maxInputLength) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"入力文字数制限" message:@"自己紹介は300文字以内です" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.title = @"300文字を超してます!";
    [alert show];
    return NO;
  } else {
    [_accountData refreshData:_replaceText key:1];
    return YES;
  }
}

@end
