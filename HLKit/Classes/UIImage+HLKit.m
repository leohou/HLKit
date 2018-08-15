//
//  UIImage+HLKit.m
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import "UIImage+HLKit.h"
#import <Accelerate/Accelerate.h>
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>

#import <QuartzCore/QuartzCore.h>

#define MAX_IMAGEPIX 1600.0          // max pix 200.0px
#define MAX_IMAGEDATA_LEN 200.0   // max data length 5K

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)
@implementation UIImage (HLKit)
//高效添加圆角图片
- (UIImage*)wh_imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//截屏
+(instancetype)wh_snapshotCurrentScreen{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, 0);
    [window drawViewHierarchyInRect:window.frame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+(UIImage *)wh_GetRoundImagewithImage:(UIImage *)image {
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat redius = ((width <= height) ? width : height)/2;
    CGRect  rect = CGRectMake(width/2-redius, height/2-redius, redius*2, redius*2);
    
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newImage.size.width, newImage.size.height), NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(newImage.size.width/2, newImage.size.height/2) radius:redius startAngle:0 endAngle:M_PI*2 clockwise:0];
    [path addClip];
    [newImage drawAtPoint:CGPointZero];
    UIImage *imageCut = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageCut;
    
}

//图片模糊效果
- (UIImage *)blur
{
    return [self imgWithLightAlpha:0.1 radius:3 colorSaturationFactor:1];
}

- (UIImage *)imgWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:alpha];
    return [self imgBluredWithRadius:radius tintColor:tintColor saturationDeltaFactor:colorSaturationFactor maskImage:nil];
}

- (UIImage *)imgBluredWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
                0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
                0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
                0, 0, 0, 1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix) / sizeof(floatingPointSaturationMatrix[0]);
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
    
    // 开启上下文 用于输出图像
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // 开始画底图
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // 开始画模糊效果
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // 添加颜色渲染
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // 输出成品,并关闭上下文
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}


- (UIColor *)wh_colorAtPixel:(CGPoint)point
{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point))
    {
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = {0, 0, 0, 0};
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -point.x, point.y - self.size.height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), self.CGImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}



//生成一张纯色的图片
- (UIImage *)wh_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}




static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        CFRelease(properties);
        if (gifProperties) {
            CFNumberRef const number = CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            
            delayCentiseconds = (int)lrint([fromCF number doubleValue] * 100);
        }
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b) {
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        // Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef source) {
    if (source) {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(toCF data, NULL));
}

+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)url {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(toCF url, NULL));
}



