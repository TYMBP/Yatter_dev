//
//  YAccountCreateViewController.h
//  Yatter
//
//  Created by TomohikoYamada on 13/06/24.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YAccountCreateViewControllerDelegate;

@interface YAccountCreateViewController : UIViewController <UIWebViewDelegate> {
  UIWebView *_webView;
  UINavigationController *_navi;
}

@property (weak, nonatomic) id <YAccountCreateViewControllerDelegate>delegate;

@end

@protocol YAccountCreateViewControllerDelegate <NSObject>

- (void)accountCreateReturn;

@end
