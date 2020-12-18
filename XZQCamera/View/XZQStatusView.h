//
//  XZQStatusView.h
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/2.
//

#import <UIKit/UIKit.h>
#import "XZQFlashControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZQStatusView : UIView <XZQFlashControlViewDelegate>

@property(nonatomic,strong) XZQFlashControlView *flashControlView;
@property(nonatomic,strong) UILabel *elapsedTimeLabel;
@property(nonatomic,strong) UIButton *switchCameraBtn;

@end

NS_ASSUME_NONNULL_END
