//
//  YAccountEditViewCell.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/14.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountEditViewCell.h"

@implementation YAccountEditViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _iconName = [[UILabel alloc] initWithFrame:CGRectZero];
      _iconName.backgroundColor = [UIColor clearColor];
      [self.contentView addSubview:_iconName];
      _iconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
      [self.contentView addSubview:_iconImage];
      _label1 = [[UILabel alloc] initWithFrame:CGRectZero];
      _label1.font = [UIFont systemFontOfSize:12];
      _label1.textColor = [UIColor grayColor];
      _label1.backgroundColor = [UIColor clearColor];
      [self.contentView addSubview:_label1];
      _label2 = [[UILabel alloc] initWithFrame:CGRectZero];
      _label2.font = [UIFont systemFontOfSize:16];
      _label2.backgroundColor = [UIColor clearColor];
      [self.contentView addSubview:_label2];
    }
    return self;
}

//- (void)setUpIconEditor:(NSString *)url {
//  NSData *path = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://yamato.main.jp/app/yatter_api/account_data/icon/rino.jpg"]];
//  _iconName.frame = CGRectMake(70, 0, 200, 60);
//  _iconName.text = @"アイコンの変更";
//  _iconImage.frame = CGRectMake(5, 5, 50, 50);
//  _iconImage.image = [[UIImage alloc] initWithData:path];
//}

- (void)setUpIconEditor:(UIImage *)img {
  LOG_METHOD;
    _iconImage.image = nil;
  _iconName.frame = CGRectMake(70, 0, 200, 60);
  _iconName.text = @"アイコンの変更";
    _iconImage.frame = CGRectMake(5, 5, 50, 50);
    _iconImage.image = img;
}

- (void)setUpRowData:(NSString *)rowdata rowIndexPath:(NSInteger)row {
  if (row == 0) {
    LOG(@"row:%d", row);
    _label1.text = @"アカウント";
    _label1.frame = CGRectMake(10, 10, self.contentView.bounds.size.width -250, self.contentView.bounds.size.height -20);
    _label2.frame = CGRectMake(80, 10, self.contentView.bounds.size.width -100, self.contentView.bounds.size.height -20);
    _label2.text = rowdata;
        
  } else {
    LOG(@"row:%d", row);
    _label1.text = @"自己紹介";
    _label1.frame = CGRectMake(10, 10, self.contentView.bounds.size.width -250, self.contentView.bounds.size.height -20);
    _label2.frame = CGRectMake(80, 10, self.contentView.bounds.size.width -100, self.contentView.bounds.size.height -20);
    _label2.text = rowdata;
  }
    
}

@end
