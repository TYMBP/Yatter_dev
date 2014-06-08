//
//  YTweetViewController.m
//  Yatter
//
//  Created by TomohikoYamada on 13/09/26.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTweetViewController.h"
#import "YApplication.h"
#import "YMyTweet.h"
#import "YMyTweetData.h"
#import "YMyTweetDataManager.h"
#import "YTweetRowCell.h"
#import "YUtil.h"
#import "YSharedRowData.h"

#define ONCE_READ_COUNT 10;

@implementation YTweetViewController {
  NSMutableArray *_tweet;
  YMyTweet *_connection;
  YMyTweetData *_myTweet;
  YMyTweetDataManager *_tweetDataManager;
  YTweetRowCell *_tweetCell;
  NSMutableArray *_result;
  NSInteger n;
  NSInteger cnt;
  UIActivityIndicatorView *_indicator;
  UITableViewCell *_nextCell;
  YSharedRowData *_sharedMyRowData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  LOG_METHOD;
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _myTweet = [[YMyTweetData alloc] init];
    _result = [[NSMutableArray alloc] init];
    _tweetDataManager = [[YMyTweetDataManager alloc] init];
    _sharedMyRowData = [YSharedRowData sharedManaber];
    n = 0;
  }
  return self;
}

- (void)viewDidLoad {
  LOG_METHOD;
  [super viewDidLoad];
  
  //セル表示用
  _page = 1;
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [self.view addSubview:_tableView];
  
  //navigationbar button追加
  UIBarButtonItem *exit = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(clickExitButton)];
  self.navigationItem.leftBarButtonItem = exit;
}

- (void)viewWillAppear:(BOOL)animated {
  LOG_METHOD;
  [super viewWillAppear:YES];
  [self runAPI];
}

- (void)startIndicator {
  LOG_METHOD;
  [_indicator startAnimating];
}

- (void)endIndicator {
  LOG_METHOD;
  [_indicator stopAnimating];
}

- (void)runAPI {
  LOG_METHOD;
  @synchronized (self) {
    _connection = [[YMyTweet alloc] initWithTarget:self selector:@selector(getMyTweetDataFinish)];
    [[YApplication application] addURLOperation:_connection];
  }
}

- (void)getMyTweetDataFinish {
  LOG_METHOD;
  NSError *error = nil;
  NSString *json_str = [[NSString alloc] initWithData:_connection.data encoding:NSUTF8StringEncoding];
  NSData *jsonData = [json_str dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
//  LOG(@"data:%@",data);
  LOG(@"%s datacount:%d",__func__, data.count);
  for (NSDictionary *obj in data) {
    _myTweet.status = [obj objectForKey:@"status"];
    _myTweet.userName = [obj objectForKey:@"user_id"];
    _myTweet.createdAt = [obj objectForKey:@"created_at"];
    _myTweet.imgName = [obj objectForKey:@"image_name"];
    LOG(@"status:%@",_myTweet.status);
    LOG(@"username:%@",_myTweet.userName);
    LOG(@"createdAt:%@",_myTweet.createdAt);
    LOG(@"imgName:%@",_myTweet.imgName);
    [_tweetDataManager addTweetData:_myTweet];
  }
  [self setTweet];
}

- (void)setTweet {
  LOG_METHOD;
  _tweet = nil;
  _tweet = [[NSMutableArray alloc] init];
  _tweetCell = [[YTweetRowCell alloc] initWithFrame:CGRectZero];
  NSArray *existMemo = [_tweetDataManager getTweetRowData];
  LOG(@"%s existMemo:%d",__func__,existMemo.count);
  for (YMyTweetData *article in existMemo) {
    [_tweet addObject:article];
  }
  LOG(@"%s _tweet count:%d",__func__, _tweet.count);
  [self endIndicator];
  [_tableView reloadData];
}

- (void)addTweetRow {
  LOG_METHOD;
  _page++;
  [self runAPI];
}

- (void)dataReset {
  LOG_METHOD
  [_tweetDataManager deleteMyTweet];
}

- (void)viewDidDisappear:(BOOL)animated {
  LOG_METHOD;
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
  LOG(@"%s %d", __func__, [_tweet count]);
  NSInteger base = _page * ONCE_READ_COUNT;
  cnt = _tweet.count;
  if (base == cnt) {
    return cnt+1;
  }
  return cnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row != cnt) {
    LOG(@"%s nomalcell", __func__);
    YMyTweetData *rowData = [_tweet objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"Cell";
    YTweetRowCell *cell = (YTweetRowCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[YTweetRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setupRowData:rowData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  } else {
    LOG(@"%s nextcell", __func__);
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
  LOG_METHOD;
  if (indexPath.row != cnt) {
  
    YMyTweetData *row = [_tweet objectAtIndex:indexPath.row];
    [_tweetCell setupRowData:row];
    
    NSString *str = row.imgName;
    LOG(@"str %@",str);
    if (str != NULL) {
      CGSize size;
      size.width = _tableView.frame.size.width;
      size.height = YMAX_CELL_HEIGHT;
      size = [_tweetCell sizeThatFits:size];
      LOG(@"heightsize %f",size.height);
      return size.height;
    } else {
      CGSize size;
      size.width = _tableView.frame.size.width;
      size.height = YMAX_CELL_HEIGHT;
      size = [_tweetCell sizeThatFits2:size];
      LOG(@"heightsize %f",size.height);
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
  [self startIndicator];
  [_sharedMyRowData setMyTweetCount:10];
  [self addTweetRow];
  [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)clickExitButton {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
