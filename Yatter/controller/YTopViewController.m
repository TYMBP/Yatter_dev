//
//  YTopViewController.m
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTopViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "YAccountDataManager.h"
#import "YSharedRowData.h"
#import "YSharedData.h"
#import "YTableViewRowDataCell.h"
#import "YTweetRowDataCell.h"
#import "YTweetRowData.h"
#import "YImageURL.h"
#import "MBProgressHUD.h"

#define ONCE_READ_COUNT 10

@implementation YTopViewController {
  YAccountDataManager *_accountData;
  YSharedRowData *_sharedRowData;
  YSharedData *_sharedData;
  YTweetRowDataCell *_tweetCellForHeight;
  YImageURL *_imageURL;
  MBProgressHUD *_hud;
  UITableViewCell *_nextCell;
  UITableView *_tableView;
  NSArray *_rows;
  NSMutableArray *_tweet;
  UIView *loadingView;
  UIActivityIndicatorView *_indicator;
  NSMutableData *_asyncData;
  NSURLConnection *_conn;
  UIRefreshControl *_refreshControl;
  NSInteger n;
  NSInteger cnt;
  BOOL loginState;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  LOG_METHOD;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = @"Top";
      self.isAscending = YES;
      n = 0;
      _sharedRowData = [YSharedRowData sharedManaber];
      _sharedData = [YSharedData sharedManager];
      _imageURL = [YImageURL imageUrlManager];
      _data = [[YTweetRowDataManager alloc] init];
      _accountData = [YAccountDataManager sharedManager];
      _updateFollowStatus = [YUpdateFollowingStatus sharedManager];
    }
    return self;
}

- (void)viewDidLoad {
  LOG_METHOD;
  [super viewDidLoad];
  
  UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView = tableView;
  _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  _tableView.separatorColor = [UIColor clearColor];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [self.view addSubview:_tableView];
  
  //プルリフレッシュ
  _refreshControl = [[UIRefreshControl alloc] init];
  [_refreshControl addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
  [tableView addSubview:_refreshControl];
  //プルリフレッシュタイトル
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[UIColor grayColor] forKey:NSBackgroundColorAttributeName];
  [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//  NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"更新中" attributes:attributes];
//  _refreshControl.attributedTitle = title;
  
  //cell表示数設定
  _page = 1;
  
  //navigationbar　カラー
//  self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.3];
  self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.96 blue:0.81 alpha:1.0];
  //navigationbar button追加
  UIBarButtonItem *newPost = [[UIBarButtonItem alloc] initWithTitle:@"new" style:UIBarButtonItemStyleBordered target:self action:@selector(newTweet:)];
  self.navigationItem.rightBarButtonItem = newPost;

  //URLタップ時に通知
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(tweetImageWebView:) name:@"tweetImage" object:nil];
  //pullrefrsh更新時通知
  [nc addObserver:self selector:@selector(refreshFinish) name:@"refreshControl" object:nil];
  //cell追加
  [nc addObserver:self selector:@selector(setTweetCell) name:@"addTweetCell" object:nil];
  
}

- (void)viewWillAppear:(BOOL)animated {
  LOG_METHOD;
  NSNumber *state = [_updateFollowStatus getFollowStatusForKey:@"followStatus"];
  BOOL test = [state boolValue];
  LOG(@"YamadaTest:state %d", test);
  if (test == YES) {
    [self updateIndicator];
    [self pullRefresh];
    [_updateFollowStatus setFollwStatus:[NSNumber numberWithBool:NO] forkey:@"followStatus"];
  }
  [self setTweetCell];
}

- (UIView *)makeView:(CGRect)rect {
  UIView *uv = [[UIView alloc] init];
  uv.backgroundColor = [UIColor whiteColor];
  uv.layer.cornerRadius = 5;
  [uv setFrame:rect];
  return uv;
}

- (void)pullRefresh {
  LOG_METHOD;
  _page = 1;
  [_data refreshTweetData:_tweet.count];
  [self endRefresh];
}

- (void)endRefresh {
  LOG_METHOD;
  [_refreshControl endRefreshing];
}

