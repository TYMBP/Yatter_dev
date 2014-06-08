//
//  YTweetPostViewController.m
//  Yatter
//
//  Created by tomohiko on 2013/07/13.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTweetPostViewController.h"
#import "YTweetRowDataManager.h"
#import "YAccountData.h"

#define BTN_CAMERA 0
#define BTN_READ 1
#define BTN_WRITE 2

#define UPLOAD_PARAM @"upload_file"
#define UPLOAD_URL @"http://yamato.main.jp/app/yatter_api/statusAction.php"
//#define UPLOAD_URL @"http://localhost/PDT/api/statusAction.php"

@implementation YTweetPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _accountData = [YAccountDataManager sharedManager];
      _accountSharedData = [YAccountEditorShareData sharedManager];
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //coredataからユーザーデータを取得
  NSArray *getData = [_accountData createFetchRequest];
  YAccountData *model = [getData objectAtIndex:0];
  NSMutableArray *userInfo = [NSMutableArray arrayWithObjects:[model valueForKey:@"accountName"],[model valueForKey:@"accountSummary"],[model valueForKey:@"accountIcon"],[model valueForKey:@"accountID"], nil];
  LOG(@"userInfo %@", userInfo);
  [_accountSharedData setData:userInfo];
  
  self.pictureImage = [[UIImageView alloc] init];
  self.view.backgroundColor = [UIColor whiteColor];
  //投稿ボタン
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
  [doneButton setEnabled:NO];
  self.navigationItem.rightBarButtonItem = doneButton;
  //キャンセルボタン
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.85 green:0.96 blue:0.81 alpha:1.0];
//  self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.3];
  
  _body = [[UITextView alloc] initWithFrame:CGRectMake(10,0,300,200)];
  _body.backgroundColor = [UIColor clearColor];
  _body.font = [UIFont systemFontOfSize:18];
  _body.editable = YES;
