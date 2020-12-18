//
//  XZQOverlayView.h
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/1.
//

#import <UIKit/UIKit.h>
#import "XZQCameraModeView.h"
#import "XZQStatusView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZQOverlayView : UIView

@property(nonatomic,strong) XZQCameraModeView *modeView;
@property(nonatomic,strong) XZQStatusView *statusView;

@property(nonatomic,assign) BOOL flashControlHidden;

@end

NS_ASSUME_NONNULL_END
