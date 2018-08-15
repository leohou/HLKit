//
//  NSArray+HLKit.m
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import "NSArray+HLKit.h"

@implementation NSArray (HLKit)

- (instancetype)objectAt:(NSUInteger)index
{
    @synchronized (self) {
        NSUInteger count =[self count];
        if (index < count) {
            return [self objectAtIndex:index];
        }
        
        return nil;
    }
}

- (NSString *)toJsonString
{
    
    return [[NSString alloc] initWithData:[self toJSONData:self]
                                 encoding:NSUTF8StringEncoding];
    
    
}

- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
    
}

- (NSArray *)hl_distinctSameElements{
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithArray:self];
    return [set array];
}
//反转数组
- (NSArray *)hl_reverseArray{
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [arrayTemp addObject:element];
    }
    return arrayTemp;
}
@end
