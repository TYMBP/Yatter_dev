//
//  YAccountNameEditorViewController.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountNameEditorViewController.h"

@implementation YAccountNameEditorViewController

- (id)initWithStyle:(UITableViewStyle)style {
  LOG_METHOD;
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    _accountData = [YAccountDataManager sharedManager];
    _accountSharedData = [YAccountEditorShareData sharedManager];
  }
  return self;
}

- (void)viewDidLoad {
  LOG_METHOD;
  [super viewDidLoad];
  
  //アカウントデータを取得
  _userInfo = [_accountSharedData getData];
//  //coredataからユーザーデータを取得
//  NSArray *returnData = [_accountData createFetchRequest];
//  YAccountData *model = [returnData objectAtIndex:0];
//  _userInfo = [NSMutableArray arrayWithObjects:[model valueForKey:@"accountName"],[model valueForKey:@"accountSummary"], nil];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"Cell";
  NSString *rowData = [_userInfo objectAtIndex:0];
  YAccountNameEditorViewCell *cell = (YAccountNameEditorViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[YAccountNameEditorViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  [cell setUpRowData:rowData rowIndexPath:0];
  
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
