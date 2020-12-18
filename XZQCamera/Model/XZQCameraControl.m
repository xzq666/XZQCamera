//
//  XZQCameraControl.m
//  用于配置和管理不同的捕捉设备，同时也对捕捉设备的输出进行控制和交互
//
//  Created by qhzc-iMac-02 on 2020/12/1.
//

#import "XZQCameraControl.h"

@interface XZQCameraControl ()

@property(nonatomic,strong) dispatch_queue_t videoQueue;
// 这里重新定义captureSession属性，使其对内可写
@property(nonatomic,strong) AVCaptureSession *captureSession;
// 当前输入设备
@property(nonatomic,strong) AVCaptureDeviceInput *activeVedioInput;
// 输出
@property(nonatomic,strong) AVCapturePhotoOutput *imageOutput;
@property(nonatomic,strong) AVCaptureMovieFileOutput *movieOutput;
@property(nonatomic,strong) NSURL *outputURL;

@end

@implementation XZQCameraControl

/// 配置和控制捕捉会话
- (BOOL)setupSession:(NSError **)error {
    // 创建会话
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    // 创建视频捕捉设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 添加输入设备
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:error];
    if (videoInput && [self.captureSession canAddInput:videoInput]) {
        [self.captureSession addInput:videoInput];
        self.activeVedioInput = videoInput;
    } else {
        return NO;
    }
    // 创建音频捕捉设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    if (audioInput && [self.captureSession canAddInput:audioInput]) {
        [self.captureSession addInput:audioInput];
    } else {
        return NO;
    }
    // 添加输出设备
    self.imageOutput = [[AVCapturePhotoOutput alloc] init];
    [self.imageOutput setPhotoSettingsForSceneMonitoring:[AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecJPEG}]];
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    } else {
        return NO;
    }
    self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.captureSession canAddOutput:self.movieOutput]) {
        [self.captureSession addOutput:self.movieOutput];
    }
    // 初始化自定义并行队列
    self.videoQueue = dispatch_queue_create("com.xzq.VideoQueue", NULL);
    return YES;
}

/**
 启动捕捉会话
 */
- (void)startSession {
    if (![self.captureSession isRunning]) {
        // 使用异步方式避免阻塞主线程
        dispatch_async(self.videoQueue, ^{
            [self.captureSession startRunning];
        });
    }
}

/**
 停止捕捉会话
 */
- (void)stopSession; {
    if ([self.captureSession isRunning]) {
        dispatch_async(self.videoQueue, ^{
            [self.captureSession stopRunning];
        });
    }
}

/// 在不同摄像头中切换以测试摄像头的不同功能，保证用户可以在界面上进行正确选择
- (BOOL)switchCameras {
    if (![self canSwitchCameras]) {
        return NO;
    }
    NSError *error;
    AVCaptureDevice *videoDevice = [self __inactiveCamera];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        // 通过beginConfiguration和commitConfiguration方法进行单独的、原子性的变化
        [self.captureSession beginConfiguration];
        // 移除原摄像头
        [self.captureSession removeInput:self.activeVedioInput];
        // 切换成新摄像头
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVedioInput = videoInput;
        } else {
            // 无法切换则换回原摄像头
            [self.captureSession addInput:self.activeVedioInput];
        }
        [self.captureSession commitConfiguration];
    } else {
        // 进行设备配置错误代理回调
        [self.delegate deviceConfigurationFailedWithError:error];
        return NO;
    }
    return YES;
}

/**
 返回是否可以切换摄像头
 */
- (BOOL)canSwitchCameras {
    return self.cameraCount > 1;
}

/**
 返回可用视频捕捉设备的数量
 */
- (NSUInteger)cameraCount {
//    AVCaptureDeviceDiscoverySession *devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:self.activeVedioInput.device.position];
//    NSArray *devicesArray = devices.devices;
//    return devicesArray.count;
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

/**
 遍历可用的视频设备并返回position参数对应的值
 */
- (AVCaptureDevice *)__cameraWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDeviceDiscoverySession *devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    NSArray *devicesArray = devices.devices;
    for (AVCaptureDevice *device in devicesArray) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

/**
 当前捕捉会话对应的摄像头
 */
- (AVCaptureDevice *)__activeCamera {
    return self.activeVedioInput.device;
}

/**
 返回当前未激活的摄像头
 通过查找当前激活摄像头的反向摄像头实现(若只有一个，即没有未激活的摄像头，返回nil)
 */
- (AVCaptureDevice *)__inactiveCamera {
    AVCaptureDevice *device = nil;
    if (self.cameraCount > 1) {
        if ([self __activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self __cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self __cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

/// 实现点击对焦和点击曝光功能，允许通过多点触控设置焦点和曝光参数
- (void)focusAtPoint:(CGPoint)point {
    
}

- (void)exposeAtPoint:(CGPoint)point {
    
}

- (void)resetFocusAndExposureModes {
    
}

/// 实现捕捉静态图片和视频的功能
- (void)captureStillImage {
    
}

- (void)startRecording {
    
}

- (void)stopRecording {
    
}

- (BOOL)isRecording {
    return YES;
}

@end
