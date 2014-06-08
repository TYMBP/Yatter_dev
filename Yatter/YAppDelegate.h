//
//  YAppDelegate.h
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YApplication.h"

@class YDeckViewController;
@class YSharedRowData;
@class YSharedData;
@class YUpdateFollowingStatus;

@interface YAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) YDeckViewController *viewController;
@property (strong, readonly, nonatomic) YApplication *application;
@property (nonatomic, strong, readonly) YSharedRowData *sharedRowData;
@property (nonatomic, strong, readonly) YSharedData *sharedData;
@property (nonatomic, strong, readonly) YUpdateFollowingStatus *updateFollowStatus;

@end
