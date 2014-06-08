//
//  YAccountViewRowDataCell.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/30.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountViewRowDataCell.h"

@implementation YAccountViewRowDataCell {
  UILabel *_tweetCount;
  UILabel *_followUser;
  UILabel *_followerUser;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setUpRowData:(NSString *)rowData rowIndexPath:(NSInteger)row {
  LOG(@"%s rowdata:%@", __func__, rowData);
  if (row == 0) {
    _tweetCount.text = nil;
    _tweetCount = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_tweetCount];
    NSString *countText = rowData;
    NSString *count = [NSString stringWithFormat:@"%@", countText];
    NSString *cellText = [count stringByAppendingString:@"ツイート"];
    _tweetCount.frame = CGRectMake(10, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    _tweetCount.font = [UIFont systemFontOfSize:20];
    _tweetCount.backgroundColor = [UIColor clearColor];
    _tweetCount.text = cellText;
  } else if (row == 1) {
    _followUser.text = nil;
    _followUser = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_followUser];
    NSString *followCount = rowData;
    NSString *cellText = [followCount stringByAppendingString:@"人をフォローしてます"];
    _followUser.frame = CGRectMake(10, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    _followUser.backgroundColor = [UIColor clearColor];
    _followUser.font = [UIFont systemFontOfSize:20];
    _followUser.text = cellText;
  } else if (row == 2) {
    _followerUser.text = nil;
    _followerUser = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_followerUser];
    NSString *followCount = rowData;
    NSString *cellText = [followCount stringByAppendingString:@"人のフォロワーがいます"];
    _followerUser.frame = CGRectMake(10, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    _followerUser.backgroundColor = [UIColor clearColor];
    _followerUser.font = [UIFont systemFontOfSize:20];
    _followerUser.text = cellText;
       
  } else {
    LOG(@"return");
    return;
  }
}


@end
