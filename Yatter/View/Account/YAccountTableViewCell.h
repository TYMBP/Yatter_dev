//
//  YAccountTableViewCell.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/14.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YAccountData.h"

@interface YAccountTableViewCell : UITableViewCell

- (void)setUpRowData:(NSString *)rowdata rowIndexPath:(NSInteger)row;

@end
