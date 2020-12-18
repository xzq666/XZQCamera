//
//  XZQOverlayView.m
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/1.
//

#import "XZQOverlayView.h"

@implementation XZQOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 状态视图
        self.statusView = [[XZQStatusView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 48)];
        [self addSubview:self.statusView];
        
        // 操作视图
        self.modeView = [[XZQCameraModeView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 120, self.bounds.size.width, 120)];
        [self addSubview:self.modeView];
        
        [self.modeView addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)modeChanged:(XZQCameraModeView *)modeView {
    BOOL photoModeEnabled = modeView.cameraMode == XZQCameraModePhoto;
    UIColor *toColor = photoModeEnabled ? [UIColor blackColor] : [UIColor colorWithWhite:0.0f alpha:0.5f];
    CGFloat toOpacity = photoModeEnabled ? 0.0f : 1.0f;
    self.statusView.layer.backgroundColor = toColor.CGColor;
    self.statusView.elapsedTimeLabel.layer.opacity = toOpacity;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.statusView pointInside:[self convertPoint:point toView:self.statusView] withEvent:event] ||
        [self.modeView pointInside:[self convertPoint:point toView:self.modeView] withEvent:event]) {
        return YES;
    }
    return NO;
}

- (void)setFlashControlHidden:(BOOL)state {
    if (_flashControlHidden != state) {
        _flashControlHidden = state;
        self.statusView.flashControlView.hidden = state;
    }
}

@end
