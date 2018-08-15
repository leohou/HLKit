//
//  UINavigationController+HLKit.m
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import "UINavigationController+HLKit.h"

@implementation UINavigationController (HLKit)
- (id)findViewController:(Class)className;
{
    for (UIViewController *viewController in self.viewControllers)
    {
        if ([viewController isKindOfClass:className])
        {
            return viewController;
        }
    }
    
    return nil;
}

- (BOOL)isOnlyContainRootViewController
{
    if (self.viewControllers && self.viewControllers.count == 1)
    {
        return YES;
    }
    return NO;
}

- (UIViewController *)rootViewController
{
    if (self.viewControllers && [self.viewControllers count] >0)
    {
        return [self.viewControllers firstObject];
    }
    return nil;
}

- (NSArray *)popToViewControllerWithClassName:(Class)className animated:(BOOL)animated;
{
    return [self popToViewController:[self findViewController:className] animated:YES];
}

- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated
{
    NSInteger viewControllersCount = self.viewControllers.count;
    if (viewControllersCount > level) {
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController *viewController = self.viewControllers[idx];
        return [self popToViewController:viewController animated:animated];
    } else {
        return [self popToRootViewControllerAnimated:animated];
    }
}


- (void)pushViewController:(UIViewController *)controller withTransition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    [self pushViewController:controller animated:NO];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (UIViewController *)popViewControllerWithTransition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    UIViewController *controller = [self popViewControllerAnimated:NO];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
    return controller;
}


@end
