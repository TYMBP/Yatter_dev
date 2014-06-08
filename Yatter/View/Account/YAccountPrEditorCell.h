//
//  YAccountPrEditorCell.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountTableViewCell.h"
#import "YAccountEditorShareData.h"

@interface YAccountPrEditorCell : YAccountTableViewCell<UITextViewDelegate> {
  YAccountEditorShareData *_accountData;
  UITextView *_textView;
  NSMutableString *_replaceText;
}

@end
