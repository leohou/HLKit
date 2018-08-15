//
//  NSMutableDictionary+WSUKit.m
//  WSUserSDK
//
//  Created by houli on 2017/6/17.
//  Copyright © 2017年 leohou. All rights reserved.
//

#import "NSMutableDictionary+HLKit.h"

@implementation NSMutableDictionary (HLKit)

- (void)hl_setValue:(id)value forKey:(NSString *)key
{
    id tempValue = value;
    if (!tempValue
        || [tempValue isKindOfClass:[NSNull class]]
        || !key
        || ![key isKindOfClass:[NSString class]]
        ) {
        return;
    }
    self[key] = tempValue;
}

@end
