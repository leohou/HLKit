//
//  HLMethods.m
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/15.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import "HLMethods.h"

@interface HLMethods ()

@end

@implementation HLMethods

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (void)hl_setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
        statusBar.backgroundColor = color;
    }
}


+(void)hl_addBackgroundImageWithImageName:(NSString *)imageName forViewController:(UIViewController *)viewController {
    //给控制器添加背景图片
    UIImage *oldImage = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(viewController.view.frame.size, NO, 0.0);
    [oldImage drawInRect:viewController.view.bounds];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    viewController.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}


+ (CGFloat) hl_maxNumberFromArray:(NSArray *)array {
    CGFloat max = 0;
    max =[[array valueForKeyPath:@"@max.floatValue"] floatValue];
    return max;
}

+ (CGFloat) hl_minNumberFromArray:(NSArray *)array{
    CGFloat min = 0;
    min =[[array valueForKeyPath:@"@min.floatValue"] floatValue];
    return min;
}

+ (CGFloat) hl_sumNumberFromArray:(NSArray *)array{
    CGFloat sum = 0;
    sum = [[array valueForKeyPath:@"@sum.floatValue"] floatValue];
    return sum;
}

+ (CGFloat) hl_averageNumberFromArray:(NSArray *)array{
    CGFloat avg = 0;
    avg = [[array valueForKeyPath:@"@avg.floatValue"] floatValue];
    return avg;
}


+ (CGFloat) hl_usableHardDriveCapacity {
    CGFloat usable = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    usable = [attributes[NSFileSystemFreeSize] doubleValue] / powf(1024, 3);
    NSLog(@"可用%.2fG",[attributes[NSFileSystemFreeSize] doubleValue] / powf(1024, 3));
    return usable;
}


+ (CGFloat) hl_allHardDriveCapacity {
    CGFloat all = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    all = [attributes[NSFileSystemSize] doubleValue] / (powf(1024, 3));
    NSLog(@"容量%.2fG",[attributes[NSFileSystemSize] doubleValue] / (powf(1024, 3)));
    return all;
}


@end
