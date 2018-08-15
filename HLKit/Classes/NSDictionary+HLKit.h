//
//  NSDictionary+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HLKit)
//获得一般模型属性
-(void)hl_createProperty;

//获得网络模型属性
-(void)hl_createNetProperty;

/** 合并两个NSDictionary */
+ (NSDictionary *)hl_dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;

/** 并入一个NSDictionary */
- (NSDictionary *)hl_dictionaryByMergingWith:(NSDictionary *)dict;

- (NSDictionary *)hl_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)hl_dictionaryByRemovingEntriesWithKeys:(NSSet *)keys;
@end
