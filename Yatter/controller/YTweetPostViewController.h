//
//  YTweetPostViewController.h
//  Yatter
//
//  Created by tomohiko on 2013/07/13.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAccountEditorShareData.h"
#import "YAccountDataManager.h"

@class YTweetPostData;

@protocol YTweetPostViewControllerDelegate;

@interface YTweetPostViewController : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
  UITextView *_body;
  NSString *_uploadFileName;
  UIView *_contextMenu;
  UIImageView *_cameraIcon;
  UIImageView *_imageView;
  UIImage *_picture;
  UIButton *_btnCamera;
  UIButton *_btnLibrary;
  UIImageView *_remove;
  UIActivityIndicatorView *_indicator;
  BOOL _registered;
  YAccountEditorShareData *_accountSharedData;
  YAccountDataManager *_accountData;
}

@property (weak, nonatomic) id<YTweetPostViewControllerDelegate> delegate;
@property (strong, nonatomic)UIImageView *pictureImage;

- (void)done:(id)sender;
- (void)cancel:(id)sender;
//- (void)bodyEditingChanged:(id)sender;
- (void)checkDone;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)clickButton:(UIButton *)sender;
- (UIButton *)makeButton:(CGRect)rect text:(NSString *)text tag:(int)tag;

@end

@protocol YTweetPostViewControllerDelegate <NSObject>

- (void)addTweetDidFinish:(YTweetPostData *)newTweet;
//- (void)addTweetDidFinish;

@end

