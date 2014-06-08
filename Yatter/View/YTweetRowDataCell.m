//
//  YTweetRowDataCell.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/07/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTweetRowDataCell.h"
#import "YFollowingDataManager.h"
#import "YFollowingData.h"
#import "YAccountData.h"
#import "YAccountDataManager.h"

@implementation YTweetRowDataCell {
  YFollowingDataManager *_followerData;
  YAccountDataManager *_accountData;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  LOG_METHOD;
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
//    ios7対応
//    self.contentView.backgroundColor = [UIColor colorWithRed:0.47 green:0.53 blue:0.6 alpha:0.3];
    _baseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_baseLabel];
    
    _userIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_userIconView];
    
    _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _usernameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.contentView addSubview:_usernameLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _statusLabel.font = [UIFont systemFontOfSize:16.0f];
    _statusLabel.numberOfLines = 0;
    _statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_statusLabel];
    
    _createAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createAtLabel.font = [UIFont systemFontOfSize:14.0f];
    _createAtLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _createAtLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_createAtLabel];
    //イメージを非表示　短縮URL表示
    _postImageUrl = [[UILabel alloc] initWithFrame:CGRectZero];
    _postImageUrl.userInteractionEnabled = YES;
    _postImageUrl.tag = 100;
    _postImageUrl.font = [UIFont systemFontOfSize:14.0f];
    _postImageUrl.textColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:0.8];
    _postImageUrl.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_postImageUrl];
    //イメージ表示用
//    _postImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self.contentView addSubview:_postImage];
    _followerData = [YFollowingDataManager sharedManager];
    _accountData = [YAccountDataManager sharedManager];
  }
  return  self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  if (touch.view.tag == _postImageUrl.tag) {
    _postImageUrl.backgroundColor = [UIColor colorWithRed:0.6 green:1.0 blue:1.0 alpha:0.5];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [[event allTouches] anyObject];
  if (touch.view.tag == _postImageUrl.tag) {
    NSString *url = _postImageUrl.text;
    LOG(@"touchesEnded value:%@",_postImageUrl.text);
    _postImageUrl.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:url forKey:@"KEY"];
    NSNotification *n = [NSNotification notificationWithName:@"tweetImage" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
  }
}

