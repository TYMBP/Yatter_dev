//
//  YUserListViewController.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/06.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YUserListViewController.h"
#import "YApplication.h"
#import "YUserList.h"
#import "YUserListDataManager.h"
#import "YUserListRowCell.h"
#import "MBProgressHUD.h"

#define ONCE_READ_COUNT 10;

@implementation YUserListViewController {
  NSInteger cnt;
  YUserList *_connection;
  YUserListRowCell *_usersCell;
  NSMutableArray *_result;
  UITableViewCell *_nextCell;
  UIActivityIndicatorView *_indicator;
  MBProgressHUD *hud;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  LOG_METHOD;
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
//    n = 0;
    _userDataManager = [YUserListDataManager sharedManager];
    _sharedUserListData = [YSharedRowData sharedManaber];
    _updateFollowStatus = [YUpdateFollowingStatus sharedManager];
  }
  return self;
}

- (void)viewDidLoad {
  LOG_METHOD;
  [super viewDidLoad];
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [self.view addSubview:_tableView];
 
  //navi return button
  UIBarButtonItem *exit = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(clickExitButton)];
  self.navigationItem.leftBarButtonItem = exit;
  // dataReset
  [self dataReset];
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(setIndicator) name:@"followButtonTouch" object:nil];
  [nc addObserver:self selector:@selector(followingDataUpdateFinish) name:@"followUpdateFinish" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  LOG_METHOD;
  [super viewWillAppear:YES];
  NSNumber *state = [_updateFollowStatus getFollowStatusForKey:@"followStatus"];
  LOG(@"%s YamadaTest:followState %@", __func__, state);
  _page = 1;
  [_sharedUserListData refreshUserListData:0];
  [self runAPI];
}

- (void)clickExitButton {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)runAPI {
  LOG_METHOD;
  @synchronized (self) {
    _connection = [[YUserList alloc] initWithTarget:self selector:@selector(getUserDataFinish)];
    [[YApplication application] addURLOperation:_connection];
  }
}

- (void)getUserDataFinish {
  LOG_METHOD;
  NSError *error = nil;
  NSString *jsonStr = [[NSString alloc] initWithData:_connection.data encoding:NSUTF8StringEncoding];
//  LOG(@"%s jsonStr %@",__func__, jsonStr);
  NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  YUserListData *usersData = [[YUserListData alloc] init];
  for (NSDictionary *obj in data) {
    usersData.userId = [obj objectForKey:@"user_id"];
    usersData.userName = [obj objectForKey:@"user_name"];
    usersData.userIcon = [obj objectForKey:@"user_icon"];
    [_userDataManager addUserData:usersData];
//    LOG(@"%s user_id %@",__func__, usersData.userId);
//    LOG(@"%s user_name %@",__func__, usersData.userName);
//    LOG(@"%s user_icon %@",__func__, usersData.userIcon);
  }
  [self setUsersData];
}

- (void)setUsersData {
//  LOG_METHOD;
  _list = nil;
  _list = [NSMutableArray array];
  NSArray *existList = [_userDataManager getUserRowData];
  for (YUserListData *article in existList) {
    [_list addObject:article];
//    LOG(@"YamadaTest:article:userId %@", article.userId);
//    LOG(@"YamadaTest:article:userId %@", article.followStatus);
  }
  [hud hide:YES];
  [_tableView reloadData];
}

- (void)followingDataUpdateFinish {
  LOG_METHOD;
//  [hud hide:YES];
//  [_tableView reloadData];
  [self dataReset];
  [self viewWillAppear:YES];
}

- (void)setIndicator {
  hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden {
  // Remove HUD from screen when the HUD was hidded
  [hud removeFromSuperview];
}

- (void)addUserListRow {
  LOG_METHOD;
  _page++;
  LOG(@"YamadaTest:page %d", _page);
  [self runAPI];
}

- (void)dataReset {
  LOG_METHOD
  [_userDataManager deleteUserList];
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
  LOG_METHOD;
  
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  LOG(@"%s listcount:%d",__func__, _list.count);
  NSInteger base = _page * ONCE_READ_COUNT;
  cnt = _list.count;
  if (cnt == base) {
    return cnt+1;
  }
  return cnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row != cnt) {
//    LOG(@"%s nomalcell", __func__);
    YUserListData *rowData = [self.list objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"NormalCell";
    YUserListRowCell *cell = (YUserListRowCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[YUserListRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupRowData:rowData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  } else {
//    LOG(@"%s nextcell", __func__);
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LOG_METHOD;
  
  // タップされたcellの判別
  int hoge = self.list.count;
  if (indexPath.section == 0){
    if (indexPath.row == hoge) {
      LOG(@"YamadaTest:nextcell tap");
      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//  [self startIndicator];
      [_sharedUserListData setUserListCount:10];
      [self addUserListRow];
      [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
  }
}

@end
