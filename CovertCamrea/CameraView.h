//
//  CameraView.h
//  CovertCamrea
//
//  Created by LiChao Jun on 15/8/28.
//  Copyright (c) 2015年 LiChao Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CameraViewDelegate <NSObject>

- (void)onRecordStart;
- (void)onRecordFinish;
- (void)onCameraSwitch:(AVCaptureDevicePosition)position;

@end

@interface CameraView : UIView
{
    AVCaptureSession *_session;
    AVCaptureMovieFileOutput *_movieOutput;
    AVCaptureVideoPreviewLayer *_previewLayer;
}

@property(nonatomic, readonly) BOOL isRecording;
@property(nonatomic, assign) id<CameraViewDelegate> delegate;

- (void)changeRecordStatus;
- (void)switchCamera;


@end