- (void)setupRowData:(YTableViewRowData *)rowData {

  YTweetRowData *tweet = (YTweetRowData *)rowData;
  
  //icon画像追加
  //coredataからユーザーデータを取得
  NSArray *returnData = [_accountData createFetchRequest];
  YAccountData *model = [returnData objectAtIndex:0];
  NSNumber *number = model.accountID;
  NSString *userID = [number stringValue];
  if ([tweet.username isEqualToString:userID]) {
    LOG(@"my tweet");
    NSString *text = @"@";
    NSString *setText = [text stringByAppendingString:model.accountName];
    _usernameLabel.text = setText;
    _userIconView.image = [UIImage imageNamed:@"tw_default.png"];
    NSString *iconName = model.accountIcon;
    NSString *baseUrl = ICON_URL;
    NSString *img = [iconName stringByAppendingString:@".jpg"];
    NSString *imagePath = [baseUrl stringByAppendingString:img];
    LOG(@"imagePath:%@",imagePath);
    //別スレッドで非同期処理
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    
    dispatch_async(q_global, ^{
      NSData *url = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
      
      dispatch_async(q_main, ^{
        _userIconView.image = [UIImage imageWithData:url];
      });
    });
  } else {
    LOG(@"follower tweet");
    NSArray *array = [_followerData searchFolloerData:tweet.username];
    LOG(@"array %@", array);
    YFollowingData *data = [array objectAtIndex:0];
    NSString *text = @"@";
    NSString *setText = [text stringByAppendingString:data.followerName];
    _usernameLabel.text = setText;
    _userIconView.image = [UIImage imageNamed:@"tw_default.png"];
    NSString *iconName = data.followerIcon;
    NSString *baseUrl = ICON_URL;
    NSString *img = [iconName stringByAppendingString:@".jpg"];
    NSString *imagePath = [baseUrl stringByAppendingString:img];
    LOG(@"imagePath:%@",imagePath);
    
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    
    dispatch_async(q_global, ^{
      NSData *url = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
      
      dispatch_async(q_main, ^{
        _userIconView.image = [UIImage imageWithData:url];
      });
    });
  }
  
//    _userIconView.image = [UIImage imageNamed:@"tw.png"];
  _statusLabel.text = tweet.status;
  _createAtLabel.text = tweet.createdAt;
  
  if ([tweet.imgName length] == 6) {
    LOG(@"image null");
    _postImageUrl.text = nil;
  } else {
    LOG(@"image true");
    _postImageUrl.text = tweet.imgName;
  }
  
////0810 cell image表示バージョン
//  if ([tweet.imgName length] == 6) {
//    LOG(@"image Null");
//    _postImage.image = nil;
//  } else {
//    NSString *baseUrl = IMAGE_URL;
//    NSString *img = [tweet.imgName stringByAppendingString:@".jpg"];
//    NSString *imagePath = [baseUrl stringByAppendingString:img];
//    
//    NSURL* imageUrl = [NSURL URLWithString:imagePath];
//    NSData* data = [NSData dataWithContentsOfURL:imageUrl];
//    UIImage* tweetImage = [[UIImage alloc] initWithData:data];
//    
//    //アスペクト比固定　サイズ変更
//    float resized_width = YPOST_IMAGE;
//    float resized_height = YPOST_IMAGE;
//    float ratio_width = YPOST_IMAGE/tweetImage.size.width;
//    float ratio_height = YPOST_IMAGE/tweetImage.size.height;
//    
//    if (ratio_width > ratio_height) {
//      if (YPOST_IMAGE > tweetImage.size.width) {
//        return;
//      } else {
//        resized_width = tweetImage.size.width * ratio_height;
//        LOG(@"width:%f",resized_width);
//      }
//    } else {
//      if (YPOST_IMAGE > tweetImage.size.height) {
//        return;
//      } else {
//        resized_height = tweetImage.size.height * ratio_width;
//        LOG(@"width:%f",resized_height);
//      }
//    }
//    CGSize resized_size = CGSizeMake(resized_width, resized_height);
//    UIGraphicsBeginImageContext(resized_size);
//    [tweetImage drawInRect:CGRectMake(0, 0, resized_width, resized_height)];
//    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    _postImage.image = resizeImage;
////    _postImage.image = tweetImage;
////    _postImage.image = [UIImage imageNamed:@"newyork.jpg"];
//  }
}

- (void)layoutSubviews {
  LOG_METHOD;
  [super layoutSubviews];
  CGRect bounds = self.bounds;
  
//0810
  LOG(@"_postImageUrl:%d",_postImageUrl.text.length);
  if ([_postImageUrl.text length] > 0) {
    LOG(@"log");
    _postImageUrl.hidden = NO;
    [self sizeThatFits:bounds.size withLayout:YES];
  } else {
    LOG(@"log else");
    _postImageUrl.hidden = YES;
  [self sizeThatFits2:bounds.size withLayout:YES];
  }
}

- (CGSize)sizeThatFits:(CGSize)size {
//  LOG_METHOD;
  return [self sizeThatFits:size withLayout:NO];
}

