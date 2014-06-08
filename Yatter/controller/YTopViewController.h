//
//  YTopViewController.h
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YRootViewController.h"
#import "YTweetPostViewController.h"
#import "YTweetRowDataManager.h"
#import "YTweetImageWebView.h"
#import "YUpdateFollowingStatus.h"

@interface YTopViewController : YRootViewController <UITableViewDataSource, UITableViewDelegate, YTweetPostViewControllerDelegate, YTweetImageWevViewDelegate> {
}

@property (nonatomic, strong) YTweetRowDataManager *data;
@property (nonatomic, strong) YTableViewRowData *baserow;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic) BOOL isAscending;
@property (nonatomic, strong) NSArray *contents;
@property (readwrite) NSInteger page;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong, readonly) YUpdateFollowingStatus *updateFollowStatus;

- (void)newTweet:(id)sender;

@end


