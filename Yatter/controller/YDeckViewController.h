//
//  YDeckViewController.h
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "YMenuViewController.h"
#import "YTopViewController.h"
#import "YLoginViewController.h"
#import "YImageViewController.h"
#import "YAccountViewController.h"
#import "YTweetViewController.h"
#import "YFollowViewController.h"
#import "YFollowerViewController.h"
#import "YUserListViewController.h"
#import "YTweetRowDataManager.h"
#import "YSharedData.h"

@interface YDeckViewController : IIViewDeckController <YRootViewControllerDelegate, YMenuViewControllerDelegate, IIViewDeckControllerDelegate, YLoginViewControllerDelegate> {
  __strong YMenuViewController *_menuViewController;
  __strong YTopViewController *_topViewController;
  __strong YImageViewController *_imageViewController;
  __strong YAccountViewController *_accountViewController;
  __strong YTweetViewController *_tweetViewController;
  __strong YFollowViewController *_followViewController;
  __strong YFollowerViewController *_followerViewController;
  __strong YUserListViewController *_userListViewController;
  __strong YLoginViewController *_loginViewController;
  __strong UITabBarController *_tabbar;
  __strong UINavigationController *_naviController;
  __strong UINavigationController *_naviController2;
  
  BOOL loginFlag;
  YSharedData *shareData;
}

@property (strong, nonatomic) YTweetRowDataManager *tweetRowDataManager;

@end

