//
//  VideoManager.m
//  CovertCamrea
//
//  Created by LiChao Jun on 15/8/28.
//  Copyright (c) 2015年 LiChao Jun. All rights reserved.
//

#import "VideoManager.h"
#import "define.h"

@implementation VideoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _recordPath = FILEPATH(@"record.plist");;
        _recordVideos = [[NSMutableArray alloc] initWithContentsOfFile:_recordPath];
        if (!_recordVideos) {
            _recordVideos = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

SHARED(VideoManager)

- (void)addVideo:(NSString*)videoPath
{
    if (![_recordVideos containsObject:videoPath.lastPathComponent]) {
        [_recordVideos addObject:videoPath.lastPathComponent];
        [_recordVideos writeToFile:_recordPath atomically:YES];
    }
}

- (void)deleteVideo:(NSString*)videoPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
        [_recordVideos removeObject:videoPath.lastPathComponent];
        [_recordVideos writeToFile:_recordPath atomically:YES];
    }
}

@end








