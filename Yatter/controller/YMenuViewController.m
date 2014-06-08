//
//  YMenuViewController.m
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YMenuViewController.h"
#import "YSharedData.h"


@interface YMenuViewController () {
  YSharedData *shareData;
}
@end

@implementation YMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _menuTitles = [NSMutableArray arrayWithCapacity:0];
      [_menuTitles addObject:@"Top"];
      [_menuTitles addObject:@"Account"];
      [_menuTitles addObject:@"MyTweet"];
      [_menuTitles addObject:@"Follow"];
      [_menuTitles addObject:@"Follower"];
      [_menuTitles addObject:@"UserList"];
      [_menuTitles addObject:@"Logout"];
      shareData = [YSharedData sharedManager];
      
      for (int i=0; i<10; i++) {
        [_menuTitles addObject:@""];
      }
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView = tableView;
  _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.userInteractionEnabled = NO;
  
  // 1221追加 iOS7
  self.view.backgroundColor = [UIColor whiteColor];
  CGRect window = [[UIScreen mainScreen] bounds];
  _tableView.frame = CGRectMake(0, 20, window.size.width, window.size.height);
  
  [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self selector:@selector(notificationWillOpenMenu:) name:NotificationNameWillOpenMenu object:nil];
  [notificationCenter addObserver:self selector:@selector(notificationWillCloseMenu:) name:NotificationNameWillCloseMenu object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIndentifier = @"cell";
  UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIndentifier];
  if (cell==nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
  }
  NSString *title = [_menuTitles objectAtIndex:indexPath.row];
  cell.textLabel.text = title;
  return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LOG(@"indexPaht.row: %d",indexPath.row);
  
  if (indexPath.row == 6) {
    [shareData setData:[NSNumber numberWithBool:NO] forkey:@"loginFlag"];
//    [shareData setLoginState:[NSNumber numberWithBool:NO] forkey:@"loginStatus"];
    [_delegate menuViewController:self didSelectMenuItem:0];
    
  }
  [_delegate menuViewController:self didSelectMenuItem:indexPath.row];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSNotification

- (void)notificationWillOpenMenu:(NSNotification *)notification {
  _tableView.userInteractionEnabled = YES;
}

- (void)notificationWillCloseMenu:(NSNotification *)notification {
  _tableView.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
