//
//  YMyTweetData.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/29.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTableViewRowData.h"

@interface YMyTweetData : YTableViewRowData

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *imgName;

@end
