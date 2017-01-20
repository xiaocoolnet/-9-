//
//  JQIndicatorView.m
//  JQIndicatorViewDemo
//
//  Created by James on 15/7/21.
//  Copyright (c) 2015年 JQ. All rights reserved.
//

#import "JQIndicatorView.h"
#import "JQIndicatorAnimationProtocol.h"
#import "JQBounceSpot1Animation.h"
#import <Accelerate/Accelerate.h>
#import "HPY9Pasture-Swift.h"


#define JQIndicatorDefaultSize CGSizeMake(60,60)

@interface JQIndicatorView ()

@property id<JQIndicatorAnimationProtocol> animation;
@property JQIndicatorType type;
@property CGSize size;
@property UIColor *loadingTintColor;

@property (nonatomic, strong) UIImageView *screenShotView;

- (void)setToNormalState;
- (void)setToFadeOutState;
- (void)fadeOutWithAnimation:(BOOL)animated;

@end

@implementation JQIndicatorView

- (instancetype)initWithType:(JQIndicatorType)type{
    return [self initWithType:type tintColor:[UIColor colorWithRed:81/255.0 green:166/255.0 blue:255/255 alpha:1]];
}

- (instancetype)initWithType:(JQIndicatorType)type tintColor:(UIColor *)color{
    return [self initWithType:type tintColor:color size:JQIndicatorDefaultSize];
}

- (instancetype)initWithType:(JQIndicatorType)type tintColor:(UIColor *)color size:(CGSize)size{
    if (self = [super init]) {
        self.type = type;
        self.loadingTintColor = color;
        self.size = size;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

#pragma mark - Animation

- (void)startAnimating{
    self.layer.sublayers = nil;
    [self setToNormalState];
    self.animation = [self animationForIndicatorType:self.type];
    if ([self.animation respondsToSelector:@selector(configAnimationAtLayer:withTintColor:size:)]) {
        
        [self.animation configAnimationAtLayer:self.layer withTintColor:self.loadingTintColor size:self.size];
    }
    self.isAnimating = YES;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:166/255.0 blue:255/255 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    titleLabel.text = @"快乐9号";
    [self addSubview:titleLabel];
    /**
     *  第一步添加毛玻璃背景
     */
    [self addScreenShot];
    self.center = [UIApplication sharedApplication].keyWindow.center;//设置中心
    /**
     *  然后添加旋转视图动画到顶级window上
     */
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)stopAnimating{
    if (self.isAnimating == YES) {
        if ([self.animation respondsToSelector:@selector(removeAnimation)]) {
            [self.animation removeAnimation];
            self.isAnimating = NO;
            self.animation = nil;
        }
        [self fadeOutWithAnimation:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.screenShotView removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (id<JQIndicatorAnimationProtocol>)animationForIndicatorType:(JQIndicatorType)type{
 
            return [[JQBounceSpot1Animation alloc] init];
}

#pragma mark - Indicator animation methods

- (void)setToNormalState{
    self.layer.backgroundColor = [UIColor grayColor].CGColor;
    self.layer.speed = 1.0f;
    self.layer.opacity = 1.0;
}

- (void)setToFadeOutState{
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.layer.sublayers = nil;
    self.layer.opacity = 0.f;
}

- (void)fadeOutWithAnimation:(BOOL)animated{
    if (animated) {
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.delegate = self;
        fadeAnimation.beginTime = CACurrentMediaTime();
        fadeAnimation.duration = 0.35;
        fadeAnimation.toValue = @(0);
        [self.layer addAnimation:fadeAnimation forKey:@"fadeOut"];
    }
}

#pragma mark - CAAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self setToFadeOutState];
}

#pragma mark - Did enter background

- (void)appWillEnterBackground{
    if (self.isAnimating == YES) {
        [self.animation removeAnimation];
    }
}

- (void)appWillBecomeActive{
    if (self.isAnimating == YES) {
        [self startAnimating];
    }
}
- (void)addScreenShot{
    
    UIWindow *screenWindow = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *originalImage = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        originalImage = viewImage;
    } else {
        CGImageRef subImageRef = CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(0, 20, 320, 460));
        originalImage = [UIImage imageWithCGImage:subImageRef];
        CGImageRelease(subImageRef);
    }
    
    CGFloat blurRadius = 4;
    UIColor *tintColor = [UIColor colorWithRed:0.118 green:0.125 blue:0.157 alpha:0.2];
    CGFloat saturationDeltaFactor = 1;
    UIImage *maskImage = nil;
    
    CGRect imageRect = { CGPointZero, originalImage.size };
    UIImage *effectImage = originalImage;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -originalImage.size.height);
        CGContextDrawImage(effectInContext, imageRect, originalImage.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data	 = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width	= CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data	 = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width	= CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1;
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,					0,					0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -originalImage.size.height);
    
    CGContextDrawImage(outputContext, imageRect, originalImage.CGImage);
    
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.screenShotView = [[UIImageView alloc] initWithImage:outputImage];
    [self.screenShotView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenShotViewTaped)]];
    [screenWindow addSubview:self.screenShotView];
    
}

-(void)screenShotViewTaped{
    NSLog(@"screenShotViewTaped");
}
@end
