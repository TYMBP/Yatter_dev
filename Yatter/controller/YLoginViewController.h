//
//  YLoginViewController.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAccountCreateViewController.h"

@protocol YLoginViewControllerDelegate;

@interface YLoginViewController : UIViewController <UITextFieldDelegate, YAccountCreateViewControllerDelegate> {
  UITextField *_idTextField;
  UITextField *_pwTextField;
  UINavigationController *_navi;
  UIActivityIndicatorView *_indicator;
}
@property (weak, nonatomic) id <YLoginViewControllerDelegate> delegate;

- (void)getFollowDataFinish;

@end

@protocol YLoginViewControllerDelegate <NSObject>

- (void)login:(NSString *)text;

@end