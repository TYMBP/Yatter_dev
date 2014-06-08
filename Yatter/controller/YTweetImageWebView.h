//
//  YTweetImageWebView.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/08/11.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTweetImageWevViewDelegate;

@interface YTweetImageWebView : UIViewController <UIWebViewDelegate> {
  UIWebView *_webView;
}

@property (weak, nonatomic) id <YTweetImageWevViewDelegate> tweetImageDelegate;

@end

@protocol YTweetImageWevViewDelegate <NSObject>

- (void)tweetImageWebView:(NSNotification *)center;
- (void)tweetImageClose;

@end
