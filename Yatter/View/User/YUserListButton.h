//
//  YUserListButton.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/10/12.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YUserListButton : UIButton

@property (nonatomic, readwrite) NSUInteger section;
@property (nonatomic, readwrite) NSInteger row;

@end
