//
//  SCScreenShot.h
//  SCScreenShot
//
//  Created by ZhangSC on 16/4/29.
//  Copyright © 2016年 ZSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ScreenShotHandler)(UIImage *image);

@interface SCScreenShotView : UIView

- (void)screenShotWithImage:(ScreenShotHandler)handler;

@end