// [_body scrollRangeToVisible:NSMakeRange(0, 1)];
  [self.view addSubview:_body];
  _body.delegate = self;
  [_body becomeFirstResponder];
  
  _contextMenu = [[UIView alloc] initWithFrame:CGRectMake(0, _body.frame.origin.y + _body.frame.size.height, 320, 50)];
  _contextMenu.backgroundColor = [UIColor colorWithRed:0.56 green:0.74 blue:0.56 alpha:0.3];
  [self.view addSubview:_contextMenu];
  
  _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
  _indicator.center = self.view.center;
  _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
  [_body addSubview:_indicator];
  [_indicator stopAnimating];
  
  UIImage *image = [UIImage imageNamed:@"camera.png"];
  _cameraIcon = [[UIImageView alloc] initWithImage:image];
  _cameraIcon.frame = CGRectMake(15, 15, 26, 26);
  [_contextMenu addSubview:_cameraIcon];
  _cameraIcon.userInteractionEnabled = YES;
  
  if (!_registered) {
    NSNotificationCenter *center;
    center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _registered = YES;
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (!_registered) {
    NSNotificationCenter *center;
    center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _registered = YES;
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  if (_registered) {
    NSNotificationCenter *center;
    center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView {
  [self checkDone];
}

#pragma mark - UITextFieldDelegate methods

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//  [textField resignFirstResponder];
//  return YES;
//}

#pragma mark - Private methods

- (void)checkDone {
  self.navigationItem.rightBarButtonItem.enabled = (_body.text.length > 0);
}

- (void)cancel:(id)sender {
  LOG_METHOD;
  [self.delegate addTweetDidFinish:nil];
}

- (void)done:(id)sender {
  LOG_METHOD;
  [_indicator startAnimating];
  LOG(@"pictureImage:%@",self.pictureImage.image);
  NSMutableArray *acData = [_accountSharedData getData];
  NSNumber *userID = [acData objectAtIndex:3];
  LOG(@"userID %@", userID);
  _uploadFileName = NULL;
  
  if (self.pictureImage.image != NULL) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    _uploadFileName = [dateFormatter stringFromDate:[NSDate date]];
    LOG(@"uploadFileName:%@",_uploadFileName);
  }
  
  
  NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(self.pictureImage.image, 0.5)];
  
  NSString *boundary = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
 
  //130725
  NSMutableData *body = [[NSMutableData alloc] init];
  
//  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[@"Content-Disposition: form-data; name=\"json\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[@"Content-Type: application/json; charset=UTF-8\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[@"Content-Transfer-Encoding: 8bit\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
 
  NSString *text = [NSString stringWithString:_body.text];
  
  //0812 改行エラーのため、json変更
  NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
  [mutableDic setValue:text forKey:@"tweet_text"];
  [mutableDic setValue:_uploadFileName forKey:@"image_name"];
  [mutableDic setObject:userID forKey:@"user_id"];
  //userIDを動的に修正
//  [mutableDic setValue:@"2" forKey:@"user_id"];
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
  NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  //0812
  
//  //request JSON
//  NSInteger num = 1;
//  NSString *bodyString = [NSString stringWithFormat:@"{\"tweet_text\":\"%@\",\"image_name\":\"%@\",\"user_id\":\"%d\"}", text, _uploadFileName, num];

  [body appendData:[[NSString stringWithFormat:@"%@\r\n", bodyString] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  NSString *str = @"\r\n";
  [body appendData:[[NSString stringWithString:str] dataUsingEncoding:NSUTF8StringEncoding]];
  
  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload_file\"; filename=\"%@.jpg\"\r\n", _uploadFileName] dataUsingEncoding:NSUTF8StringEncoding]];
  NSString *str2 = @"Content-Type: image/jpeg\r\n\r\n";
  [body appendData:[[NSString stringWithString:str2] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:imageData];
  [body appendData:[[NSString stringWithString:str] dataUsingEncoding:NSASCIIStringEncoding]];
  [body appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  NSURL *url = [NSURL URLWithString:@"http://yamato.main.jp/app/yatter_api/statusAction.php"];
  
  NSDictionary *requestHeader = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d",[body length]],@"Content-Length",
                                 [NSString stringWithFormat:@"multipart/form-data,boundary=%@",boundary],@"Content-Type",nil];
  
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:10.0];
    [req setAllHTTPHeaderFields:requestHeader];
  [req setHTTPMethod:@"POST"];
  [req setHTTPBody:body];
  //130725
  
  [NSURLConnection connectionWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  LOG_METHOD;
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if (httpResponse.statusCode == 200) {
    LOG(@"%d",httpResponse.statusCode);
    [_indicator stopAnimating];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"アップロード完了" message:@"アップロード完了しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"レスポンスエラー" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
  }
  YTweetRowDataManager *rowManager = [[YTweetRowDataManager alloc] init];
  [rowManager resetTweetData];
  //0817 post時の処理
//  [self.delegate addTweetDidFinish:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  LOG_METHOD;
  NSMutableData *success = [NSMutableData data];
  [success appendData:data];
  NSString *response = [[NSString alloc] initWithData:success encoding:NSASCIIStringEncoding];
  NSLog(@"response:%@",response);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  NSLog(@"didFailWithError error:%@", error);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"ネットワークエラー" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
  [alert show];

}

- (void)keyboardWillShow:(NSNotification *)notification {
  LOG_METHOD;
  
  CGRect keyboard;
  [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboard];
  _body.frame = CGRectMake(10, 0, 300, self.view.frame.size.height - (keyboard.size.height + _contextMenu.frame.size.height));
  _contextMenu.frame = CGRectMake(0, _body.frame.origin.y + _body.frame.size.height, 320, 50);
}

- (void)keyboardWillHide:(NSNotification *)notification {
  LOG_METHOD;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  LOG_METHOD;
  if([event touchesForView:_cameraIcon] != NULL) {
    [self.view endEditing:YES];
    _btnCamera = [self makeButton:CGRectMake(50, _contextMenu.frame.origin.y + _contextMenu.frame.size.height +YTWEET_MARGIN, 220, 50) text:@"カメラ起動" tag:BTN_CAMERA];
    [self.view addSubview:_btnCamera];
    _btnLibrary = [self makeButton:CGRectMake(50, _btnCamera.frame.origin.y + _btnCamera.frame.size.height +YTWEET_MARGIN, 220, 50) text:@"ライブラリから選択" tag:BTN_READ];
    [self.view addSubview:_btnLibrary];
  } else if ([event touchesForView:_remove] != NULL) {
    _remove.hidden = YES;
    _imageView.hidden = YES;
    _btnCamera.hidden = NO;
    _btnLibrary.hidden = NO;
  }
}
- (UIButton *)makeButton:(CGRect)rect text:(NSString *)text tag:(int)tag {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setTitle:text forState:UIControlStateNormal];
  [button setFrame:rect];
  [button setTag:tag];
  [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
  return button;
}

- (UIImageView *)makeImageView:(CGRect)rect image:(UIImage *)image {
  UIImageView *imageView = [[UIImageView alloc] init];
  [imageView setFrame:rect];
  [imageView setImage:image];
  [imageView setContentMode:UIViewContentModeScaleAspectFit];
  return imageView;
}

- (void)clickButton:(UIButton *)sender {
  LOG(@"%d",sender.tag);
  if (sender.tag == BTN_CAMERA) {
    [self openPicker:UIImagePickerControllerSourceTypeCamera];
  } else if (sender.tag == BTN_READ) {
    [self openPicker:UIImagePickerControllerSourceTypePhotoLibrary];
  } else if (sender.tag == BTN_WRITE) {
    LOG(@"imagepost");
  }
}

- (void)ShowAlert:(NSString *)title text:(NSString *)text {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

// フォトライブラリ開く
- (void)openPicker:(UIImagePickerControllerSourceType)sourceType {
  if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
    [self ShowAlert:@"" text:@"利用できません"];
    return;
  }
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.sourceType = sourceType;
  picker.delegate = self;
  [self presentViewController:picker animated:YES completion:nil];
}

//　フォトライブラリ画像選択
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  _btnCamera.hidden = YES;
  _btnLibrary.hidden = YES;
  
  UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
//  UIImage *saveImage;
//  LOG(@"originalImage:%@",originalImage);
  
  self.pictureImage.image = originalImage;
  _imageView = [self makeImageView:CGRectMake(50, _contextMenu.frame.origin.y + _contextMenu.frame.size.height +YTWEET_MARGIN, 200, 200) image:originalImage];
  [self.view addSubview:_imageView];
  UIImage *removeIcon = [UIImage imageNamed:@"remove.png"];
  _remove = [self makeImageView:CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width +YTWEET_MARGIN, _contextMenu.frame.origin.y + _contextMenu.frame.size.height + YTWEET_MARGIN, 26, 26) image:removeIcon];
  [self.view addSubview:_remove];
  _remove.userInteractionEnabled = YES;
  [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


@end
