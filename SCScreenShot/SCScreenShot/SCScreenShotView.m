//
//  SCScreenShot.m
//  SCScreenShot
//
//  Created by ZhangSC on 16/4/29.
//  Copyright © 2016年 ZSC. All rights reserved.
//

#import "SCScreenShotView.h"

@interface SCScreenShotView ()

@property (nonatomic, strong) UIView *screenView;
@property (nonatomic, copy) ScreenShotHandler handler;

@end

@implementation SCScreenShotView {
    CGPoint beginPoint;
    CGPoint endPoint;
    UIImageView *currentImageView;
    CGRect currentRect;
}

- (UIView *)screenView {
    if (_screenView == nil) {
        _screenView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    }
    return _screenView;
}

- (CGRect)getScreenRect {
    return [UIScreen mainScreen].bounds;
}

- (void)screenShotWithImage:(ScreenShotHandler)handler {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.20];
    
    CGRect frame = CGRectMake(0, [self getScreenRect].size.height, [self getScreenRect].size.width, [self getScreenRect].size.height);
    self.screenView.frame = frame;
    [self addSubview:self.screenView];
    
    [keyWindow addSubview:self];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:gesture];
    
    if (handler != nil) {
        self.handler = handler;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            beginPoint = point;
            endPoint = beginPoint;
            [currentImageView removeFromSuperview];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            endPoint = point;
            CGRect selectedRect = CGRectMake(beginPoint.x, beginPoint.y, endPoint.x - beginPoint.x, endPoint.y - beginPoint.y);
            CGRect scaleRect = CGRectMake(beginPoint.x * 3, beginPoint.y* 3, (endPoint.x - beginPoint.x)* 3, (endPoint.y - beginPoint.y)* 3);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [self getImageWithRect:scaleRect];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.frame = selectedRect;
                [self addSubview:imageView];
                [currentImageView removeFromSuperview];
                currentImageView = imageView;
            });
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            endPoint = point;
            currentRect = CGRectMake(beginPoint.x, beginPoint.y, endPoint.x - beginPoint.x, endPoint.y - beginPoint.y);
            [self addSureButtonWithRect:currentRect];
        }
            
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            
            break;
            
        default:
            break;
    }
}

// MARK:-
// MARK: Private

- (void)addSureButtonWithRect:(CGRect)rect {
    CGRect buttonFrame;
    if (CGRectGetMaxY(rect) >= [self getScreenRect].size.height - 50) {
        buttonFrame = CGRectMake(CGRectGetMaxX(rect) - 40, CGRectGetMinY(rect) - 30, 40, 30);
    } else {
        buttonFrame = CGRectMake(CGRectGetMaxX(rect) - 40, CGRectGetMaxY(rect), 40, 30);
    }
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button setTitle:@"👌" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)sure:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.handler != nil) {
        self.handler(currentImageView.image);
        self.handler = nil;
    }
}

/**
 得到固定rect内的图片
 */
- (UIImage *)getImageWithRect:(CGRect)rect {
    UIImage *screenImage = [self screenImageView:self.screenView];
    CGImageRef imageRef = CGImageCreateWithImageInRect(screenImage.CGImage, rect);
    return [UIImage imageWithCGImage:imageRef scale:3.0 orientation:UIImageOrientationUp];
}

/**
 得到屏幕图片
 */
- (UIImage *)screenImageView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions([self getScreenRect].size, NO, 0);
    [view drawViewHierarchyInRect:[self getScreenRect] afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
