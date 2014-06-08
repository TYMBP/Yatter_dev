//
//  YUtil.m
//  Yatter
//
//  Created by TomohikoYamada on 13/09/18.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import "YUtil.h"

@implementation YUtil


//短縮URL
+ (NSString *)getShortUrl:(NSString *)name {
  LOG_METHOD;
  NSString *baseUrl = IMAGE_URL;
  NSString *img = [name stringByAppendingString:@".jpg"];
  NSString *imagePath = [baseUrl stringByAppendingString:img];
  LOG(@"imagePath:%@",imagePath);
//  NSURL* imageUrl = [NSURL URLWithString:imagePath];
  NSString *userName = @"o_2e5efhtlbd";
  NSString *apiKey = @"R_ad26e2ac923b1656bfe25d556a3c53f3";
  NSString *escaped = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,(__bridge CFStringRef)imagePath, NULL,(__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?&login=%@&apiKey=%@&longUrl=%@", userName, apiKey, escaped]];
  NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
  LOG(@"result:%@",result);
  NSData *jsonData = [result dataUsingEncoding:NSUnicodeStringEncoding];

  NSError *error = nil;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
//  NSDictionary *dic = [result JSONValue];
  if ([[dic objectForKey:@"status_code"] intValue] == 200) {
    LOG(@"dic;%@",[[dic objectForKey:@"data"] objectForKey:@"url"]);
    return [[dic objectForKey:@"data"] objectForKey:@"url"];
  }
  return nil;
}

@end