- (CGSize)sizeThatFits:(CGSize)size withLayout:(BOOL)withLayout {
  CGRect userIconViewFrame;
  userIconViewFrame.origin.x = YMARGIN;
  userIconViewFrame.origin.y = YMARGIN;
  userIconViewFrame.size.width = YUSER_ICON_SIZE;
  userIconViewFrame.size.height = YUSER_ICON_SIZE;
  if (withLayout) {
    _userIconView.frame = userIconViewFrame;
  }
  CGFloat minHeight = userIconViewFrame.origin.y + userIconViewFrame.size.height + YMARGIN;
  
  CGRect usernameLabelFrame;
  usernameLabelFrame.origin.x = userIconViewFrame.origin.x + userIconViewFrame.size.width + YMARGIN;
  usernameLabelFrame.origin.y = YMARGIN;
  usernameLabelFrame.size.width = size.width - usernameLabelFrame.origin.x - YMARGIN;
  usernameLabelFrame.size.height = size.height - usernameLabelFrame.origin.y;
  usernameLabelFrame.size = [_usernameLabel sizeThatFits:usernameLabelFrame.size];
  if (withLayout) {
    _usernameLabel.frame = usernameLabelFrame;
  }
  
  CGRect createdAtLabelFrame;
  createdAtLabelFrame.origin.x = usernameLabelFrame.origin.x;
//  createdAtLabelFrame.origin.x = YMARGIN;
  createdAtLabelFrame.origin.y = usernameLabelFrame.origin.y + usernameLabelFrame.size.height;
//  createdAtLabelFrame.origin.y = postImageLabelFrame.origin.y + postImageLabelFrame.size.height + YMARGIN;
  createdAtLabelFrame.size.width = size.width - createdAtLabelFrame.origin.x - YMARGIN;
  createdAtLabelFrame.size.height = size.height - createdAtLabelFrame.origin.y;
  createdAtLabelFrame.size = [_createAtLabel sizeThatFits:createdAtLabelFrame.size];
  if (withLayout) {
    _createAtLabel.frame = createdAtLabelFrame;
  }
  
  CGRect statusLabelFrame;
  statusLabelFrame.origin.x = usernameLabelFrame.origin.x;
  statusLabelFrame.origin.y = userIconViewFrame.origin.y + userIconViewFrame.size.height;
  statusLabelFrame.size.width = size.width - statusLabelFrame.origin.x - YMARGIN;
  statusLabelFrame.size.height = size.height - statusLabelFrame.origin.y;
  statusLabelFrame.size = [_statusLabel sizeThatFits:statusLabelFrame.size];
  if (withLayout) {
    _statusLabel.frame = statusLabelFrame;
  }
  
  CGRect postImageLabelFrame;
  postImageLabelFrame.origin.x = usernameLabelFrame.origin.x;
//  postImageLabelFrame.origin.x = YIMAGE_MARGIN;
  postImageLabelFrame.origin.y = statusLabelFrame.origin.y + statusLabelFrame.size.height + YMARGIN;
  postImageLabelFrame.size.width = size.width - postImageLabelFrame.origin.x - YMARGIN;
  postImageLabelFrame.size.height = size.height - postImageLabelFrame.origin.y;
  postImageLabelFrame.size = [_postImageUrl sizeThatFits:statusLabelFrame.size];
  LOG(@"imageUrl:%@ %@",_postImageUrl.text, _statusLabel.text);
  LOG(@"imageurlsize:%f",postImageLabelFrame.size.height);
  //  postImageLabelFrame.size.width = _postImage.image.size.width;
//  postImageLabelFrame.size.height = _postImage.image.size.height;
//  postImageLabelFrame.size.width = YPOST_IMAGE;
//  postImageLabelFrame.size.height = YPOST_IMAGE;
  if (withLayout) {
    _postImageUrl.frame = postImageLabelFrame;
  }
  
  CGRect baseLabelFrame;
  baseLabelFrame.origin.x = YBASE_MARGIN;
  baseLabelFrame.origin.y = YBASE_MARGIN;
  baseLabelFrame.size.width = size.width - YBASE_MARGIN *2;
  baseLabelFrame.size.height = YUSER_ICON_SIZE + statusLabelFrame.size.height + postImageLabelFrame.size.height + YBASE_MARGIN2;
  LOG(@"basesize:%f",baseLabelFrame.size.height);
  //image表示用高さの指定
  //  if (YUSER_ICON_SIZE > userIconViewFrame.size.height + statusLabelFrame.size.height + YMARGIN ) {
//    baseLabelFrame.size.height = YUSER_ICON_SIZE + postImageLabelFrame.size.height + createdAtLabelFrame.size.height + YBASE_MARGIN2;
//  } else {
//    baseLabelFrame.size.height = userIconViewFrame.size.height + statusLabelFrame.size.height + postImageLabelFrame.size.height + createdAtLabelFrame.size.height + YBASE_MARGIN2;
//  }
  if (withLayout) {
    _baseLabel.frame = baseLabelFrame;
  }
  
  size.height = baseLabelFrame.size.height + YBASE_MARGIN2;
  LOG(@"%f",size.height);
  if (size.height < minHeight) {
    size.height = minHeight;
  }
  return size;
}

