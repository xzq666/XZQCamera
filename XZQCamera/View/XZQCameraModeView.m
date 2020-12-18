//
//  XZQCameraModeView.m
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/2.
//

#import "XZQCameraModeView.h"
#import "XZQCaptureButton.h"
#import "UIView+XZQAdditions.h"

#define SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define SCREEN_WIDTH (SCREEN_BOUNDS.size.width)
#define SCREEN_HEIGHT (SCREEN_BOUNDS.size.height)
#define SafeAreaNoTopHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 44 : 20)
#define SafeAreaTopHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 88 : 64)
#define SafeAreaBottomHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 34 : 0)

@interface XZQCameraModeView ()

@property(nonatomic,strong) UIColor *foregroundColor;
@property(nonatomic,strong) CATextLayer *videoTextLayer;
@property(nonatomic,strong) CATextLayer *photoTextLayer;
@property(nonatomic,strong) UIView *labelContainerView;
@property(nonatomic,strong) XZQCaptureButton *captureButton;
@property(nonatomic,assign) BOOL maxLeft;
@property(nonatomic,assign) BOOL maxRight;
@property(nonatomic,assign) CGFloat videoStringWidth;

@end

@implementation XZQCameraModeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.maxRight = YES;
    self.cameraMode = XZQCameraModeVideo;
    
    // 初始化
    self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    self.foregroundColor = [UIColor colorWithRed:1.f green:0.734 blue:0.006 alpha:1.f];
    self.videoTextLayer = [self textLayerWithTitle:@"视频"];
    self.videoTextLayer.foregroundColor = self.foregroundColor.CGColor;
    self.photoTextLayer = [self textLayerWithTitle:@"照片"];
    
    // 布局
    CGSize size = [@"视频" sizeWithAttributes:[self fontAttributes]];
    self.videoStringWidth = size.width;
    self.videoTextLayer.frame = CGRectMake(0, 0, 40, 20);
    self.photoTextLayer.frame = CGRectMake(50, 0, 40, 20);
    CGRect containerRect = CGRectMake(0, 0, 90, 20);
    self.labelContainerView = [[UIView alloc] initWithFrame:containerRect];
    self.labelContainerView.backgroundColor = [UIColor clearColor];
    [self.labelContainerView.layer addSublayer:self.videoTextLayer];
    [self.labelContainerView.layer addSublayer:self.photoTextLayer];
    self.labelContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.labelContainerView];
    
    self.labelContainerView.centerY += 8.0f;
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchMode:)];
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchMode:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:rightRecognizer];
    [self addGestureRecognizer:leftRecognizer];
    
    self.captureButton = [[XZQCaptureButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 34, 40, 68, 68)];
    [self addSubview:self.captureButton];
}

- (void)switchMode:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft && !self.maxLeft) {
        [UIView animateWithDuration:0.28
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.labelContainerView.frameX -= 50;
                             [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  [CATransaction disableActions];
                                                  self.photoTextLayer.foregroundColor = self.foregroundColor.CGColor;
                                                  self.videoTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
                                              }completion:^(BOOL complete){}];
                         }
                         completion:^(BOOL complete){
                             self.cameraMode = XZQCameraModePhoto;
                             self.maxLeft = YES;
                             self.maxRight = NO;
                         }];
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight && !self.maxRight) {
        [UIView animateWithDuration:0.28
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.labelContainerView.frameX += 50;
                             self.videoTextLayer.foregroundColor = self.foregroundColor.CGColor;
                             self.photoTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
                         }
                         completion:^(BOOL complete){
                             self.cameraMode = XZQCameraModeVideo;
                             self.maxRight = YES;
                             self.maxLeft = NO;
                         }];
    }
}

- (void)setCameraMode:(XZQCameraMode)cameraMode {
    if (_cameraMode != cameraMode) {
        _cameraMode = cameraMode;
        if (cameraMode == XZQCameraModePhoto) {
            self.captureButton.selected = NO;
            self.captureButton.captureButtonMode = XZQCaptureButtonModePhoto;
            self.layer.backgroundColor = [UIColor blackColor].CGColor;
        } else {
            self.captureButton.captureButtonMode = XZQCaptureButtonModeVideo;
            self.layer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5].CGColor;
        }
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (CATextLayer *)textLayerWithTitle:(NSString *)title {
    CATextLayer *layer = [CATextLayer layer];
    layer.string = [[NSAttributedString alloc] initWithString:title attributes:[self fontAttributes]];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

- (NSDictionary *)fontAttributes {
    return @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:17.0f],
             NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
    CGRect circleRect = CGRectMake(CGRectGetMidX(rect) - 4.0, 2.0, 6.0, 6.0);
    CGContextFillEllipseInRect(context, circleRect);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.labelContainerView.frameX = CGRectGetMidX(self.bounds) - (self.videoStringWidth / 2.0);
}

@end
