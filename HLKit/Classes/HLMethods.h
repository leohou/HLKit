//
//  HLMethods.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/15.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLMethods : UIViewController
//更改iOS状态栏的颜色
+ (void)hl_setStatusBarBackgroundColor:(UIColor *)color;

//为控制器添加背景图片
+ (void)hl_addBackgroundImageWithImageName:(NSString *)imageName forViewController:(UIViewController *)viewController;

//最大,最小,和,平均
+ (CGFloat) hl_maxNumberFromArray:(NSArray *)array;
+ (CGFloat) hl_minNumberFromArray:(NSArray *)array;
+ (CGFloat) hl_sumNumberFromArray:(NSArray *)array;
+ (CGFloat) hl_averageNumberFromArray:(NSArray *)array;

//可用硬件容量
+ (CGFloat) hl_usableHardDriveCapacity;
//硬件总容量
+ (CGFloat) hl_allHardDriveCapacity;

@end
