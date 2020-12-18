//
//  XZQCameraControl.h
//  用于配置和管理不同的捕捉设备，同时也对捕捉设备的输出进行控制和交互
//
//  Created by qhzc-iMac-02 on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

// 创建预览图通知名称
extern NSString *const XZQThumbnailCreatedNotification;

@protocol XZQCameraControlDelegate <NSObject>

/**
 设备配置错误回调
 */
- (void)deviceConfigurationFailedWithError:(NSError *)error;
/**
 媒体捕捉失败回调
 */
- (void)mediaCaptureFailedWithError:(NSError *)error;
/**
 写入错误回调
 */
- (void)assetLibraryWriteFailedWithError:(NSError *)error;

@end

@interface XZQCameraControl : NSObject

@property(nonatomic,weak) id<XZQCameraControlDelegate> delegate;
@property(nonatomic,strong,readonly) AVCaptureSession *captureSession;

/// 配置和控制捕捉会话
- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

/// 在不同摄像头中切换以测试摄像头的不同功能，保证用户可以在界面上进行正确选择
- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;
@property(nonatomic,assign,readonly) NSUInteger cameraCount;
@property(nonatomic,assign,readonly) BOOL cameraHasTorch;             // 是否开启手电筒
@property(nonatomic,assign,readonly) BOOL cameraHasFlash;             // 是否开启闪光
@property(nonatomic,assign,readonly) BOOL cameraSupportsTapToFocus;   // 是否支持聚焦
@property(nonatomic,assign,readonly) BOOL cameraSupportsTapToExpose;  // 是否支持曝光

/// 实现点击对焦和点击曝光功能，允许通过多点触控设置焦点和曝光参数
- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
- (void)resetFocusAndExposureModes;

/// 实现捕捉静态图片和视频的功能
- (void)captureStillImage;
- (void)startRecording;
- (void)stopRecording;
- (BOOL)isRecording;

@end

NS_ASSUME_NONNULL_END
