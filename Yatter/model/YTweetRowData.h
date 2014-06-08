//
//  YTweetRowData.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/07/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTableViewRowData.h"

@interface YTweetRowData : YTableViewRowData {
  __strong NSString *_username;
  __strong NSString *_status;
//  __strong NSDate *_createdAt;
  __strong NSString *_createdAt;
  __strong NSString *_imgName;
}


@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *status;
//@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSString *imgName;

@end
