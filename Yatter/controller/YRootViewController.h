//
//  YRootViewController.h
//  Yatter
//
//  Created by tomohiko on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRootViewControllerDelegate;

@interface YRootViewController : UIViewController {
}

@property (weak, nonatomic) id <YRootViewControllerDelegate> delegate;

@end

@protocol YRootViewControllerDelegate <NSObject>

- (void)centerRootViewControllerDidTapMenuButton:(YRootViewController *)sender;
- (void)close;

@end
