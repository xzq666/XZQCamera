//
//  XZQPreviewView.h
//  提供给用户一个摄像头当前拍摄内容的实时预览视图
//
//  Created by qhzc-iMac-02 on 2020/12/1.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XZQPreviewViewDelegate <NSObject>

/**
 聚焦
 */
- (void)tappedToFocusAtPoint:(CGPoint)point;
/**
 曝光
 */
- (void)tappedToExposeAtPoint:(CGPoint)point;
/**
 聚焦与曝光
 */
- (void)tappedToResetFocusAndExpose;

@end

@interface XZQPreviewView : UIView

@property(nonatomic,strong) AVCaptureSession *session;
@property(nonatomic,weak) id<XZQPreviewViewDelegate> delegate;

// 是否开启聚焦功能
@property(nonatomic,assign) BOOL tapToFocusEnabled;
// 是否开启曝光功能
@property(nonatomic,assign) BOOL tapToExposeEnabled;

@end

NS_ASSUME_NONNULL_END
