//
//  YDownloader.h
//  Yatter
//
//  Created by Tomohiko Yamada on 2013/08/08.
//  Copyright (c) 2013年 jp.main.yamato. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YDownloaderDelegate;

@interface YDownloader : NSObject

- (BOOL)get:(NSURL *)url;

@property (nonatomic, weak) id <YDownloaderDelegate> dlDelegate;
@property (nonatomic, strong) NSMutableData *buffer;
@property (nonatomic, strong) id identifier;

@end

@protocol YDownloaderDelegate <NSObject>

- (void)downloader:(NSURLConnection *)conn didLoad:(NSMutableData *)data identifier:(id)identifier;

@end