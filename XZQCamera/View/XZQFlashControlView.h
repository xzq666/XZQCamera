//
//  XZQFlashControlView.h
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XZQFlashControlViewDelegate <NSObject>

@optional
- (void)flashControlWillExpand;
- (void)flashControlDidExpand;
- (void)flashControlWillCollapse;
- (void)flashControlDidCollapse;

@end

@interface XZQFlashControlView : UIControl

@property(nonatomic,assign) NSInteger selectedMode;
@property(nonatomic,weak) id<XZQFlashControlViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
