//
//  UIView+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TapActionBlock)(UITapGestureRecognizer *gestureRecoginzer);
typedef void (^LongPressActionBlock)(UILongPressGestureRecognizer *gestureRecoginzer);


@interface UIView (HLKit)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
//截取成图片
- (UIImage *)hl_snapshotImage;

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)hl_addTapActionWithBlock:(TapActionBlock)block;

/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)hl_addLongPressActionWithBlock:(LongPressActionBlock)block;

/** 找到指定类名的subView */
- (UIView *)hl_findSubViewWithClass:(Class)clazz;
- (NSArray *)hl_findAllSubViewsWithClass:(Class)clazz;

/** 找到指定类名的superView对象 */
- (UIView *)hl_findSuperViewWithClass:(Class)clazz;

/** 找到view上的第一响应者 */
- (UIView *)hl_findFirstResponder;

/** 找到当前view所在的viewcontroler */
- (UIViewController *)hl_findViewController;

//所有子视图
- (NSArray *)hl_allSubviews;

//移除所有子视图
- (void)hl_removeAllSubviews;


//xib加载视图
+ (instancetype)hl_loadViewFromNib;
+ (instancetype)hl_loadViewFromNibWithName:(NSString *)nibName;
+ (instancetype)hl_loadViewFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)hl_loadViewFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;

/**
 * 给UIView 设置圆角
 */
@property (assign,nonatomic) IBInspectable NSInteger cornerRadius;
@property (assign,nonatomic) IBInspectable BOOL  masksToBounds;

/**
 * 设置 view的 边框颜色(选择器和Hex颜色)
 * 以及 边框的宽度
 */
@property (assign,nonatomic) IBInspectable NSInteger borderWidth;
@property (strong,nonatomic) IBInspectable NSString  *borderHexRgb;
@property (strong,nonatomic) IBInspectable UIColor   *borderColor;

//viewBorderWith
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

@end
