//
//  UIViewController+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/15.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HLKit)
//找到当前视图控制器
+ (UIViewController *)wh_currentViewController;

//找到当前导航控制器
+ (UINavigationController *)wh_currentNavigatonController;

/**
 * 在当前视图控制器中添加子控制器，将子控制器的视图添加到 view 中
 *
 * @param childController 要添加的子控制器
 * @param view            要添加到的视图
 */
- (void)wh_addChildController:(UIViewController *)childController intoView:(UIView *)view;
@end