- (void)startIndicator {
  LOG_METHOD;
  [_indicator startAnimating];
  CGRect pos = CGRectMake(self.view.bounds.size.width/2, 450, 32, 32);
  [_indicator setFrame:pos];
}

- (void)endIndicator {
  LOG_METHOD;
  [_indicator stopAnimating];
}

- (void)addTweetRow {
  LOG_METHOD;
  _page++;
//  [self endIndicator];
  [_data getTweetData];
}

- (void)setTweetCell {
  LOG_METHOD;
  _tweetCellForHeight = [[YTweetRowDataCell alloc] initWithFrame:CGRectZero];
  _tweet = [NSMutableArray arrayWithCapacity:0];

  NSArray *existMemo = [_data getTweetRowData];
  for (YTweetRowData *article in existMemo) {
    [_tweet addObject:article];
  }
  LOG(@"_tweet:%d",_tweet.count);
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [self endIndicator];
  [_tableView reloadData];
}

//follow update indicator
- (void)updateIndicator {
  LOG_METHOD;
  _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden {
  // Remove HUD from screen when the HUD was hidded
  [_hud removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  LOG_METHOD;
  [_hud hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  LOG_METHOD;
  NSInteger base = _page * ONCE_READ_COUNT;
  cnt = _tweet.count;
  LOG(@"%s %d",__func__, _tweet.count);
  LOG(@"%s %d",__func__, cnt);
  if (base == cnt) {
    return cnt+1;
  }
  return cnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LOG(@"cellForRow index.row %d",indexPath.row);
  if (indexPath.row != cnt) {
    LOG(@"normal cell");
    YTweetRowData *rowData = [_tweet objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"NormalCell";
    YTweetRowDataCell *cell = (YTweetRowDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[YTweetRowDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupRowData:rowData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  } else {
    LOG(@"next");
    static NSString *CellIdentifier = @"NextCell";
    _nextCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_nextCell == nil) {
      _nextCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
  if (indexPath.row != cnt) {
    YTweetRowData *row = [_tweet objectAtIndex:indexPath.row];
    [_tweetCellForHeight setupRowData:row];

    NSString *str = row.imgName;
    LOG(@"image check:%@ %d", str, str.length);
    if (str != NULL) {
      CGSize size;
      size.width = _tableView.frame.size.width;
      size.height = YMAX_CELL_HEIGHT;
      size = [_tweetCellForHeight sizeThatFits:size];
      LOG(@"%f",size.height);
      return size.height;
    } else {

      CGSize size;
      size.width = _tableView.frame.size.width;
      size.height = YMAX_CELL_HEIGHT;
      size = [_tweetCellForHeight sizeThatFits2:size];
      LOG(@"%f",size.height);
      return size.height;
    }
  } else {
    CGSize size;
    size.height = 40;
    return size.height;
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LOG_METHOD;
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  [_indicator startAnimating];
  [_sharedRowData setData:10];
  [self addTweetRow];
  [_sharedData setLoginState:[NSNumber numberWithBool:YES] forkey:@"loginStatus"];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private methods

- (void)newTweet:(id)sender {
  YTweetPostViewController *newPost = [[YTweetPostViewController alloc] init];
  newPost.delegate = self;
  newPost.title = @"つぶやき";
  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:newPost];
  
  [self.navigationController presentViewController:navi animated:YES completion:NULL];
  
}

- (void)addTweetDidFinish:(YTweetPostData *)newTweet {
  LOG_METHOD;
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)tweetImageWebView:(NSNotification *)center {
  LOG_METHOD;
  NSString *value = [[center userInfo] objectForKey:@"KEY"];
  LOG(@"value:%@", value);
  [_imageURL setUrl:[NSString stringWithString:value] forKey:@"URL"];
  YTweetImageWebView *web = [[YTweetImageWebView alloc] init];
  web.tweetImageDelegate = self;
  [self presentViewController:web animated:YES completion:nil];
  
}

- (void)tweetImageClose {
  [self dismissViewControllerAnimated:YES completion:nil];
}


@end
