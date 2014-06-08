//
//  YImageURL.h
//  Yatter
//
//  Created by TomohikoYamada on 13/08/12.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YImageURL : NSObject

+ (id)imageUrlManager;

- (void)setUrl:(id)object forKey:(id)key;
- (id)getUrlForKey:(id)obj;
- (void)removeUrlForKey:(id)key;

@end
