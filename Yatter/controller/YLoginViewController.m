//
//  YLoginViewController.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/06/23.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YLoginViewController.h"
#import "YUserID.h"
#import "YDeckViewController.h"
#import "YSharedData.h"
#import "YSharedRowData.h"
#import "YAccountData.h"
#import "YAccountDataManager.h"
#import "YAccountDataResponseParser.h"
#import "YApplication.h"

#define LOGIN_FLG @"OK"
#define BTN_LOGIN 1

@interface YLoginViewController ()
//- (void)login:(id)sender; //削除
- (void)accountCreate:(id)sender;
@end

@implementation YLoginViewController {
  YSharedRowData *sharedRowData;
  YSharedData *shareData;
  YAccountDataManager *_accountData;
  YAccountDataResponseParser *_followingData;
  NSMutableData *_responseData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  LOG_METHOD;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      sharedRowData = [YSharedRowData sharedManaber];
      shareData = [YSharedData sharedManager];
      _accountData = [YAccountDataManager sharedManager];
      _responseData = [[NSMutableData alloc] init];
      _followingData = [[YAccountDataResponseParser alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
  NSLog(@"%s",__func__);
  [super viewDidLoad];

  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(getFollowDataFinish) name:@"setFollowDataFinish" object:nil];
//  [_accountData loadManagedObjectContext];
  NSString *bgImgPath = [[NSBundle mainBundle] pathForResource:@"p" ofType:@"png"];
  UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:bgImgPath]];
  [self.view addSubview:bgImg];
  
  _idTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, 300, 32)];
  [_idTextField setText:@"yamada"];
  [_idTextField setReturnKeyType:UIReturnKeyNext];
  [_idTextField setBackgroundColor:[UIColor whiteColor]];
  [_idTextField setBorderStyle:UITextBorderStyleRoundedRect];
  _idTextField.delegate = self;
  
  _pwTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 32)];
  [_pwTextField setText:@"yamada10"];
  [_pwTextField setSecureTextEntry:YES];
  [_pwTextField setReturnKeyType:UIReturnKeyDone];
  [_pwTextField setBackgroundColor:[UIColor whiteColor]];
  [_pwTextField setBorderStyle:UITextBorderStyleRoundedRect];
  _pwTextField.delegate = self;
  
  UIImage *login = [UIImage imageNamed:@"login_btn.png"];
  UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 175)/2, 250, 175, 25)];
  [loginButton setContentMode:UIViewContentModeScaleAspectFill];
  [loginButton setImage:login forState:UIControlStateNormal];
  [loginButton addTarget:self action:@selector(login2:) forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *account = [UIImage imageNamed:@"create_btn.png"];
  UIButton *createButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 175)/2, 300, 175, 25)];
  [createButton setContentMode:UIViewContentModeScaleAspectFill];
  [createButton setImage:account forState:UIControlStateNormal];
  [createButton addTarget:self action:@selector(accountCreate:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:_idTextField];
  [self.view addSubview:_pwTextField];
  [self.view addSubview:loginButton];
  [self.view addSubview:createButton];
  
}

//0911実装
- (void)login2:(id)sender {
  LOG_METHOD;
  //インジゲータースタート
  _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  _indicator.frame = CGRectMake(0, 0, 50, 50);
  _indicator.center = CGPointMake(160, 120);
  _indicator.hidesWhenStopped = YES;
  [self.view addSubview:_indicator];
  [_indicator startAnimating];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  [sharedRowData refreshData:0];
  [_pwTextField resignFirstResponder];
  
  NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
  [mutableDic setValue:_idTextField.text forKey:@"email"];
  [mutableDic setValue:_pwTextField.text forKey:@"password"];
  LOG(@"mutableDic:%@",mutableDic);
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
  NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  LOG(@"bodyString:%@",bodyString);
  NSURL *url = [NSURL URLWithString:LOGIN_URL];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];

  NSData *requestData = [NSData dataWithBytes:[bodyString UTF8String] length:[bodyString length]];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:requestData];;
  [NSURLConnection connectionWithRequest:request delegate:self];
  
}
//0911変更
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  [_responseData setLength:0];
}
//0911変更
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//  NSMutableData *success = [NSMutableData data];
//  [success appendData:data];
//  NSString *response = [[NSString alloc] initWithData:success encoding:NSASCIIStringEncoding];
//  LOG(@"response:%@",response);
  [_responseData appendData:data];
}
//0911変更
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  LOG_METHOD;
  NSString *json_str = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
  NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
//  LOG(@"data: %@", json_str);
  NSError *error = nil;
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
  LOG(@"jsonObject:%@",jsonObject);
  //coredata　アカウント登録
  [_accountData addData:jsonObject];
  
  if (jsonObject) {
    [shareData setData:[NSNumber numberWithBool:YES] forkey:@"loginFlag"];
    LOG(@"nsnumber:%@",[shareData getDataForKey:@"loginFlag"]);
    [shareData setLoginState:[NSNumber numberWithBool:NO] forkey:@"loginStatus"];
    
    //フォロワー取得
    [_followingData connectionAPI];
//    //login時デリゲート
//    [self.delegate login:nil];

  } else {
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Error";
    alert.message = @"username/passwordが違います";
    [alert addButtonWithTitle:@"確認"];
    [alert show];
  }
}

- (void)getFollowDataFinish {
  LOG_METHOD;
  //login時デリゲート
  [self.delegate login:nil];
}

- (void)accountCreate:(id)sender {
  LOG_METHOD;
  YAccountCreateViewController *webView = [[YAccountCreateViewController alloc] init];
  webView.delegate = self;
  [self.navigationController pushViewController:webView animated:YES];
  
}

- (void)accountCreateReturn {
  LOG_METHOD;
  [self.navigationController setNavigationBarHidden:YES];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
