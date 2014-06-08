//
//  YFollowListRowCell.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/12/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YFollowListRowCell.h"
#import "YApplication.h"
#import "YFollowListButton.h"
#import "YSharedRowData.h"
#import "YFollowingDataManager.h"
#import "YUpdateFollowingStatus.h"

#define BTN_FOLLOW 0
#define BTN_REMOVE 1

@implementation YFollowListRowCell {
  __strong UIImageView *_userIconView;
  __strong UILabel *_userNameLabel;
  __strong UILabel *_userAccountLabel;
  __strong UILabel *_baseLabel;
  __strong YFollowListButton *_followButton;
  int followerId;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _userIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_userIconView];
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _userNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.contentView addSubview:_userNameLabel];
    _followButton = [YFollowListButton buttonWithType:UIButtonTypeCustom];
    _followButton.titleLabel.font = [UIFont systemFontOfSize:10];
    self.accessoryView = _followButton;
    self.followingDataManager = [YFollowingDataManager sharedManager];
  }
    return self;
}

- (void)setupRowData:(YUserListData *)rowData {
  LOG_METHOD;
  YSharedRowData *sharedRowData = [YSharedRowData sharedManaber];
  NSInteger num = [sharedRowData getFollowFlgData];
  LOG(@"YamadaTest:num %d", num);
  YUserListData *list = (YUserListData *)rowData;
  _userNameLabel.text = list.userName;
  _userNameLabel.frame = CGRectMake(70, 0, 150, 60);
  _userIconView.image = [UIImage imageNamed:@"tw_default.png"];
  _userIconView.frame = CGRectMake(5, 5, 50, 50);
  _followButton.frame = CGRectMake(0, 0, 60, 30);
  [[_followButton layer] setCornerRadius:8.0f];
  [[_followButton layer] setMasksToBounds:YES];
  NSNumber *n = list.userId;
  NSNumber *fnum = [NSNumber numberWithInteger:num];
  int listUserId = [n intValue];
   //followStatusの取得
  NSNumber *valUserId = [NSNumber numberWithInt:listUserId];
   //follow button set
  if ([fnum isEqualToNumber:[NSNumber numberWithInt:1]]) {
    followerId = listUserId;
    _followButton.tag = BTN_REMOVE;
    _followButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.6 blue:1.0 alpha:1.0];
    [_followButton setTitle:@"Follow解除" forState:UIControlStateNormal];
    [_followButton addTarget:self action:@selector(updateFollowButtonDidTouchDown:) forControlEvents:UIControlEventTouchUpInside];
  } else {
    YFollowingDataManager *followingDataManager = [YFollowingDataManager sharedManager];
    NSArray *followArray = [followingDataManager getFollowerData];
    NSNumber *followType = [NSNumber numberWithInt:0];
    
    for (YFollowingData *data in followArray) {
      if ([valUserId isEqualToNumber:data.followingID]) {
        followType = [NSNumber numberWithInt:1];
      }
    }
    if ([followType isEqualToNumber:[NSNumber numberWithInt:0]]) {
      followerId = listUserId;
      _followButton.tag = BTN_FOLLOW;
      [_followButton setTitle:@"Followする" forState:UIControlStateNormal];
      _followButton.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
      [_followButton addTarget:self action:@selector(updateFollowButtonDidTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    } else {
      followerId = listUserId;
      _followButton.tag = BTN_REMOVE;
      _followButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.6 blue:1.0 alpha:1.0];
      [_followButton setTitle:@"Follow解除" forState:UIControlStateNormal];
      [_followButton addTarget:self action:@selector(updateFollowButtonDidTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  NSString *icon = list.userIcon;
  if ([icon isEqual:[NSNull null]]) {
    icon = @"default";
  } else if ([icon isEqualToString:@""]) {
    icon = @"default";
  } else {
    icon = list.userIcon;
  }
  NSString *iconName = icon;
  NSString *baseUrl = ICON_URL;
  NSString *img = [iconName stringByAppendingString:@".jpg"];
  NSString *imagePath = [baseUrl stringByAppendingString:img];
  //別スレッドで非同期処理
  dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_queue_t q_main = dispatch_get_main_queue();
  
  dispatch_async(q_global, ^{
    NSData *url = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
    
    dispatch_async(q_main, ^{
      _userIconView.image = [UIImage imageWithData:url];
    });
  });
}

- (void)updateFollowButtonDidTouchDown:(id)sender {
  LOG_METHOD;
  NSNotification *n = [NSNotification notificationWithName:@"startInd" object:self];
  [[NSNotificationCenter defaultCenter] postNotification:n];
  YFollowListButton *followButton = (YFollowListButton *)sender;
  self.muDic = [NSMutableDictionary dictionary];
  NSNumber *buttonTag = [NSNumber numberWithInt:followButton.tag];
  [self.muDic setObject:buttonTag forKey:@"buttonTag"];
  NSNumber *changeUser = [NSNumber numberWithInt:followerId];
  [self.muDic setObject:changeUser forKey:@"followId"];
  @synchronized (self) {
    _updateConnection = [[YUpdateFollow alloc] initWithTarget:self selector:@selector(followUpdateFinish)];
    [[YApplication application] addURLOperation:_updateConnection];
  }
}

- (NSMutableDictionary *)getFollowerId {
  LOG_METHOD;
  return self.muDic;
}

//API Conn Finish
- (void)followUpdateFinish {
  LOG_METHOD;
  NSString *responseJson = [[NSString alloc] initWithData:_updateConnection.data encoding:NSUTF8StringEncoding];
  LOG(@"%s YamadaTest:responseJson %@",__func__, responseJson);
 
  NSError *error = nil;
  NSData *jsonData = [responseJson dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  [self.followingDataManager deleteFollowingData];
  YFollowingData *followingData = [[YFollowingData alloc] init];
  for (NSDictionary *obj in data) {
    followingData.followingID = [obj objectForKey:@"id"];
    followingData.followerName = [obj objectForKey:@"user_name"];
    followingData.followerIcon = [obj objectForKey:@"icon_image"];
    LOG(@"%s YamadaTest:followingID %@",__func__, followingData.followingID);
    LOG(@"%s YamadaTest:followingName %@",__func__, followingData.followerName);
    LOG(@"%s YamadaTest:followingIcon %@",__func__, followingData.followerIcon);
    [self.followingDataManager addFollowingData:followingData];
  }
  YUpdateFollowingStatus *followStatus = [YUpdateFollowingStatus sharedManager];
  [followStatus setFollwStatus:[NSNumber numberWithBool:YES] forkey:@"followStatus"];
  NSNotification *n = [NSNotification notificationWithName:@"followListRowCellUpdateFinish" object:self];
  [[NSNotificationCenter defaultCenter] postNotification:n];
}

@end
