//
//  YTweetRowData.m
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/07/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YTweetRowData.h"
#import "YTweetRowDataCell.h"

@implementation YTweetRowData

+ (NSString *)cellIdentifier {
  return @"tweetRowData";
}

+ (Class)cellClass {
  return [YTweetRowDataCell class];
}

@end
