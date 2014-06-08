//
//  YAppDelegate.m
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAppDelegate.h"
#import "YDeckViewController.h"
#import "YLoginViewController.h"
#import "YSharedData.h"
#import "YSharedRowData.h"
#import "YUpdateFollowingStatus.h"

@implementation YAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  _application = [[YApplication alloc] init];
  _sharedRowData = [YSharedRowData sharedManaber];
  _sharedData = [YSharedData sharedManager];
  _updateFollowStatus = [YUpdateFollowingStatus sharedManager];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.viewController = [[YDeckViewController alloc] init];
  self.window.rootViewController = self.viewController;
  [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
