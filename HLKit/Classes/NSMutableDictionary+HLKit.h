//
//  NSMutableDictionary+WSUKit.h
//  WSUserSDK
//
//  Created by houli on 2017/6/17.
//  Copyright © 2017年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HLKit)

/*
 判断字典赋值不为空
 
 @param value  字典value
 @param key    字典key
 @return 无
 */

- (void)hl_setValue:(id)value forKey:(NSString *)key;


@end
