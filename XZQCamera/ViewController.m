//
//  ViewController.m
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/1.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XZQCameraView.h"
#import "XZQCameraControl.h"
#import "XZQCameraModeView.h"

@interface ViewController ()<XZQPreviewViewDelegate>

@property(nonatomic,assign) XZQCameraMode cameraMode;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) XZQCameraControl *cameraControl;
@property(nonatomic,strong) XZQCameraView *cameraView;
@property(nonatomic,strong) UIButton *thumbnailBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraView = [[XZQCameraView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.cameraView];
    
    self.cameraMode = XZQCameraModeVideo;
    self.cameraControl = [[XZQCameraControl alloc] init];
    
    NSError *error;
    if ([self.cameraControl setupSession:&error]) {
        [self.cameraView.previewView setSession:self.cameraControl.captureSession];
        self.cameraView.previewView.delegate = self;
        [self.cameraControl startSession];
    } else {
        NSLog(@"出错了 - %@", [error localizedDescription]);
    }
    
    self.cameraView.previewView.tapToFocusEnabled = self.cameraControl.cameraSupportsTapToFocus;
    self.cameraView.previewView.tapToExposeEnabled = self.cameraControl.cameraSupportsTapToExpose;
    
    [self.cameraView.overlayView.statusView.switchCameraBtn addTarget:self action:@selector(swapCameras) forControlEvents:UIControlEventTouchUpInside];
}

- (void)swapCameras {
    NSLog(@"come");
    if ([self.cameraControl switchCameras]) {
        BOOL hidden = NO;
        if (self.cameraMode == XZQCameraModePhoto) {
            hidden = !self.cameraControl.cameraHasFlash;
        } else {
            hidden = !self.cameraControl.cameraHasTorch;
        }
        self.cameraView.overlayView.flashControlHidden = hidden;
        self.cameraView.previewView.tapToExposeEnabled = self.cameraControl.cameraSupportsTapToExpose;
        self.cameraView.previewView.tapToFocusEnabled = self.cameraControl.cameraSupportsTapToFocus;
        [self.cameraControl resetFocusAndExposureModes];
    }
}

/**
 聚焦
 */
- (void)tappedToFocusAtPoint:(CGPoint)point {
    
}

/**
 曝光
 */
- (void)tappedToExposeAtPoint:(CGPoint)point {
    
}

/**
 聚焦与曝光
 */
- (void)tappedToResetFocusAndExpose {
    
}

@end
