//
//  YDeckViewController.m
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YDeckViewController.h"

@interface YDeckViewController ()
- (void)loginViewOpen;
@end

@implementation YDeckViewController

- (id)init {
  LOG_METHOD;
  loginFlag = NO;
  
  _tweetRowDataManager = [[YTweetRowDataManager alloc] init];
  shareData = [YSharedData sharedManager];
  
  _menuViewController = [[YMenuViewController alloc] initWithNibName:nil bundle:nil];
  _menuViewController.delegate = self;
    
  _topViewController = [[YTopViewController alloc] initWithNibName:nil bundle:nil];
  _topViewController.delegate = self;
  
//  _imageViewController = [[YImageViewController alloc] initWithNibName:nil bundle:nil];
//  _imageViewController.delegate = self;
  
  _accountViewController = [[YAccountViewController alloc] initWithNibName:nil bundle:nil];
  _accountViewController.delegate = self;
 
  _tweetViewController = [[YTweetViewController alloc] initWithNibName:nil bundle:nil];
  _tweetViewController.delegate = self;
  
  _followViewController = [[YFollowViewController alloc] initWithNibName:nil bundle:nil];
  _followViewController.delegate = self;
  
  _followerViewController = [[YFollowerViewController alloc] initWithNibName:nil bundle:nil];
  _followerViewController.delegate = self;

  _userListViewController = [[YUserListViewController alloc] initWithNibName:nil bundle:nil];
  _userListViewController.delegate = self;
  
  _naviController = [[UINavigationController alloc] initWithRootViewController:_topViewController];
//  _naviController2 = [[UINavigationController alloc] initWithRootViewController:_imageViewController];
  _naviController2 = [[UINavigationController alloc] initWithRootViewController:_accountViewController];
  
  _tabbar = [[UITabBarController alloc] init];
  
  NSMutableArray *controllers = [NSMutableArray arrayWithObjects:_naviController, _naviController2, nil];

  [_tabbar setViewControllers:controllers animated:NO];
  [_tabbar setSelectedIndex:0];
  
  
  self = [super initWithCenterViewController:_tabbar leftViewController:_menuViewController];
  if (self) {
    self.delegate = self;
  }
  return self;
}


#pragma mark - MenuViewControllerDelegate

- (void)menuViewController:(YMenuViewController *)sender didSelectMenuItem:(YMenuItem)menuItem {
  UINavigationController *naviController = (UINavigationController *)self.centerController;
  
  //UIViewController *centerRootViewController = nil;
  if (menuItem == YMenuTopView) {
    LOG_METHOD;
    //centerRootViewController = _naviController;
    [naviController setViewControllers:[NSMutableArray arrayWithObjects:_naviController, _naviController2, nil]];
    [_tabbar setSelectedIndex:0];
    [self closeLeftView];
  } else if (menuItem == YMenuAccountView) {
    //centerRootViewController = _naviController2;
    [naviController setViewControllers:[NSMutableArray arrayWithObjects:_naviController, _naviController2, nil]];
    [_tabbar setSelectedIndex:1];
    LOG(@"camera test");
    [self closeLeftView];
  } else if (menuItem == YMenuTweetView) {
    _tweetViewController.title = @"MyTweet";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_tweetViewController];
    //navigationbar　カラー
    nav.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.96 blue:0.81 alpha:1.0];
//    nav.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.3];
    [self presentViewController:nav animated:YES completion:nil];
    [self closeLeftView];
  } else if (menuItem == YMenuFollowView) {
    _followViewController.title = @"Follow";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_followViewController];
    //navigationbar　カラー
    nav.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.96 blue:0.81 alpha:1.0];
//    nav.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.3];
    [self presentViewController:nav animated:YES completion:nil];
    [self closeLeftView];
  } else if (menuItem == YMenuFollowerView) {
    _followerViewController.title = @"Follower";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_followerViewController];
    //navigationbar　カラー
    nav.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.96 blue:0.81 alpha:1.0];
//    nav.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.3];
    [self presentViewController:nav animated:YES completion:nil];
    [self closeLeftView];
  } else if (menuItem == YMenuUserListView) {
    _userListViewController.title = @"UserList";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_userListViewController];
    //navigationbar カラー
    nav.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.96 blue:0.81 alpha:1.0];
//    nav.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.3];
    [self presentViewController:nav animated:YES completion:nil];
    [self closeLeftView];
  }
  
//  if (centerRootViewController) {
//    NSMutableArray *ctl = [NSMutableArray arrayWithObjects:_topViewController, _imageViewController, nil];
//  }
}

#pragma mark - RootViewControllerDelegate

- (void)centerRootViewControllerDidTapMenuButton:(YRootViewController *)sender {
  [self toggleLeftView];
}

#pragma mark IIViewControllerDelegate

- (BOOL)viewDeckControllerWillOpenLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated {
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  NSNotification *notification = [NSNotification notificationWithName:NotificationNameWillOpenMenu object:self userInfo:nil];
  [notificationCenter postNotification:notification];
  return YES;
}

- (BOOL)viewDeckControllerWillCloseLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated {
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  NSNotification *notification = [NSNotification notificationWithName:NotificationNameWillCloseMenu object:self userInfo:nil];
  [notificationCenter postNotification:notification];
  return YES;
}

#pragma mark - YRootViewControllerDelegate

- (void)close {
  LOG_METHOD;
  UINavigationController *naviController = (UINavigationController *)self.centerController;
  [naviController setViewControllers:[NSMutableArray arrayWithObjects:_naviController, _naviController2, nil]];
  [_tabbar setSelectedIndex:0];
  [self closeLeftView];
}

- (void)viewDidLoad {
  LOG_METHOD;
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
  if (loginFlag == NO) {
    LOG_METHOD;
    [self loginViewOpen];
  }
}

- (void)loginViewOpen {
  YLoginViewController *login = [[YLoginViewController alloc] init];
  UINavigationController *navigationCtr = [[UINavigationController alloc] initWithRootViewController:login];
  navigationCtr.navigationBarHidden = YES;
    
  login.delegate = self;
  [login setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
  [self presentViewController:navigationCtr animated:NO completion:nil];
}

- (void)login:(NSString *)text {
  LOG_METHOD;
  
  [_tweetRowDataManager getTweetData];
  NSNumber *num = [shareData getDataForKey:@"loginFlag"];
  loginFlag = [num boolValue];
//0729変更
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(dataReset) name:@"login" object:nil];
  [nc addObserver:self selector:@selector(loginViewClose) name:@"connectionFinish" object:nil];
  //  [self dismissViewControllerAnimated:YES completion:NULL];
//  [self loginViewClose];
}

- (void)loginViewClose {
  LOG_METHOD;
  [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dataReset {
  LOG_METHOD
  [_tweetRowDataManager deleteTweetData];
  [self loginViewOpen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
