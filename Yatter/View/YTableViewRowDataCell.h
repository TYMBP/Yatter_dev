//
//  YTableViewRowDataCell.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/07/07.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YTableViewRowData.h"

@interface YTableViewRowDataCell : UITableViewCell

- (void)setupRowData:(YTableViewRowData *)rowData;

@end
