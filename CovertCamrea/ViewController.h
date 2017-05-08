//
//  ViewController.h
//  CovertCamrea
//
//  Created by LiChao Jun on 15/8/28.
//  Copyright (c) 2015年 LiChao Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraView;

@interface ViewController : UIViewController

@property(nonatomic, strong) CameraView *cameraView;
@property(nonatomic, strong) UIView *recordingMark;
@property(nonatomic, strong) UIView *cameraMark;

@property(nonatomic, strong) NSMutableArray *pass;

@end

