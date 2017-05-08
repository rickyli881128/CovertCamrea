//
//  ViewController.m
//  CovertCamrea
//
//  Created by LiChao Jun on 15/8/28.
//  Copyright (c) 2015年 LiChao Jun. All rights reserved.
//

#import "ViewController.h"
#import "define.h"
#import "CameraView.h"
#import "WatchViewController.h"

@interface ViewController () <CameraViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _cameraView = [[CameraView alloc] initWithFrame:self.view.bounds];
    _cameraView.delegate = self;
    [self.view addSubview:_cameraView];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = RGB(0, 0, 0);
    [self.view addSubview:maskView];
    
    _recordingMark = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-1, 1, 1)];
    _recordingMark.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_recordingMark];
    _recordingMark.hidden = YES;
    
    _cameraMark = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-1, self.view.bounds.size.height-1, 1, 1)];
    _cameraMark.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_cameraMark];
    _cameraMark.hidden = YES;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordAction:)];
    [self.view addGestureRecognizer:tapGr];
    
    UILongPressGestureRecognizer *longGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(watchAction:)];
    [self.view addGestureRecognizer:longGr];
    
//    UISwipeGestureRecognizer *swipGr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
//    [self.view addGestureRecognizer:swipGr];
    
    self.pass = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)judgePass:(BOOL)p
{
    [self.pass addObject:@(p)];
    
    if (self.pass.count > 3) {
        [self.pass removeObjectAtIndex:0];
    }
    
    if (self.pass.count < 3) {
        return NO;
    }
    
    for (NSNumber *num in self.pass) {
        if (num.integerValue == 0) {
            return NO;
        }
    }
    
    [self.pass removeAllObjects];
    return YES;
}

- (void)watchAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self judgePass:YES]) {
            WatchViewController *wvc = [[WatchViewController alloc] init];
            [self presentViewController:wvc animated:YES completion:nil];
        }
    }
}

- (void)recordAction:(UITapGestureRecognizer *)sender
{
    [self judgePass:NO];
    [_cameraView changeRecordStatus];
}

- (void)swipAction:(UISwipeGestureRecognizer*)sender
{
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionRight:
        case UISwipeGestureRecognizerDirectionLeft: {
            [_cameraView switchCamera];
        } break;
            
        case UISwipeGestureRecognizerDirectionUp: {
            
        } break;
            
        case UISwipeGestureRecognizerDirectionDown: {
            
        } break;
            
        default:
            break;
    }
}

#pragma mark - *CameraViewDelegate
- (void)onRecordStart
{
    _recordingMark.hidden = NO;
}

- (void)onRecordFinish
{
    _recordingMark.hidden = YES;
}

- (void)onCameraSwitch:(AVCaptureDevicePosition)position
{
    if (position == AVCaptureDevicePositionBack) {
        _cameraMark.hidden = NO;
    }
    else {
        _cameraMark.hidden = YES;
    }
}

@end




















