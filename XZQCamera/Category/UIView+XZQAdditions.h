//
//  UIView+XZQAdditions.h
//  XZQCamera1
//
//  Created by qhzc-iMac-02 on 2020/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XZQAdditions)

@property(nonatomic,assign) CGFloat frameX;
@property (nonatomic, assign) CGFloat frameY;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGSize frameSize;
@property (nonatomic, assign) CGFloat boundsX;
@property (nonatomic, assign) CGFloat boundsY;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end

NS_ASSUME_NONNULL_END
