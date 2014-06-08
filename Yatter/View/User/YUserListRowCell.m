//
//  YUserListRowCell.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YUserListRowCell.h"
#import "YUserListData.h"
#import "YAccountData.h"
#import "YApplication.h"
#import "YFollowingData.h"
#import "YUpdateFollowingStatus.h"

#define BTN_FOLLOW 0
#define BTN_REMOVE 1

@implementation YUserListRowCell {
  int followerId;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  LOG_METHOD;
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _userIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_userIconView];
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _userNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.contentView addSubview:_userNameLabel];
    _followButton = [YUserListButton buttonWithType:UIButtonTypeCustom];
    _followButton.titleLabel.font = [UIFont systemFontOfSize:10];
    self.accessoryView = _followButton;
    self.accountDataManager = [YAccountDataManager sharedManager];
    self.userListDataManager = [YUserListDataManager sharedManager];
    self.followingDataManager = [YFollowingDataManager sharedManager];
//    _followerData = [YFollowingDataManager sharedManager];
    
  }
  return  self;
}

//- (void)setupRowData:(YTableViewRowData *)rowData {
- (void)setupRowData:(YUserListData *)rowData {
  //coredataからユーザーデータを取得
  NSArray *returnData = [self.accountDataManager createFetchRequest];
  YAccountData *model = [returnData objectAtIndex:0];
  NSNumber *accountId = model.accountID;
  
  YUserListData *list = (YUserListData *)rowData;
  _userNameLabel.text = list.userName;
  _userNameLabel.frame = CGRectMake(70, 0, 150, 60);
  _userIconView.image = [UIImage imageNamed:@"tw_default.png"];
  _userIconView.frame = CGRectMake(5, 5, 50, 50);
  _followButton.frame = CGRectMake(0, 0, 60, 30);
  [[_followButton layer] setCornerRadius:8.0f];
  [[_followButton layer] setMasksToBounds:YES];
  NSNumber *n = list.userId;
  NSNumber *fnum = list.followStatus;
  int listUserId = [n intValue];
  
  //follow button set
  if ([n isEqualToNumber:accountId]) {
    LOG(@"YamadaTest:myaccountData");
    followerId = listUserId;
    _followButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [_followButton setTitle:@"MyAccount" forState:UIControlStateNormal];
  } else {
    if ([fnum isEqualToNumber:[NSNumber numberWithInt:1]]) {
      followerId = listUserId;
      _followButton.tag = BTN_REMOVE;
      _followButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.6 blue:1.0 alpha:1.0];
      [_followButton setTitle:@"Follow中" forState:UIControlStateNormal];
      [_followButton addTarget:self action:@selector(updateFollowButtonDidTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    } else {
      followerId = listUserId;
      _followButton.tag = BTN_FOLLOW;
      [_followButton setTitle:@"Followする" forState:UIControlStateNormal];
      _followButton.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1.0];
      [_followButton addTarget:self action:@selector(updateFollowButtonDidTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  
  NSString *iconName = list.userIcon;
  NSString *baseUrl = ICON_URL;
  NSString *img = [iconName stringByAppendingString:@".jpg"];
  NSString *imagePath = [baseUrl stringByAppendingString:img];
  LOG(@"%s imagePath:%@",__func__, imagePath);
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
  NSNotification *n = [NSNotification notificationWithName:@"followButtonTouch" object:self];
  [[NSNotificationCenter defaultCenter] postNotification:n];
  
  YUserListButton *followButton = (YUserListButton *)sender;
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
//    LOG(@"%s YamadaTest:followingID %@",__func__, followingData.followingID);
//    LOG(@"%s YamadaTest:followingName %@",__func__, followingData.followerName);
//    LOG(@"%s YamadaTest:followingIcon %@",__func__, followingData.followerIcon);
    [self.followingDataManager addFollowingData:followingData];
  }
  YUpdateFollowingStatus *followStatus = [YUpdateFollowingStatus sharedManager];
  [followStatus setFollwStatus:[NSNumber numberWithBool:YES] forkey:@"followStatus"];
  NSNotification *n = [NSNotification notificationWithName:@"followUpdateFinish" object:self];
  [[NSNotificationCenter defaultCenter] postNotification:n];
}

@end