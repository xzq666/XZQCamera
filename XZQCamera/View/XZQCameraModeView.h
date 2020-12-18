//
//  XZQCameraModeView.h
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XZQCameraMode) {
    XZQCameraModePhoto = 0,
    XZQCameraModeVideo = 1
};

@interface XZQCameraModeView : UIControl

@property(nonatomic,assign) XZQCameraMode cameraMode;

@end

NS_ASSUME_NONNULL_END