- (UIImage *)imageCroppedToRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageScaledToSize:(CGSize)size
{
    if (CGSizeEqualToSize(self.size, size))
    {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageScaledToFitSize:(CGSize)size
{
    CGFloat aspect = self.size.width / self.size.height;
    if (size.width / aspect <= size.height)
    {
        return [self imageScaledToSize:CGSizeMake(size.width, size.width / aspect)];
    }
    else
    {
        return [self imageScaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}

- (UIImage *)imageScaledToFillSize:(CGSize)size
{
    if (CGSizeEqualToSize(self.size, size))
    {
        return self;
    }
    
    CGFloat aspect = self.size.width / self.size.height;
    if (size.width / aspect >= size.height)
    {
        return [self imageScaledToSize:CGSizeMake(size.width, size.width / aspect)];
    }
    else
    {
        return [self imageScaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}

- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;
{
    CGRect rect = CGRectZero;
    switch (contentMode)
    {
        case UIViewContentModeScaleAspectFit:
        {
            CGFloat aspect = self.size.width / self.size.height;
            if (size.width / aspect <= size.height)
            {
                rect = CGRectMake(0.0f, (size.height - size.width / aspect) / 2.0f, size.width, size.width / aspect);
            }
            else
            {
                rect = CGRectMake((size.width - size.height * aspect) / 2.0f, 0.0f, size.height * aspect, size.height);
            }
            break;
        }
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat aspect = self.size.width / self.size.height;
            if (size.width / aspect >= size.height)
            {
                rect = CGRectMake(0.0f, (size.height - size.width / aspect) / 2.0f, size.width, size.width / aspect);
            }
            else
            {
                rect = CGRectMake((size.width - size.height * aspect) / 2.0f, 0.0f, size.height * aspect, size.height);
            }
            break;
        }
        case UIViewContentModeCenter:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTop:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottom:
        {
            rect = CGRectMake((size.width - self.size.width) / 2.0f, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeLeft:
        {
            rect = CGRectMake(0.0f, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeRight:
        {
            rect = CGRectMake(size.width - self.size.width, (size.height - self.size.height) / 2.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopLeft:
        {
            rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeTopRight:
        {
            rect = CGRectMake(size.width - self.size.width, 0.0f, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomLeft:
        {
            rect = CGRectMake(0.0f, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        case UIViewContentModeBottomRight:
        {
            rect = CGRectMake(size.width - self.size.width, size.height - self.size.height, self.size.width, self.size.height);
            break;
        }
        default:
        {
            rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
            break;
        }
    }
    
    if (!padToFit)
    {
        if (rect.size.width < size.width)
        {
            size.width = rect.size.width;
            rect.origin.x = 0.0f;
        }
        if (rect.size.height < size.height)
        {
            size.height = rect.size.height;
            rect.origin.y = 0.0f;
        }
    }
    
    if (CGSizeEqualToSize(self.size, size))
    {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGImageRef)gradientMask
{
    static CGImageRef sharedMask = NULL;
    if (sharedMask == NULL)
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 256), YES, 0.0);
        CGContextRef gradientContext = UIGraphicsGetCurrentContext();
        CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
        CGPoint gradientStartPoint = CGPointMake(0, 0);
        CGPoint gradientEndPoint = CGPointMake(0, 256);
        CGContextDrawLinearGradient(gradientContext, gradient, gradientStartPoint,
                                    gradientEndPoint, kCGGradientDrawsAfterEndLocation);
        sharedMask = CGBitmapContextCreateImage(gradientContext);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        UIGraphicsEndImageContext();
    }
    return sharedMask;
}

- (UIImage *)reflectedImageWithScale:(CGFloat)scale
{
    CGFloat height = ceil(self.size.height * scale);
    CGSize size = CGSizeMake(self.size.width, height);
    CGRect bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClipToMask(context, bounds, [[self class] gradientMask]);
    
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -self.size.height);
    [self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];
    
    UIImage *reflection = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reflection;
}

- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha
{
    
    UIImage *reflection = [self reflectedImageWithScale:scale];
    CGFloat reflectionOffset = reflection.size.height + gap;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height + reflectionOffset * 2.0f), NO, 0.0f);
    
    [reflection drawAtPoint:CGPointMake(0.0f, reflectionOffset + self.size.height + gap) blendMode:kCGBlendModeNormal alpha:alpha];
    
    [self drawAtPoint:CGPointMake(0.0f, reflectionOffset)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur
{
    CGSize border = CGSizeMake(fabs(offset.width) + blur, fabs(offset.height) + blur);
    
    CGSize size = CGSizeMake(self.size.width + border.width * 2.0f, self.size.height + border.height * 2.0f);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShadowWithColor(context, offset, blur, color.CGColor);
    
    [self drawAtPoint:CGPointMake(border.width, border.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, radius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height - radius);
    CGContextAddArc(context, radius, self.size.height - radius, radius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width - radius, self.size.height);
    CGContextAddArc(context, self.size.width - radius, self.size.height - radius, radius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, radius);
    CGContextAddArc(context, self.size.width - radius, radius, radius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, radius, 0.0f);
    CGContextAddArc(context, radius, radius, radius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    [self drawAtPoint:CGPointZero];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithMask:(UIImage *)maskImage;
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClipToMask(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), maskImage.CGImage);
    
    [self drawAtPoint:CGPointZero];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)maskImageFromImageAlpha
{
    NSInteger width = CGImageGetWidth(self.CGImage);
    NSInteger height = CGImageGetHeight(self.CGImage);
    
    NSInteger bytesPerRow = ((width + 3) / 4) * 4;
    void *data = calloc(bytesPerRow * height, sizeof(unsigned char *));
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, bytesPerRow, NULL, kCGImageAlphaOnly);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), self.CGImage);
    
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            NSInteger index = y * bytesPerRow + x;
            ((unsigned char *)data)[index] = 255 - ((unsigned char *)data)[index];
        }
    }
    
    CGImageRef maskRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *mask = [UIImage imageWithCGImage:maskRef];
    CGImageRelease(maskRef);
    free(data);
    
    return mask;
}



+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage
{
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    CGImageRef secondImageRef = secondImage.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (NSData *)compressWithMaxLength:(NSInteger)maxLength
{
    CGFloat compress = 0.9f;
    NSData *data = UIImageJPEGRepresentation(self, compress);
    
    while (data.length > maxLength && compress > 0.01)
    {
        compress -= 0.02f;
        
        data = UIImageJPEGRepresentation(self, compress);
    }
    
    return data;
}


/** 获得灰度图 */
- (UIImage *)wh_convertToGrayImage
{
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
    {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}




/** 纠正图片的方向 */
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect bnds = CGRectZero;
    UIImage* copy = nil;
    CGContextRef ctxt = nil;
    CGImageRef imag = self.CGImage;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    rect.size.width = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            return self;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

/** 垂直翻转 */
- (UIImage *)flipVertical
{
    return [self rotate:UIImageOrientationDownMirrored];
}

/** 水平翻转 */
- (UIImage *)flipHorizontal
{
    return [self rotate:UIImageOrientationUpMirrored];
}

/** 将图片旋转弧度radians */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    CGContextRotateCTM(bitmap, radians);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 将图片旋转角度degrees */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    return [self imageRotatedByRadians:kDegreesToRadian(degrees)];
}

/** 交换宽和高 */
static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat swap = rect.size.width;
    
    rect.size.width = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}



#pragma mark - 截取当前image对象rect区域内的图像
- (UIImage *)subImageWithRect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    
    return newImage;
}

#pragma mark - 压缩图片至指定尺寸
- (UIImage *)rescaleImageToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

#pragma mark - 压缩图片至指定像素
- (UIImage *)rescaleImageToPX:(CGFloat )toPX
{
    CGSize size = self.size;
    
    if(size.width <= toPX && size.height <= toPX)
    {
        return self;
    }
    
    CGFloat scale = size.width / size.height;
    
    if(size.width > size.height)
    {
        size.width = toPX;
        size.height = size.width / scale;
    }
    else
    {
        size.height = toPX;
        size.width = size.height * scale;
    }
    
    return [self rescaleImageToSize:size];
}

#pragma mark - 指定大小生成一个平铺的图片
- (UIImage *)getTiledImageWithSize:(CGSize)size
{
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = (CGRect){CGPointZero, size};
    tempView.backgroundColor = [UIColor colorWithPatternImage:self];
    
    UIGraphicsBeginImageContext(size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return bgImage;
}

#pragma mark - UIView转化为UIImage
+ (UIImage *)imageFromView:(UIView *)view
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)wh_imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor {
    //画布大小
    CGSize size=CGSizeMake(self.size.width,self.size.height);
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [self drawAtPoint:CGPointMake(0.0,0.0)];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText=[title boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}context:nil].size;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    //绘制文字
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:titleColor,NSParagraphStyleAttributeName:paragraphStyle}];
    
    //返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 标记
+ (CGFloat)screenScale {
    CGFloat scale = [UIScreen mainScreen].scale;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        scale = ceil([UIScreen mainScreen].nativeScale);
    }
    return scale;
}

//截取部分图像
//- (UIImage *)getSubImage:(CGRect)rect
//{
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    CFRelease(subImageRef);
//    return smallImage;
//}

- (UIImage*)scaledImage:(CGSize)targetSize {
    
    if (targetSize.width <= 0.0 ||
        targetSize.height <= 0.0 ||
        self.size.width <= 0.0 ||
        self.size.height <= 0.0) {
        return nil;
    }
    
    CGFloat scale = [UIImage screenScale];
    
    if (self.size.width * self.scale <= targetSize.width * scale &&
        self.size.height * self.scale <= targetSize.height * scale) {
        // zfs_2013.8.13_01
        return self;
    } else {
        CGFloat width = ceil((self.size.width / self.size.height) * targetSize.height);
        CGFloat height = ceil((self.size.height / self.size.width) * targetSize.width);
        targetSize.width = MIN(targetSize.width, width);
        targetSize.height = MIN(targetSize.height, height);
        
        // zfs_2013.8.13_01
        if (scale > 1.0) {
            targetSize.width  *= scale;
            targetSize.height *= scale;
        }
    }
    
    UIImageOrientation orientation = self.imageOrientation;
    switch (orientation) {
            // zfs_2013.8.13_02
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            CGFloat swapValue = targetSize.width;
            targetSize.width  = targetSize.height;
            targetSize.height = swapValue;
            break;
        }
            
        default:
            break;
    }
    
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap;
    bitmap = CGBitmapContextCreate(NULL,
                                   targetSize.width,
                                   targetSize.height,
                                   8,
                                   targetSize.width * 4,
                                   colorSpaceInfo,
                                   kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpaceInfo);
    colorSpaceInfo = nil;
    CGContextDrawImage(bitmap,
                       CGRectMake(0.0, 0.0, targetSize.width, targetSize.height),
                       self.CGImage);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    CGContextRelease(bitmap);
    bitmap = nil;
    // zfs_2013.8.13_01
    UIImage * newImage = [UIImage imageWithCGImage:ref
                                             scale:scale
                                       orientation:orientation];
    CGImageRelease(ref);
    ref = nil;
    return newImage;
}

- (CGRect)frameToClip:(CGSize)viewSize {
    CGSize imageSize = self.size;
    if (viewSize.width / viewSize.height > imageSize.width / imageSize.height) {
        // wider
        CGFloat newImageHeight = viewSize.height * imageSize.width / viewSize.width;
        return CGRectMake(0, (imageSize.height - newImageHeight)/2, imageSize.width, newImageHeight);
    } else {
        CGFloat newImageWidth = viewSize.width * imageSize.height / viewSize.height;
        return CGRectMake((imageSize.width - newImageWidth)/2, 0, newImageWidth, imageSize.height);
    }
}

#if 0
- (UIImage *)faceImageConstrainedToSize:(CGSize)viewSize {
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 5.0) {
        return [self thumbnailWithoutTransform:viewSize];
    }
    
    CIImage * ciImage = [CIImage imageWithCGImage:self.CGImage];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy]];
    NSArray * features = [detector featuresInImage:ciImage];
    CGFloat maxSize = 0;
    CGRect faceBounds;
    for (CIFaceFeature * feature in features) {
        CGRect bounds = feature.bounds;
        if (maxSize < bounds.size.width * bounds.size.height) {
            maxSize = bounds.size.width * bounds.size.height;
            faceBounds = CGRectMake(bounds.origin.x, self.size.height - bounds.origin.y - bounds.size.height, bounds.size.width, bounds.size.height);
        }
    }
    if (maxSize <= 0) {
        return [self thumbnailWithoutTransform:viewSize];
    }
    CGPoint faceCenter = CGPointMake((faceBounds.origin.x + faceBounds.size.width)/2,
                                     (faceBounds.origin.y + faceBounds.size.height)/2);
    CGPoint startCenter = CGPointMake(self.size.width/2, self.size.height/2);
    
    CGFloat scale = [UIImage screenScale];
    if (scale > 1.0) {
        viewSize.width  *= scale;
        viewSize.height *= scale;
    }
    
    UIImageOrientation orientation = self.imageOrientation;
    switch (orientation) {
            // zfs_2013.8.13_02
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            CGFloat swapValue = viewSize.width;
            viewSize.width  = viewSize.height;
            viewSize.height = swapValue;
            break;
        }
            
        default:
            break;
    }
    
    CGRect clipedFrame = [self frameToClip:viewSize];
    CGPoint origin = clipedFrame.origin;
    CGSize clipedRange = CGSizeMake(abs(origin.x), abs(origin.y));
    CGPoint vector = CGPointMake(faceCenter.x - startCenter.x, faceCenter.y - startCenter.y);
    CGPoint offset = CGPointMake(MIN(MAX(-clipedRange.width, vector.x), clipedRange.width),
                                 MIN(MAX(-clipedRange.height, vector.y), clipedRange.height));
    if (-clipedRange.width < vector.x) {
        offset.x = -offset.x;
    }
    //NSLog(@"origin=%@;vector=%@;offset=%@",NSStringFromCGPoint(origin),NSStringFromCGPoint(vector),NSStringFromCGPoint(offset));
    clipedFrame = CGRectMake(clipedFrame.origin.x + offset.x, clipedFrame.origin.y + offset.y, clipedFrame.size.width, clipedFrame.size.height);
    //NSLog(@"clipedFrame=%@",NSStringFromCGRect(clipedFrame));
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], clipedFrame);
    UIImage * tImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    CGImageRelease(imageRef);
    return tImage;
}
#endif
// zfs_2013.8.12_02
- (UIImage *)thumbnailWithoutTransform:(CGSize)targetSize {
    
    if (targetSize.width <= 0.0 ||
        targetSize.height <= 0.0 ||
        self.size.width <= 0.0 ||
        self.size.height <= 0.0) {
        return nil;
    }
    
    // zfs_2013.8.13_01
    CGFloat scale = [UIImage screenScale];
    if (scale > 1.0) {
        targetSize.width  *= scale;
        targetSize.height *= scale;
    }
    
    // zfs_2013.8.13_01
    CGRect rect;
    CGFloat width = ceil((self.size.width / self.size.height) * targetSize.height);
    CGFloat height = ceil((self.size.height / self.size.width) * targetSize.width);
    rect.size.width = MAX(targetSize.width, width);
    rect.size.height = MAX(targetSize.height, height);
    rect.origin.x = ceil(((targetSize.width - rect.size.width) / 2.0));
    rect.origin.y = ceil(((targetSize.height - rect.size.height) / 2.0));
    
    UIImageOrientation orientation = self.imageOrientation;
    switch (orientation) {
            // zfs_2013.8.13_02
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            CGPoint swapPoint = rect.origin;
            CGSize  swapSize  = rect.size;
            rect.origin = CGPointMake(swapPoint.y, swapPoint.x);
            rect.size   = CGSizeMake(swapSize.height, swapSize.width);
            break;
        }
            
        default:
            break;
    }
    
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap;
    bitmap = CGBitmapContextCreate(NULL,
                                   targetSize.width,
                                   targetSize.height,
                                   8,
                                   targetSize.width * 4,
                                   colorSpaceInfo,
                                   kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpaceInfo);
    colorSpaceInfo = nil;
    CGContextDrawImage(bitmap,
                       rect,
                       self.CGImage);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    CGContextRelease(bitmap);
    bitmap = nil;
    // zfs_2013.8.13_01
    UIImage * newImage = [UIImage imageWithCGImage:ref
                                             scale:scale
                                       orientation:orientation];
    
    CGImageRelease(ref);
    ref = nil;
    return newImage;
}

