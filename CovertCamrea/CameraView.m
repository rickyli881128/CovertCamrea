//
//  CameraView.m
//  CovertCamrea
//
//  Created by LiChao Jun on 15/8/28.
//  Copyright (c) 2015年 LiChao Jun. All rights reserved.
//

#import "CameraView.h"
#import "VideoManager.h"

@interface CameraView () <AVCaptureFileOutputRecordingDelegate>

@end

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.创建会话层
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        //2.创建、配置输入设备
        AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        
        int flags = NSKeyValueObservingOptionNew; //监听自动对焦
        [device addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
        
        NSError *error;
        AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!captureInput) {
        }
        [_session addInput:captureInput];
        
        //3.创建、配置输出
        _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
        [_session addOutput:_movieOutput];
        
        //设置取景
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _previewLayer.frame = self.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:_previewLayer];
        
        [_session startRunning];
    }
    return self;
}

- (void)switchCamera
{
    for (AVCaptureDeviceInput *input in _session.inputs) {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront) {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }
            else {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [_session beginConfiguration];
            
            [_session removeInput:input];
            [_session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [_session commitConfiguration];
            break;
        }
    }
}

- (AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras)
    {
        if (device.position == position) {
            [self.delegate onCameraSwitch:position];
            return device;
        }
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void)changeRecordStatus
{
    if (self.isRecording) {
        [_movieOutput stopRecording];
    }
    else {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"yyyy-MM-ddHH:mm:ss:SSS";
        NSString *fileName = [dateformatter stringFromDate:[NSDate date]];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"-" withString:@""];
        fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSURL *filUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Documents/%@.mov", NSHomeDirectory(), fileName]];
        [_movieOutput startRecordingToOutputFileURL:filUrl recordingDelegate:self];
    }
}

- (BOOL)isRecording
{
    if (!_movieOutput) {
        return NO;
    }
    return _movieOutput.isRecording;
}

#pragma mark - *AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    [self.delegate onRecordStart];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    BOOL recordedSuccessfully = YES;
    if ([error code] != noErr) {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value) {
            recordedSuccessfully = [value boolValue];
            NSLog(@"%@", value);
        }
    }
    if (recordedSuccessfully) {
        [[VideoManager sharedVideoManager] addVideo:outputFileURL.absoluteString];
        [self.delegate onRecordFinish];
    }
}

@end



















