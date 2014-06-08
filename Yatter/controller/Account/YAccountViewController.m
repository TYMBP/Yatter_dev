//
//  YAccountViewController.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/01.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountViewController.h"
#import "YAccountEditViewController.h"
#import "YTweetViewController.h"
#import "YAccountViewRowDataCell.h"
#import "YApplication.h"
#import "YMyTweetCount.h"
#import "YFollowingDataManager.h"
#import "YMyFollowerCount.h"

@implementation YAccountViewController {
  YMyTweetCount *_connection;
  YMyFollowerCount *_FlrConnection;
  NSString *_tweetCount;
  NSString *_followUser;
  NSString *_followerUser;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  LOG_METHOD;
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Account";
    LOG_METHOD;
    _accountData = [YAccountDataManager sharedManager];
    _accountSharedData = [YAccountEditorShareData sharedManager];
  }
  return self;
}

- (void)viewDidLoad {
  LOG_METHOD;
  [super viewDidLoad];
  
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  // MyTweet数を取得
  [self runAPI];
  // follow数を取得
  _followUser = [self getFollowUserCount];
  // follower数を取得
  
  
  //coredataからユーザーデータを取得
  NSArray *returnData = [_accountData createFetchRequest];
  LOG(@"%s test %@",__func__,returnData);
  YAccountData *model = [returnData objectAtIndex:0];
  _userInfo = [NSMutableArray arrayWithObjects:[model valueForKey:@"accountName"],[model valueForKey:@"accountSummary"], [model valueForKey:@"accountIcon"], nil];
  [_accountSharedData setData:_userInfo];
 
  //navigationbar　カラー
  //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.3];
  self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.96 blue:0.81 alpha:1.0];
  //navigationbar button追加
  UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
  self.navigationItem.rightBarButtonItem = edit;

  //label
  _accountBase = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
  _accountBase.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_accountBase];
 
  //icon画像追加
  NSString *baseUrl = ICON_URL;
  NSMutableArray *data = [_accountSharedData getData];
  NSString *iconName = [data objectAtIndex:2];
  NSString *img = [iconName stringByAppendingString:@".jpg"];
  NSString *imagePath = [baseUrl stringByAppendingString:img];
  LOG(@"imagePath:%@",imagePath);
  
  //ここまで
  
  _picture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
  NSData *url = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
  _picture.image = [[UIImage alloc] initWithData:url];
  [_accountBase addSubview:_picture];
  
  //0921テキストを別にする
  _accountName = [self makeTextView:CGRectMake(100, 10, 200, 20)];
  _accountName.font = [UIFont systemFontOfSize:12];
  [_accountBase addSubview:_accountName];
  _accountInfo = [self makeTextView:CGRectMake(100, 30, 200, 60)];
  [_accountBase addSubview:_accountInfo];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, self.view.bounds.size.height-100) style:UITableViewStyleGrouped];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
  LOG_METHOD;
  _accountName.text = nil;
  _accountInfo.text = nil;
  _picture.image = nil;
  
  //coredataからユーザーデータを取得
  NSArray *returnData = [_accountData createFetchRequest];
  YAccountData *model = [returnData objectAtIndex:0];
  _userInfo = [NSMutableArray arrayWithObjects:[model valueForKey:@"accountName"],[model valueForKey:@"accountSummary"], [model valueForKey:@"accountIcon"], nil];
  [_accountSharedData setData:_userInfo];
  NSMutableArray *data = [_accountSharedData getData];
  
  NSString *text = @"@";
  NSString *setText = [text stringByAppendingString:[data objectAtIndex:0]];
  _accountName.text = setText;
  _accountInfo.text = [data objectAtIndex:1];
  
  NSString *baseUrl = ICON_URL;
  NSString *iconName = [data objectAtIndex:2];
  NSString *img = [iconName stringByAppendingString:@".jpg"];
  NSString *imagePath = [baseUrl stringByAppendingString:img];
  LOG(@"imagePath:%@",imagePath);
  NSData *url = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
  _picture.image = [[UIImage alloc] initWithData:url];
                    
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:YES];
  _tweetCount = nil;
}

- (UITextView *)makeTextView:(CGRect)rect {
  UITextView *textView = [[UITextView alloc] init];
  [textView setFrame:rect];
  return textView;
}

- (void)runAPI {
  LOG_METHOD;
  @synchronized (self) {
    _connection = [[YMyTweetCount alloc] initWithTarget:self selector:@selector(getMyTweetCountFinish)];
    _FlrConnection = [[YMyFollowerCount alloc] initWithTarget:self selector:@selector(getFollowerCountFinish)];
    [[YApplication application] addURLOperation:_connection];
    [[YApplication application] addURLOperation:_FlrConnection];
  }
}

- (void)getMyTweetCountFinish {
  LOG_METHOD;
  NSError *error = nil;
  NSString *json_str = [[NSString alloc] initWithData:_connection.data encoding:NSUTF8StringEncoding];
  NSData *jsonData = [json_str dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  _tweetCount = [data objectForKey:@"count"];
  [_tableView reloadData];
}

- (NSString *)getFollowUserCount {
  YFollowingDataManager *followingDataManager = [YFollowingDataManager sharedManager];
  NSArray *followUser = [followingDataManager followUserCount];
  NSInteger cnt = [followUser count];
  NSString *followUserCount = [NSString stringWithFormat:@"%d",cnt];
  return followUserCount;
}

- (void)getFollowerCountFinish {
  LOG_METHOD;
  NSError *error = nil;
  NSString *json_str2 = [[NSString alloc] initWithData:_FlrConnection.data encoding:NSUTF8StringEncoding];
  NSData *jsonData2 = [json_str2 dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data2 = [NSJSONSerialization JSONObjectWithData:jsonData2 options:NSJSONReadingAllowFragments error:&error];
  NSInteger num = [data2 count];
  _followerUser = [NSString stringWithFormat:@"%d", num];
  [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"Cell";
  YAccountViewRowDataCell *cell = (YAccountViewRowDataCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[YAccountViewRowDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  switch (indexPath.row) {
    case 0:
      LOG(@"index.row %d", indexPath.row);
      [cell setUpRowData:_tweetCount rowIndexPath:indexPath.row];
      break;
    case 1:
      LOG(@"index.row %d", indexPath.row);
      [cell setUpRowData:_followUser rowIndexPath:indexPath.row];
      break;
    case 2:
      LOG(@"index.row %d", indexPath.row);
      [cell setUpRowData:_followerUser rowIndexPath:indexPath.row];
      //cell.textLabel.text = @"-人がフォローしてます";
      break;
    case 3:
      LOG(@"index.row %d", indexPath.row);
      break;
    default:
      break;
  }
  return cell;
  
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LOG_METHOD;
  if (indexPath.row == 0) {
    YTweetViewController *myTweetView = [[YTweetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myTweetView];
    //navigationbar　カラー
    //nav.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.3];
    nav.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.96 blue:0.81 alpha:1.0];
    [self presentViewController:nav animated:YES completion:nil];
  }
  [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private methods

- (void)edit:(id)sender {
  LOG_METHOD;
  YAccountEditViewController *editView = [[YAccountEditViewController alloc] init];
  [self.navigationController pushViewController:editView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
