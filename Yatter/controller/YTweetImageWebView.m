//
//  YTweetImageWebView.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/08/11.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTweetImageWebView.h"
#import "YImageURL.h"

@interface YTweetImageWebView ()

@end

@implementation YTweetImageWebView {
  YImageURL *urlPath;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      LOG_METHOD;
      urlPath = [YImageURL imageUrlManager];
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  
  NSString *imageUrl = [urlPath getUrlForKey:@"URL"];
  LOG_METHOD;
  LOG(@"t imageUrl:%@", imageUrl);
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
  label.backgroundColor = [UIColor clearColor];
  label.userInteractionEnabled = YES;
  
  _webView = [[UIWebView alloc] init];
  _webView.delegate = self;
  _webView.frame = self.view.bounds;
  _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _webView.scalesPageToFit = YES;
  [self.view addSubview:_webView];
  [self.view addSubview:label];
  NSURLRequest *request  =[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
//  NSURLRequest *request  =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yamato.main.jp/app/yatter_api/images/20130727160913.jpg"]];
  
  self.view.userInteractionEnabled = YES;
  [_webView loadRequest:request];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  LOG_METHOD;
  [self.tweetImageDelegate tweetImageClose];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
