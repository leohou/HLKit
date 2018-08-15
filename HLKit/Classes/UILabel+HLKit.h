//
//  UILabel+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HLKit)
// 快速创建标签
+(instancetype)wh_labelWithText:(NSString *)text textFont:(int)font textColor:(UIColor *)color frame:(CGRect)frame;

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;

/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;

@end
