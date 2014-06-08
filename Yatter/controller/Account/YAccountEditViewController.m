//
//  YAccountEditViewController.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountEditViewController.h"
#import "YAccountNameEditorViewController.h"
#import "YAccountPrEditorViewController.h"

@implementation YAccountEditViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.title = @"編集";
    _accountData = [YAccountDataManager sharedManager];
    _accountSharedData = [YAccountEditorShareData sharedManager];
    _picture = [[UIImage alloc] init];
    _statusData = [[NSMutableData alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  LOG_METHOD;
  [super viewDidLoad];
  
  //coredataからユーザーデータを取得
  NSArray *returnData = [_accountData createFetchRequest];
  YAccountData *model = [returnData objectAtIndex:0];
  _userInfo = [NSMutableArray arrayWithObjects:[model valueForKey:@"accountName"],[model valueForKey:@"accountSummary"],[model valueForKey:@"accountIcon"],[model valueForKey:@"accountID"], nil];
  LOG(@"userInfo %@", _userInfo);
  [_accountSharedData setData:_userInfo];
  
  //navigationbar button追加
  UIBarButtonItem *update = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(validationCheck)];
  self.navigationItem.rightBarButtonItem = update;
//  self.navigationItem.rightBarButtonItem.enabled = NO;
  
  //セルアイコン用イメージ
//  NSData *path = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://yamato.main.jp/app/yatter_api/account_data/icon/rino.jpg"]];
//  _iconImage.image = [[UIImage alloc] initWithData:path];
//  _picture = [UIImage imageWithData:path];
  NSString *baseUrl = ICON_URL;
  NSMutableArray *data = [_accountSharedData getData];
  NSString *iconName = [data objectAtIndex:2];
  NSString *img = [iconName stringByAppendingString:@".jpg"];
  NSString *imagePath = [baseUrl stringByAppendingString:img];
  NSData *url = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
  LOG(@"imagePath:%@",imagePath);
  _picture = [UIImage imageWithData:url];
}