/**
 拍照时旋转90度，保存时调整回来
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             aImage.size.width,
                                             aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)scaledImageWithTransform:(CGSize)targetSize {
    
    if (targetSize.width <= 0.0 ||
        targetSize.height <= 0.0 ||
        self.size.width <= 0.0 ||
        self.size.height <= 0.0) {
        return nil;
    }
    
    if (self.size.width <= targetSize.width &&
        self.size.height <= targetSize.height) {
        if (self.imageOrientation == UIImageOrientationUp) {
            return self;
        } else {
            targetSize = self.size;
        }
    } else {
        CGFloat width = ceil((self.size.width / self.size.height) * targetSize.height);
        CGFloat height = ceil((self.size.height / self.size.width) * targetSize.width);
        targetSize.width = MIN(targetSize.width, width);
        targetSize.height = MIN(targetSize.height, height);
    }
    
    CGImageRef imageRef = self.CGImage;
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast;
    }
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, targetSize.width, targetSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, targetSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, targetSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, targetSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, targetSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             targetSize.width,
                                             targetSize.height,
                                             CGImageGetBitsPerComponent(self.CGImage),
                                             0,
                                             CGImageGetColorSpace(self.CGImage),
                                             bitmapInfo);
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, targetSize.height, targetSize.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, targetSize.width, targetSize.height), self.CGImage);
            break;
    }
    
    CGImageRef ref = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    
    return newImage;
}

// zfs_2013.8.13_03
- (UIImage *)clippedImageInRect:(CGRect)rect {
    
    if (self.scale > 1.0) {
        rect.origin.x *= self.scale;
        rect.origin.y *= self.scale;
        rect.size.width *= self.scale;
        rect.size.height *= self.scale;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            CGRect buff = rect;
            rect.origin.x = buff.origin.y;
            rect.origin.y = buff.origin.x;
            rect.size.width = buff.size.height;
            rect.size.height = buff.size.width;
        }
            break;
            
        default:
            break;
    }
    
    CGImageRef cgImage = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage * uiImage = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cgImage);
    return uiImage;
}

+ (UIImage *)CGThumbnail:(CGFloat)dimension fromImage:(NSString *)path {
    
    NSURL * url = [[NSURL alloc] initFileURLWithPath:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    if (imageSource == NULL) {
        return nil;
    }
    
    NSDictionary *thumbnailOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                      (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailWithTransform,
                                      (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailFromImageAlways,
                                      [NSNumber numberWithFloat:dimension], kCGImageSourceThumbnailMaxPixelSize,
                                      nil];
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)thumbnailOptions);
    CFRelease(imageSource);
    
    if (thumbnail != NULL) {
        UIImage *image = [UIImage imageWithCGImage:thumbnail];
        CFRelease(thumbnail);
        return image;
    }
    
    return nil;
}

// zfs_2013.11.07_01
+ (UIImage *)CGThumbnail:(CGFloat)dimension fromData:(NSData *)data {
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (imageSource == NULL) {
        return nil;
    }
    
    NSDictionary *thumbnailOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                      (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailWithTransform,
                                      (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailFromImageAlways,
                                      [NSNumber numberWithFloat:dimension], kCGImageSourceThumbnailMaxPixelSize,
                                      nil];
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)thumbnailOptions);
    CFRelease(imageSource);
    
    if (thumbnail != NULL) {
        UIImage *image = [UIImage imageWithCGImage:thumbnail];
        CFRelease(thumbnail);
        return image;
    }
    
    return nil;
}

- (BOOL)writeToDestination:(CGImageDestinationRef)destination
                  withType:(CFStringRef)imageType
                   quality:(CGFloat)quality
                andOptions:(NSDictionary *)options {
    NSMutableDictionary * dict = (options ?
                                  [NSMutableDictionary dictionaryWithDictionary:options] :
                                  [NSMutableDictionary dictionary]);
    [dict setValue:@(quality) forKey:(NSString*)kCGImageDestinationLossyCompressionQuality];
    
    CGImageDestinationAddImage(destination,
                               self.CGImage,
                               (__bridge CFDictionaryRef)(dict));
    return CGImageDestinationFinalize(destination);
}

- (BOOL)writeToData:(NSMutableData *)data
           withType:(CFStringRef)imageType
            quality:(CGFloat)quality
         andOptions:(NSDictionary *)options {
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data,
                                                                         imageType,
                                                                         1,
                                                                         NULL);
    if (destination == NULL) {
        return NO;
    }
    BOOL success = [self writeToDestination:destination
                                   withType:imageType
                                    quality:quality
                                 andOptions:options];
    CFRelease(destination);
    destination = nil;
    return success;
}

- (BOOL)writeToFile:(NSString *)file
           withType:(CFStringRef)imageType
            quality:(CGFloat)quality
         andOptions:(NSDictionary *)options {
    //    CFURLRef urlRef = (__bridge CFURLRef)([NSURL fileURLWithPath:file]);
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)([NSURL fileURLWithPath:file]),
                                                                        imageType,
                                                                        1,
                                                                        NULL);
    if (destination == NULL) {
        return NO;
    }
    BOOL success = [self writeToDestination:destination
                                   withType:imageType
                                    quality:quality
                                 andOptions:options];
    CFRelease(destination);
    destination = nil;
    return success;
}

- (NSData *)JPEGRepresentation:(CGFloat)quality
          saveImageOrientation:(BOOL)saveImageOrientation {
    if (!saveImageOrientation ||
        self.imageOrientation == UIImageOrientationUp) {
        return UIImageJPEGRepresentation(self, 1.0);
    }
    
    NSInteger CGImageOrientation = [UIImage CGImageOrientationFrom:self.imageOrientation];
    NSString * key = (NSString *)kCGImagePropertyOrientation;
    NSDictionary * meta = @{key : @(CGImageOrientation)};
    NSMutableData * data = [NSMutableData data];
    if ([self writeToData:data
                 withType:kUTTypeJPEG
                  quality:quality
               andOptions:meta]) {
        return data;
    } else {
        return nil;
    }
}

+ (NSInteger)CGImageOrientationFrom:(UIImageOrientation)imageOrientation {
    
    int CGImageOrientation = 1;
    switch (imageOrientation) {
        case UIImageOrientationUp:
            CGImageOrientation = 1;
            break;
        case UIImageOrientationDown:
            CGImageOrientation = 3;
            break;
        case UIImageOrientationLeft:
            CGImageOrientation = 8;
            break;
        case UIImageOrientationRight:
            CGImageOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            CGImageOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            CGImageOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            CGImageOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            CGImageOrientation = 7;
            break;
        default:
            break;
    }
    return CGImageOrientation;
}

+ (UIImageOrientation)UIImageOrientationFrom:(NSInteger)CGImageOrientation {
    
    UIImageOrientation imageOrientation = UIImageOrientationUp;
    switch (CGImageOrientation) {
        case 1:
            imageOrientation = UIImageOrientationUp;
            break;
        case 3:
            imageOrientation = UIImageOrientationDown;
            break;
        case 8:
            imageOrientation = UIImageOrientationLeft;
            break;
        case 6:
            imageOrientation = UIImageOrientationRight;
            break;
        case 2:
            imageOrientation = UIImageOrientationUpMirrored;
            break;
        case 4:
            imageOrientation = UIImageOrientationDownMirrored;
            break;
        case 5:
            imageOrientation = UIImageOrientationLeftMirrored;
            break;
        case 7:
            imageOrientation = UIImageOrientationRightMirrored;
            break;
        default:
            break;
    }
    return imageOrientation;
}

+ (UIImage *)getOverlappedImage:(NSArray *)images {
    int randomAngel1 = (rand() % 4) + 4;
    int randomAngel2 = (rand() % 3) + 3;
    if (rand() % 2 == 0) {
        randomAngel1 = ABS(randomAngel1);
        randomAngel2 = -ABS(randomAngel2);
    } else {
        randomAngel1 = -ABS(randomAngel1);
        randomAngel2 = ABS(randomAngel2);
    }
    
    CGAffineTransform transform1 = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * (float)randomAngel1 / 180.0);
    CGAffineTransform transform2 = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * (float)randomAngel2 / 180.0);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 100, 100);
    CGRect rect1 = CGRectApplyAffineTransform(thumbnailRect, transform1);
    CGRect rect2 = CGRectApplyAffineTransform(thumbnailRect, transform2);
    CGRect unionRect = CGRectUnion(rect1, rect2);
    unionRect.size.width = ceil(unionRect.size.width);
    unionRect.size.height = ceil(unionRect.size.height);
    thumbnailRect.origin = CGPointMake(-50, -50);
    
    //
    // render
    //
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             unionRect.size.width,
                                             unionRect.size.height,
                                             8,
                                             unionRect.size.width * 4,
                                             colorSpace,
                                             kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextTranslateCTM(ctx, unionRect.size.width / 2, unionRect.size.height / 2);
    CGContextSaveGState(ctx);
    for (NSInteger index = 0; index < images.count; index++) {
        CGAffineTransform transform = CGAffineTransformIdentity;
        if (index != images.count - 1) {
            if (index % 2 == 0) {
                transform = transform1;
            } else {
                transform = transform2;
            }
        }
        CGContextRestoreGState(ctx);
        CGContextSaveGState(ctx);
        CGContextConcatCTM(ctx, transform);
        CGContextDrawImage(ctx, thumbnailRect, [[images objectAtIndex:index] CGImage]);
    }
    CGContextRestoreGState(ctx);
    
    //
    // get render image
    //
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)getOverlappedImage:(UIImage *)topImage withImage:(UIImage *)bottomImage {
    
    // zfs_2013.11.05_03
    topImage = [self fixOrientation:topImage];
    bottomImage = [self fixOrientation:bottomImage];
    
    CGRect rect1 = CGRectMake(0, 8, 100, 100);
    CGRect rect2 = CGRectOffset(rect1, 8, -8);
    CGRect unionRect = CGRectUnion(rect1, rect2);
    unionRect.size.width = ceil(unionRect.size.width);
    unionRect.size.height = ceil(unionRect.size.height);
    
    //
    // render
    //
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             unionRect.size.width,
                                             unionRect.size.height,
                                             8,
                                             unionRect.size.width * 4,
                                             colorSpace,
                                             kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, rect2);
    rect2.origin.x += 2.0;
    rect2.origin.y += 2.0;
    rect2.size.width -= 4.0;
    rect2.size.height -= 4.0;
    CGContextDrawImage(ctx, rect2, bottomImage.CGImage);
    CGContextFillRect(ctx, rect1);
    rect1.origin.x += 2.0;
    rect1.origin.y += 2.0;
    rect1.size.width -= 4.0;
    rect1.size.height -= 4.0;
    CGContextDrawImage(ctx, rect1, topImage.CGImage);
    
    //
    // get render image
    //
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)tiltSlightly:(CGFloat)angle {
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGRect rotatedRect = CGRectApplyAffineTransform(rect, transform);
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             ceil(rotatedRect.size.width),
                                             ceil(rotatedRect.size.height),
                                             8,
                                             ceil(rotatedRect.size.width) * 4,
                                             space,
                                             kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(space);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    CGContextTranslateCTM(ctx,
                          +(rotatedRect.size.width * 0.5f),
                          +(rotatedRect.size.height * 0.5f));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx,
                       CGRectMake(-self.size.width / 2.0,
                                  -self.size.height / 2.0,
                                  self.size.width,
                                  self.size.height),
                       self.CGImage);
    
    CGImageRef ref = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    
    return newImage;
}

// zfs_2013.9.9_02
- (UIImage *)imageResizeTo:(CGSize)size
          withCornerRadius:(CGFloat)cornerRadius {
    
    CGFloat scale = [UIImage screenScale];
    CGSize targetSize = CGSizeMake(ceil(size.width * scale),
                                   ceil(size.height * scale));
    CGFloat targetCornerRadius = cornerRadius * scale;
    CGRect targetRect = CGRectMake(0.0,
                                   0.0,
                                   targetSize.width,
                                   targetSize.height);
    
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap;
    bitmap = CGBitmapContextCreate(NULL,
                                   targetSize.width,
                                   targetSize.height,
                                   8,
                                   targetSize.width * 4,
                                   colorSpaceInfo,
                                   kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpaceInfo);
    colorSpaceInfo = nil;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:targetRect
                                                     cornerRadius:targetCornerRadius];
    CGContextAddPath(bitmap, path.CGPath);
    CGContextClip(bitmap);
    CGContextDrawImage(bitmap,
                       targetRect,
                       self.CGImage);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    CGContextRelease(bitmap);
    bitmap = nil;
    
    UIImage * newImage = [UIImage imageWithCGImage:ref
                                             scale:scale
                                       orientation:UIImageOrientationUp];
    
    CGImageRelease(ref);
    ref = nil;
    return newImage;
}

// zfs_2013.11.11_03
- (UIImage *)portraitImage {
    return [UIImage fixOrientation:self];
}

+ (BOOL)CGSetQuality:(CGFloat)quality
            fromData:(NSData *)sourceData
              toData:(NSMutableData *)destData
         toImageType:(CFStringRef)imageType
         withOptions:(NSDictionary *)options {
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)sourceData, NULL);
    if (imageSource == NULL) {
        return NO;
    }
    
    CGImageDestinationRef imageDest = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)destData, imageType, 1, NULL);
    if (imageDest == NULL) {
        CFRelease(imageSource);
        return NO;
    }
    
    NSMutableDictionary * dict = (options ?
                                  [NSMutableDictionary dictionaryWithDictionary:options] :
                                  [NSMutableDictionary dictionary]);
    [dict setValue:@(quality) forKey:(NSString*)kCGImageDestinationLossyCompressionQuality];
    
    CGImageDestinationAddImageFromSource(imageDest,
                                         imageSource,
                                         0,
                                         (__bridge CFDictionaryRef)(dict));
    BOOL success = CGImageDestinationFinalize(imageDest);
    
    CFRelease(imageSource);
    CFRelease(imageDest);
    
    return success;
}

- (void)blur:(CGFloat)inputRadius completion:(void (^)(UIImage *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurImage = nil;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            CIContext *cicxt = [CIContext contextWithOptions:nil];
            CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            if (filter) {
                [filter setValue:inputImage forKey:kCIInputImageKey];
                [filter setValue:@(inputRadius) forKey:@"inputRadius"];
                CIImage *result = [filter valueForKey:kCIOutputImageKey];
                CGFloat diff = -result.extent.origin.x;
                CGRect imageInset = CGRectInset(result.extent,
                                                diff,
                                                diff);
                CGImageRef cgImage = [cicxt createCGImage:result fromRect:imageInset];
                if (cgImage) {
                    blurImage = [UIImage imageWithCGImage:cgImage];
                    CGImageRelease(cgImage);
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(blurImage ?: self);
            }
        });
    });
}



@end
