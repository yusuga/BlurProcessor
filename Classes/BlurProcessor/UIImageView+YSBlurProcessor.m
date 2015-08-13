//
//  UIImageView+YSBlurProcessor.m
//  BlurProcessorExample
//
//  Created by Yu Sugawara on 8/12/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "UIImageView+YSBlurProcessor.h"
#import "UIImage+ImageEffects.h"
#import <objc/message.h>

static CGFloat const kDefaultSaturationDeltaFactor = 1.;

@interface NSNumber (BlurProcessing)
- (CGFloat)ys_CGFloatValue;
@end
@implementation NSNumber (BlurProcessing)
- (CGFloat)ys_CGFloatValue
{
#if defined(__LP64__) && __LP64__
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}
@end

@implementation YSBlurInfo

- (instancetype)initWithBlurRadius:(CGFloat)blurRadius
{
    return [self initWithBlurRadius:blurRadius
                          tintColor:nil
              saturationDeltaFactor:kDefaultSaturationDeltaFactor
                          maskImage:nil];
}

- (instancetype)initWithBlurRadius:(CGFloat)blurRadius
                         tintColor:(UIColor *)tintColor
             saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                         maskImage:(UIImage *)maskImage
{
    if (self = [super init]) {
        self.blurRadius = blurRadius;
        self.tintColor = tintColor;
        self.saturationDeltaFactor = saturationDeltaFactor;
        self.maskImage = maskImage;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@, blurRadius = %f, tintColor = %@, saturationDeltaFactor = %f, maskImage = %@>", [super description], self.blurRadius, self.tintColor, self.saturationDeltaFactor, self.maskImage];
}

@end

@implementation UIImageView (BlurProcessing)

- (void)ys_setImage:(UIImage *)image
       withBlurInfo:(YSBlurInfo *)blurInfo
         completion:(YSBlurProcessorCompletion)completion
{
    NSParameterAssert(image);
    if (!image) {
        if (completion) completion(NO);
        return;
    }
    if ([self ys_blurProcessing]) {
        [self ys_setNextBlurInfo:blurInfo];
        return;
    }
    
    [self ys_setBlurProcessing:YES];
    
    dispatch_async([self ys_blurProcessingQueue], ^{
        UIImage *blurredImage = [image applyBlurWithRadius:blurInfo.blurRadius
                                                 tintColor:blurInfo.tintColor
                                     saturationDeltaFactor:blurInfo.saturationDeltaFactor
                                                 maskImage:blurInfo.maskImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ys_setBlurProcessing:NO];
            self.image = blurredImage;
            
            YSBlurInfo *nextInfo = [self ys_nextBlurInfo];
            if (nextInfo) {
                [self ys_setNextBlurInfo:nil];
                [self ys_setImage:image withBlurInfo:nextInfo completion:completion];
            }
            
            if (completion) completion(nextInfo != nil);
        });
    });
}

#pragma mark - Property

- (dispatch_queue_t)ys_blurProcessingQueue
{
    dispatch_queue_t queue = objc_getAssociatedObject(self, @selector(ys_blurProcessingQueue));
    if (!queue) {
        queue = dispatch_queue_create("com.yusuga.BlurProcessor.queue", NULL);
        objc_setAssociatedObject(self, @selector(ys_blurProcessingQueue), queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return queue;
}

- (BOOL)ys_blurProcessing
{
    return [objc_getAssociatedObject(self, @selector(ys_blurProcessing)) boolValue];
}

- (void)ys_setBlurProcessing:(BOOL)processing
{
    objc_setAssociatedObject(self, @selector(ys_blurProcessing), @(processing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YSBlurInfo *)ys_nextBlurInfo
{
    return objc_getAssociatedObject(self, @selector(ys_nextBlurInfo));
}

- (void)ys_setNextBlurInfo:(YSBlurInfo *)info
{
    objc_setAssociatedObject(self, @selector(ys_nextBlurInfo), info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