- (void)viewWillAppear:(BOOL)animated {
  LOG_METHOD;
  [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
  LOG_METHOD;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  } else {
    return 2;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    static NSString *cellIdentifier = @"firstCell";
    YAccountEditViewCell *cell = (YAccountEditViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[YAccountEditViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setUpIconEditor:_picture];
    return cell;
  } else {
    NSMutableArray *data = [_accountSharedData getData];
    NSString *rowData = [data objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"secondCell";
    YAccountEditViewCell *nextCell = (YAccountEditViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nextCell == nil) {
      nextCell = [[YAccountEditViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [nextCell setUpRowData:rowData rowIndexPath:indexPath.row];

    return nextCell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
  if (indexPath.section == 0) {
    CGSize size;
    size.height = 60;
    
    return size.height;
  } else {
    return self.tableView.rowHeight;
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    LOG_METHOD;
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.delegate = self;
    [sheet addButtonWithTitle:@"写真を撮る"];
    [sheet addButtonWithTitle:@"ライブラリから選択"];
    [sheet addButtonWithTitle:@"キャンセル"];
    sheet.cancelButtonIndex = 2;
    [sheet showInView:self.view];

  } else {
    switch (indexPath.row) {
      case 0:
      {
        LOG(@"0");
        YAccountNameEditorViewController *accountNameEditor = [[YAccountNameEditorViewController alloc] init];
        [self.navigationController pushViewController:accountNameEditor animated:YES];
        break;
      }
      case 1:
      {
        LOG(@"1");
        YAccountPrEditorViewController *accountPrEditor = [[YAccountPrEditorViewController alloc] init];
        [self.navigationController pushViewController:accountPrEditor animated:YES];
//        break;
      }
      default:
        break;
    }
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  LOG_METHOD;
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    LOG(@"cancel");
  } else {
    switch (buttonIndex) {
      case 0:
        LOG(@"button:%d",buttonIndex);
        [self openPicker:UIImagePickerControllerSourceTypeCamera];
        break;
      case 1:
        LOG(@"button:%d",buttonIndex);
        [self openPicker:UIImagePickerControllerSourceTypePhotoLibrary];
        break;
      default:
        break;
    }
  }
}

- (void)showAlert:(NSString *)title text:(NSString *)text {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

- (void)openPicker:(UIImagePickerControllerSourceType)sourceType {
  LOG_METHOD;
  if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
    [self showAlert:@"" text:@"利用できません"];
    return;
  }
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  [picker setAllowsEditing:YES];
  picker.sourceType = sourceType;
  picker.delegate = self;
  [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  LOG_METHOD;
  _picture = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
  _iconImage = _picture;
  [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)validationCheck {
  NSMutableArray *accountData = [_accountSharedData getData];
  NSString *userName = [accountData objectAtIndex:0];
  
	NSRange match = [userName rangeOfString:@"^[a-zA-Z0-9]{0,30}$" options:NSRegularExpressionSearch];
	if (match.location != NSNotFound) {
		NSLog(@"Found: %@",[userName substringWithRange:match]);
    [self updateAccountData];
	} else {
		NSLog(@"Not Found");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"アカウント名は半角英数字のみ" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
	}
}


- (void)updateAccountData {
  LOG_METHOD;
  LOG(@"pictureImage:%@", _iconImage);
  NSMutableArray *accountData = [_accountSharedData getData];
  NSString *userName = [accountData objectAtIndex:0];
  NSString *summary = [accountData objectAtIndex:1];
  NSString *iconName = [accountData objectAtIndex:2];
  NSNumber *userID = [accountData objectAtIndex:3];
  
  _uploadFileName = nil;
  
  
  NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(_iconImage, 0.5)];
  NSString *boundary = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  NSMutableData *body = [[NSMutableData alloc] init];

  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[@"Content-Disposition: form-data; name=\"json\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[@"Content-Type: application/json; charset=UTF-8\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [body appendData:[@"Content-Transfer-Encoding: 8bit\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
  NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
  [mutableDic setValue:userName forKey:@"user_name"];
  [mutableDic setValue:summary forKey:@"user_summary"];
  [mutableDic setObject:userID forKey:@"id"];
  
  if (_iconImage != NULL) {
    if ([iconName isEqualToString:@"default"]) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
      NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
      _uploadFileName = [userName stringByAppendingString:dateStr];
      [mutableDic setValue:_uploadFileName forKey:@"icon_name"];
      LOG(@"uploadFileName:%@",_uploadFileName);
    } else {
      _uploadFileName = iconName;
      [mutableDic setValue:_uploadFileName forKey:@"icon_name"];
      LOG(@"uploadFileName:%@",_uploadFileName);
    }
  } else {
    LOG(@"image no change!");
  }
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDic options:kNilOptions error:&error];
  NSString *bodyString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  LOG(@"%s bodyString:%@", __func__, bodyString);
  
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

//  NSURL *url = [NSURL URLWithString:@"http://yamato.main.jp/app/yatter_api/account_data/t_accountStatusUpdate.php"];
  NSURL *url = [NSURL URLWithString:UPDATE_STATUS_API];
  
  NSDictionary *requestHeader = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d",[body length]],@"Content-Length",
                                 [NSString stringWithFormat:@"multipart/form-data,boundary=%@",boundary],@"Content-Type",nil];

  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:10.0];
  [req setAllHTTPHeaderFields:requestHeader];
  [req setHTTPMethod:@"POST"];
  [req setHTTPBody:body];
  
  [NSURLConnection connectionWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  [_statusData setLength:0];
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  if (httpResponse.statusCode == 200) {
    LOG(@"%s status:200", __func__);
  } else {
    LOG(@"%s status error",__func__);
  }
  //リセット処理をいれる
  
//  [self.delegate addTweetDidFinish:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  NSMutableData *success = [NSMutableData data];
  [success appendData:data];
  NSString *response = [[NSString alloc] initWithData:success encoding:NSASCIIStringEncoding];
  NSLog(@"response:%@",response);
  [_statusData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  LOG_METHOD;
  NSString *json_str = [[NSString alloc] initWithData:_statusData encoding:NSUTF8StringEncoding];
  NSData *data = [json_str dataUsingEncoding:NSUTF8StringEncoding];
  
  NSError *error = nil;
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
  LOG(@"%s jsonObject:%@",__func__,jsonObject);
  
//  for (NSDictionary *obj in jsonObject) {
//    NSString *castID = [obj objectForKey:@"id"];
//    int i = [castID intValue];
//    NSNumber *userID = [NSNumber numberWithInt:i];
//    NSString *user = [obj objectForKey:@"user_name"];
//    NSString *summary = [obj objectForKey:@"user_summary"];
//    LOG(@"userID:%@", userID);
//    LOG(@"username:%@", user);
//    LOG(@"summary:%@", summary);
//  }
  
  [_accountData updateData:jsonObject];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  LOG(@"didFailWithError error:%@", error);
}

@end
