//
//  YTweetRowCell.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/29.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTableViewRowDataCell.h"
#import "YMyTweetData.h"

@interface YTweetRowCell : YTableViewRowDataCell {
  __strong UIImageView *_userIconView;
  __strong UILabel *_usernameLabel;
  __strong UILabel *_statusLabel;
  __strong UILabel *_createAtLabel;
  __strong UILabel *_postImageUrl;
  __strong UIImageView *_postImage;
  __strong UILabel *_baseLabel;
}


- (CGSize)sizeThatFits2:(CGSize)size;

@end
