//
//  YAccountCreateViewController.m
//  Yatter
//
//  Created by TomohikoYamada on 13/06/24.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountCreateViewController.h"

@interface YAccountCreateViewController ()

@end

@implementation YAccountCreateViewController

- (void)viewDidLoad {
  [super viewDidLoad];
	
  LOG_METHOD;
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  self.title = @"ユーザー登録";
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
  self.navigationItem.leftBarButtonItem = cancelButton;

  _webView = [[UIWebView alloc] init];
  _webView.frame = self.view.bounds;
  _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _webView.scalesPageToFit = YES;
  [self.view addSubview:_webView];
  NSURLRequest *request  =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yamato.main.jp/app/register/index.php"]];
  
  [_webView loadRequest:request];
}

- (void)cancel:(id)sender {
  LOG_METHOD;
  [self.delegate accountCreateReturn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
