//
//  YImageViewController.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/06/25.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YImageViewController.h"

@interface YImageViewController ()

@end

@implementation YImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

  if (self) {
      self.title = @"Camera";
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self openPicker:UIImagePickerControllerSourceTypeCamera];
//  self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:0.6];
//  self.view.backgroundColor = [UIColor whiteColor];
//  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, self.view.bounds.size.width, 20)];
//  label.text = @"Camera";
//  label.textColor = [UIColor blackColor];
//  label.backgroundColor = [UIColor clearColor];
//  label.textAlignment = NSTextAlignmentCenter;
//  [self.view addSubview:label];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self openPicker:UIImagePickerControllerSourceTypeCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegater

- (void)openPicker:(UIImagePickerControllerSourceType)sourceType {
  if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
    [self ShowAlert:@"" text:@"利用できません"];
  }
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.sourceType = sourceType;
  picker.delegate = self;
//  [picker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
  [self presentViewController:picker animated:NO completion:nil];
}

- (void)ShowAlert:(NSString *)title text:(NSString *)text {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  LOG_METHOD;
  [self.delegate close];
  [self dismissViewControllerAnimated:YES completion:nil];
  
//  YTweetPostViewController *newPost = [[YTweetPostViewController alloc] init];
//  newPost.delegate = self;
//  newPost.title = @"つぶやき";
//  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:newPost];
//  [self.navigationController presentViewController:navi animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  LOG_METHOD;
  [self.delegate close];
  [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
