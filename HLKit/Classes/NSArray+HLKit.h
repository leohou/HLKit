//
//  NSArray+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HLKit)
/*
 数组取值
 @param index  数组索引
 @return 索引对应值
 */
- (instancetype)objectAt:(NSUInteger)index;

/*
 数组序列化成JSON字符串
 @return JSON字符串
 */
- (NSString *)toJsonString;

//数组去重复
- (NSArray *)hl_distinctSameElements;
/**
 反转数组
 
 @return 完成反转的数组
 */
- (NSArray *)hl_reverseArray;
@end
