//
//  YAccountEditorShareData.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/15.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAccountEditorShareData : NSObject

+ (id)sharedManager;
- (void)setData:(NSMutableArray *)array;
- (void)refreshData:(NSString *)str key:(NSInteger)key;
- (NSMutableArray *)getData;

@end