- (CGSize)sizeThatFits2:(CGSize)size {
  LOG_METHOD;
  return [self sizeThatFits2:size withLayout:NO];
}

- (CGSize)sizeThatFits2:(CGSize)size withLayout:(BOOL)withLayout {
  LOG_METHOD;
  CGRect userIconViewFrame;
  userIconViewFrame.origin.x = YMARGIN;
  userIconViewFrame.origin.y = YMARGIN;
  userIconViewFrame.size.width = YUSER_ICON_SIZE;
  userIconViewFrame.size.height = YUSER_ICON_SIZE;
  if (withLayout) {
    _userIconView.frame = userIconViewFrame;
  }
  CGFloat minHeight = userIconViewFrame.origin.y + userIconViewFrame.size.height + YMARGIN;
  
  CGRect usernameLabelFrame;
  usernameLabelFrame.origin.x = userIconViewFrame.origin.x + userIconViewFrame.size.width + YMARGIN;
  usernameLabelFrame.origin.y = YMARGIN;
  usernameLabelFrame.size.width = size.width - usernameLabelFrame.origin.x - YMARGIN;
  usernameLabelFrame.size.height = size.height - usernameLabelFrame.origin.y;
  usernameLabelFrame.size = [_usernameLabel sizeThatFits:usernameLabelFrame.size];
  if (withLayout) {
    _usernameLabel.frame = usernameLabelFrame;
  }
  
  CGRect createdAtLabelFrame;
  createdAtLabelFrame.origin.x = usernameLabelFrame.origin.x;
//  createdAtLabelFrame.origin.x = YMARGIN;
  createdAtLabelFrame.origin.y = usernameLabelFrame.origin.y + usernameLabelFrame.size.height;
//  createdAtLabelFrame.origin.y = postImageLabelFrame.origin.y + postImageLabelFrame.size.height + YMARGIN;
  createdAtLabelFrame.size.width = size.width - createdAtLabelFrame.origin.x - YMARGIN;
  createdAtLabelFrame.size.height = size.height - createdAtLabelFrame.origin.y;
  createdAtLabelFrame.size = [_createAtLabel sizeThatFits:createdAtLabelFrame.size];
  if (withLayout) {
    _createAtLabel.frame = createdAtLabelFrame;
  }
  
  CGRect statusLabelFrame;
  statusLabelFrame.origin.x = usernameLabelFrame.origin.x;
  statusLabelFrame.origin.y = userIconViewFrame.origin.y + userIconViewFrame.size.height;
  statusLabelFrame.size.width = size.width - statusLabelFrame.origin.x - YMARGIN;
  statusLabelFrame.size.height = size.height - statusLabelFrame.origin.y;
  statusLabelFrame.size = [_statusLabel sizeThatFits:statusLabelFrame.size];
  if (withLayout) {
    _statusLabel.frame = statusLabelFrame;
  }
  LOG(@"status:%@ height %f", _statusLabel.text, statusLabelFrame.size.height);
  CGRect baseLabelFrame;
  baseLabelFrame.origin.x = YBASE_MARGIN;
  baseLabelFrame.origin.y = YBASE_MARGIN;
  baseLabelFrame.size.width = size.width - YBASE_MARGIN *2;
  baseLabelFrame.size.height = YUSER_ICON_SIZE + statusLabelFrame.size.height + YBASE_MARGIN2;
  //image表示用高さの指定
//  if (YUSER_ICON_SIZE > userIconViewFrame.size.height + statusLabelFrame.size.height + YMARGIN ) {
//    baseLabelFrame.size.height = YUSER_ICON_SIZE + createdAtLabelFrame.size.height + YBASE_MARGIN2;
//  } else {
//    baseLabelFrame.size.height = userIconViewFrame.size.height + statusLabelFrame.size.height + createdAtLabelFrame.size.height + YBASE_MARGIN2;
//  }
  if (withLayout) {
    _baseLabel.frame = baseLabelFrame;
  }
  
  size.height = baseLabelFrame.size.height + YBASE_MARGIN2;
  LOG(@"%f",size.height);
  if (size.height < minHeight) {
    size.height = minHeight;
  }
  return size;
}

@end
