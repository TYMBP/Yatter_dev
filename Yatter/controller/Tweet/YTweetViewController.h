//
//  YTweetViewController.h
//  Yatter
//
//  Created by TomohikoYamada on 13/09/26.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YRootViewController.h"

@interface YTweetViewController : YRootViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView *_tableView;
}

@property (readwrite) NSInteger page;

@end
