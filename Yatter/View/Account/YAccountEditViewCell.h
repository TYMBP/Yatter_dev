//
//  YAccountEditViewCell.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/14.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountTableViewCell.h"

@interface YAccountEditViewCell : YAccountTableViewCell {
  UILabel *_iconName;
  UIImageView *_iconImage;
  UILabel *_label1;
  UILabel *_label2;
  UITextField *_textField;
}

//- (void)setUpIconEditor:(NSString *)url;
- (void)setUpIconEditor:(UIImage *)img;
  
@end
