//
//  YMenuViewController.h
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  YMenuTopView,
  YMenuAccountView,
  YMenuTweetView,
  YMenuFollowView,
  YMenuFollowerView,
  YMenuUserListView
}YMenuItem;

@protocol YMenuViewControllerDelegate;

@interface YMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  __strong NSMutableArray *_menuTitles;
  __weak UITableView *_tableView;
}

@property (weak, nonatomic)id <YMenuViewControllerDelegate> delegate;

@end

@protocol YMenuViewControllerDelegate <NSObject>

- (void)menuViewController:(YMenuViewController *)sender didSelectMenuItem:(YMenuItem)menuItem;

@end
