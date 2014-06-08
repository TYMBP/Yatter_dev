//
//  YAccountData.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/09/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YAccountData : NSManagedObject

@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSString * accountSummary;
@property (nonatomic, retain) NSString * accountIcon;
@property (nonatomic, assign) NSNumber *accountID;

@end
