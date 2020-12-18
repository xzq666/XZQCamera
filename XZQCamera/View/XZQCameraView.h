//
//  XZQCameraView.h
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/1.
//

#import <UIKit/UIKit.h>
#import "XZQPreviewView.h"
#import "XZQOverlayView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZQCameraView : UIView

@property(nonatomic,strong,readonly) XZQPreviewView *previewView;
@property(nonatomic,strong,readonly) XZQOverlayView *overlayView;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
