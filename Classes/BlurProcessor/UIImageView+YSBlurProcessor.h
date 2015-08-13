//
//  UIImageView+YSBlurProcessor.h
//  BlurProcessorExample
//
//  Created by Yu Sugawara on 8/12/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSBlurInfo : NSObject

- (instancetype)initWithBlurRadius:(CGFloat)blurRadius;
- (instancetype)initWithBlurRadius:(CGFloat)blurRadius
                         tintColor:(UIColor *)tintColor
             saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                         maskImage:(UIImage *)maskImage;

@property (nonatomic) CGFloat blurRadius;
@property (nonatomic) UIColor *tintColor;               // Default value is nil.
@property (nonatomic) CGFloat saturationDeltaFactor;    // Default value is 1.
@property (nonatomic) UIImage *maskImage;               // Default value is nil.

@end

typedef void (^YSBlurProcessorCompletion)(BOOL nextBlurProcessing);

@interface UIImageView (YSBlurProcessor)

- (void)ys_setImage:(UIImage *)image
       withBlurInfo:(YSBlurInfo *)blurInfo
         completion:(YSBlurProcessorCompletion)completion;

@end
