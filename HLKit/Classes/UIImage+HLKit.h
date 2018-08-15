//
//  UIImage+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
typedef void (^UIImageSizeRequestCompleted) (NSURL* imgURL, CGSize size);

@interface UIImage (HLKit)
//截屏
+(instancetype)wh_snapshotCurrentScreen;

//图片模糊效果
- (UIImage *)blur;

//高效添加圆角图片
- (UIImage*)wh_imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;

//圆形图片
+ (UIImage *)wh_GetRoundImagewithImage:(UIImage *)image;

//在图片上加居中的文字
- (UIImage *)wh_imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor;

/**
 取图片某一像素点的颜色
 
 @param point 图片上的某一点
 @return 图片上这一点的颜色
 */
- (UIColor *)wh_colorAtPixel:(CGPoint)point;

/**
 生成一个纯色的图片
 
 @param color 图片颜色
 @return 返回的纯色图片
 */
- (UIImage *)wh_imageWithColor:(UIColor *)color;

/** 获得灰度图 */
- (UIImage *)wh_convertToGrayImage;


+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;
+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;


/** 合并两个图片为一个图片 */
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/** 压缩图片 最大字节大小为maxLength */
- (NSData *)compressWithMaxLength:(NSInteger)maxLength;

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;


/** 截取当前image对象rect区域内的图像 */
- (UIImage *)subImageWithRect:(CGRect)rect;

/** 压缩图片至指定尺寸 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/** 压缩图片至指定像素 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;

/** 在指定的size里面生成一个平铺的图片 */
- (UIImage *)getTiledImageWithSize:(CGSize)size;

/** UIView转化为UIImage */
+ (UIImage *)imageFromView:(UIView *)view;

- (UIImage *)imageCroppedToRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;
- (UIImage *)imageScaledToFillSize:(CGSize)size;
- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;

- (UIImage *)reflectedImageWithScale:(CGFloat)scale;
- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;

//带有阴影效果的图片
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
- (UIImage *)imageWithMask:(UIImage *)maskImage;

- (UIImage *)maskImageFromImageAlpha;
#pragma mark - 标记
+ (CGFloat)screenScale;

//- (UIImage *)getSubImage:(CGRect)rect;
- (UIImage *)scaledImage:(CGSize)targetSize;
- (UIImage *)thumbnailWithoutTransform:(CGSize)targetSize; // zfs_2013.8.12_02
#if 0
- (UIImage *)faceImageConstrainedToSize:(CGSize)viewSize;
#endif

- (UIImage *)scaledImageWithTransform:(CGSize)targetSize;
- (UIImage *)clippedImageInRect:(CGRect)rect; // zfs_2013.8.13_03

+ (UIImage *)CGThumbnail:(CGFloat)dimension
               fromImage:(NSString *)path;
+ (UIImage *)CGThumbnail:(CGFloat)dimension
                fromData:(NSData *)data;

- (BOOL)writeToData:(NSMutableData *)data
           withType:(CFStringRef)imageType
            quality:(CGFloat)quality
         andOptions:(NSDictionary *)options;

- (BOOL)writeToFile:(NSString *)file
           withType:(CFStringRef)imageType
            quality:(CGFloat)quality
         andOptions:(NSDictionary *)options;

- (NSData *)JPEGRepresentation:(CGFloat)quality
          saveImageOrientation:(BOOL)saveImageOrientation;

+ (NSInteger)CGImageOrientationFrom:(UIImageOrientation)imageOrientation;
+ (UIImageOrientation)UIImageOrientationFrom:(NSInteger)CGImageOrientation;

+ (UIImage *)getOverlappedImage:(NSArray *)images; // zfs_2013.7.30_02
+ (UIImage *)getOverlappedImage:(UIImage *)topImage withImage:(UIImage *)bottomImage;

- (UIImage *)tiltSlightly:(CGFloat)angle;

- (UIImage *)imageResizeTo:(CGSize)size
          withCornerRadius:(CGFloat)cornerRadius; // zfs_2013.9.9_02

- (UIImage *)portraitImage; // zfs_2013.11.11_03

+ (BOOL)CGSetQuality:(CGFloat)quality
            fromData:(NSData *)sourceData
              toData:(NSMutableData *)destData
         toImageType:(CFStringRef)imageType // eg. kUTTypeJPEG
         withOptions:(NSDictionary *)options;

- (void)blur:(CGFloat)inputRadius completion:(void (^)(UIImage *blurImage))completion;



@end
