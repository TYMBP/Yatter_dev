//
//  YFollowViewController.m
//  Yatter
//
//  Created by TomohikoYamada on 13/09/26.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YFollowViewController.h"
#import "YApplication.h"
#import "YFollowList.h"
//#import "YFollowListData.h"
#import "YUserListData.h"
#import "YFollowListRowCell.h"
#import "YSharedRowData.h"
#import "MBProgressHUD.h"

#define ONCE_READ_COUNT 10;

@implementation YFollowViewController {
  NSInteger cnt;
  YFollowList *_connection;
  YFollowListRowCell *_followCell;
  YSharedRowData *_followSharedData;
  NSMutableArray *_result;
  UITableViewCell *_nextCell;
  UIActivityIndicatorView *_indicator;
  MBProgressHUD *hud;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  LOG_METHOD;
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _followSharedData = [YSharedRowData sharedManaber];
    _userDataManager = [YUserListDataManager sharedManager];
    _updateFollowStatus = [YUpdateFollowingStatus sharedManager];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [self.view addSubview:_tableView];
  //navigationbar button追加
  UIBarButtonItem *exit = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(clickExitButton)];
  self.navigationItem.leftBarButtonItem = exit;
  // dataReset
  [self dataReset];
  //indicator
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(setIndicator) name:@"startInd" object:nil];
   //updateFinish
  [nc addObserver:self selector:@selector(followingDataUpdateFinish) name:@"followListRowCellUpdateFinish" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  LOG_METHOD;
  [super viewWillAppear:YES];
   _page = 1;
  [_followSharedData setFollowListCount:0];
  [_followSharedData setFollowFlag:1];
  [self runAPI];
}

- (void)runAPI {
  [hud hide:YES];
  @synchronized(self) {
    _connection = [[YFollowList alloc] initWithTarget:self selector:@selector(getFollowDataFinish)];
    [[YApplication application] addURLOperation:_connection];
  }
}

- (void)getFollowDataFinish {
  LOG_METHOD;
//  _list = nil;
//  _list = [NSMutableArray array];
  NSError *error = nil;
  NSString *jsonStr = [[NSString alloc] initWithData:_connection.data encoding:NSUTF8StringEncoding];
  NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  for (NSDictionary *obj in data) {
    YUserListData *followData = [[YUserListData alloc] init];
    followData.userId = [obj objectForKey:@"follow_id"];
    followData.userName = [obj objectForKey:@"follow_name"];
    followData.userIcon = [obj objectForKey:@"follow_icon"];
    //[_list addObject:followData];
    [_userDataManager addUserData:followData];
  }
  [self setUsersData];
//  [_tableView reloadData];
}

- (void)setUsersData {
  LOG_METHOD;
  _list = nil;
  _list = [NSMutableArray array];
  NSArray *existList = [_userDataManager getUserRowData];
  for (YUserListData *article in existList) {
    [_list addObject:article];
    LOG(@"YamadaTest:article:userId %@", article.userId);
    LOG(@"YamadaTest:article:userId %@", article.followStatus);
  }
  [hud hide:YES];
  [_tableView reloadData];
}

- (void)dataReset {
  [_userDataManager deleteUserList];
}

- (void)setIndicator {
  hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)addUserListRow {
  LOG_METHOD;
  _page++;
  LOG(@"YamadaTest:page %d", _page);
  [self runAPI];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden {
  // Remove HUD from screen when the HUD was hidded
  [hud removeFromSuperview];
}

- (void)followingDataUpdateFinish {
  LOG_METHOD;
  [self dataReset];
  [self viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:YES];
  [self dataReset];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger base = _page * ONCE_READ_COUNT;
  cnt = _list.count;
  if (cnt == base) {
    return cnt+1;
  }
  return cnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row != cnt) {
    YUserListData *rowData = [self.list objectAtIndex:indexPath.row];
    LOG(@"YamadaTest:rowData %@", rowData.userName);
    static NSString *CellIdentifier = @"NormalCell";
    YFollowListRowCell *cell = (YFollowListRowCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[YFollowListRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupRowData:rowData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  } else {
    static NSString *cellInentifier = @"NextCell";
    _nextCell = [tableView dequeueReusableCellWithIdentifier:cellInentifier];
    if (_nextCell == nil) {
      _nextCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInentifier];
    }
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.color = [UIColor blackColor];
    _indicator.frame = CGRectMake(0, 0, 32, 32);
    _indicator.center = CGPointMake(_nextCell.bounds.size.width/2, _nextCell.bounds.size.height/2);
    [_indicator setHidesWhenStopped:YES];
    [_nextCell addSubview:_indicator];
    [_indicator stopAnimating];
    _nextCell.textLabel.text = @"next cell";
    return _nextCell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGSize size;
  size.height = 60;
  return size.height;
}

// リスト更新（10件以上）
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // タップされたcellの判別
  int hoge = self.list.count;
  if (indexPath.section == 0){
    if (indexPath.row == hoge) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
      [_followSharedData setFollowListCount:10];
      [self addUserListRow];
      [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
  }
}

- (void)clickExitButton {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end