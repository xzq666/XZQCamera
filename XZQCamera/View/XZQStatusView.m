//
//  XZQStatusView.m
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/2.
//

#import "XZQStatusView.h"

#define SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define SCREEN_WIDTH (SCREEN_BOUNDS.size.width)
#define SCREEN_HEIGHT (SCREEN_BOUNDS.size.height)
#define SafeAreaNoTopHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 44 : 20)
#define SafeAreaTopHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 88 : 64)
#define SafeAreaBottomHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 34 : 0)

@implementation XZQStatusView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.flashControlView = [[XZQFlashControlView alloc] initWithFrame:CGRectMake(16, 0, 48, 48)];
    self.flashControlView.delegate = self;
    [self addSubview:self.flashControlView];
    
    self.elapsedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH - 140, 48)];
    self.elapsedTimeLabel.textColor = [UIColor whiteColor];
    self.elapsedTimeLabel.font = [UIFont systemFontOfSize:19.0];
    self.elapsedTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.elapsedTimeLabel];
    
    self.switchCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchCameraBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    self.switchCameraBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 0, 58, 48);
    [self addSubview:self.switchCameraBtn];
}

- (void)flashControlWillExpand {
    [UIView animateWithDuration:0.2f animations:^{
        self.elapsedTimeLabel.alpha = 0.0f;
    }];
}

- (void)flashControlDidCollapse {
    [UIView animateWithDuration:0.1f animations:^{
        self.elapsedTimeLabel.alpha = 1.0f;
    }];
}

@end
