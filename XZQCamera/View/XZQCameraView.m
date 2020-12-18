//
//  XZQCameraView.m
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/1.
//

#import "XZQCameraView.h"

#define SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define SCREEN_WIDTH (SCREEN_BOUNDS.size.width)
#define SCREEN_HEIGHT (SCREEN_BOUNDS.size.height)
#define SafeAreaNoTopHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 44 : 20)
#define SafeAreaTopHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 88 : 64)
#define SafeAreaBottomHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 34 : 0)

@interface XZQCameraView ()

@property(nonatomic,strong) XZQPreviewView *previewView;
@property(nonatomic,strong) XZQOverlayView *overlayView;

@end

@implementation XZQCameraView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.previewView = [[XZQPreviewView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self addSubview:self.previewView];
        
        self.overlayView = [[XZQOverlayView alloc] initWithFrame:CGRectMake(0, SafeAreaNoTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaNoTopHeight-SafeAreaBottomHeight)];
        [self addSubview:self.overlayView];
        
    }
    return self;
}

@end
