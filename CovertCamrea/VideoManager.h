//
//  VideoManager.h
//  CovertCamrea
//
//  Created by LiChao Jun on 15/8/28.
//  Copyright (c) 2015年 LiChao Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface VideoManager : NSObject
{
    NSString *_recordPath;
}

@property(nonatomic, strong) NSMutableArray *recordVideos;

_SHARED(VideoManager)

- (void)addVideo:(NSString*)videoPath;
- (void)deleteVideo:(NSString*)videoPath;

@end
