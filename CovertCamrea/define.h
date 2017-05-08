//
//  define.h
//  CovertCamrea
//
//  Created by LiChao Jun on 15/8/28.
//  Copyright (c) 2015年 LiChao Jun. All rights reserved.
//

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define _SHARED(className) \
+ (className*)shared##className;

#define SHARED(className) \
static className *s_##className = nil; \
+ (className*)shared##className \
{ \
    if (!s_##className) { \
        s_##className = [[className alloc] init]; \
    } \
    return s_##className; \
}

#define FILEPATH(name) [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), name]