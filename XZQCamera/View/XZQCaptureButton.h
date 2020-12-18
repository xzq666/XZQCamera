//
//  XZQCaptureButton.h
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XZQCaptureButtonMode) {
    XZQCaptureButtonModePhoto = 0,
    XZQCaptureButtonModeVideo = 1
};

@interface XZQCaptureButton : UIButton

+ (instancetype)captureButton;
+ (instancetype)captureButtonWithMode:(XZQCaptureButtonMode)captureButtonMode;

@property(nonatomic,assign) XZQCaptureButtonMode captureButtonMode;

@end

NS_ASSUME_NONNULL_END
