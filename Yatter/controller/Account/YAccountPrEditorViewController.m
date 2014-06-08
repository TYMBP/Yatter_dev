//
//  YAccountPrEditorViewController.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/15.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YAccountPrEditorViewController.h"

@implementation YAccountPrEditorViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
      _accountData = [YAccountDataManager sharedManager];
      _accountSharedData = [YAccountEditorShareData sharedManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  //アカウントデータを取得
  _userInfo = [_accountSharedData getData];
//  //coredataからユーザーデータを取得
//    NSArray *returnData = [_accountData createFetchRequest];
//    YAccountData *model = [returnData objectAtIndex:0];
//    _userInfo = [NSMutableArray arrayWithObjects:[model valueForKey:@"accountName"],[model valueForKey:@"accountSummary"], nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *rowData = [_userInfo objectAtIndex:1];
  static NSString *cellIdentifier = @"Cell";
  YAccountPrEditorCell *cell = (YAccountPrEditorCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[YAccountPrEditorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  [cell setUpRowData:rowData rowIndexPath:1];
    
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
  CGSize size;
  size.height = 150;
  
  return size.height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
