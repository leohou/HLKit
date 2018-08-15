//
//  HL_WSUKeyChainHelper.h
//  HLIntegrationlibrary
//
//  Created by houli on 2017/6/20.
//  Copyright © 2017年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface HLKeyChainHelper : NSObject
+ (instancetype)keyChainHelperForService:(NSString *)service;

@property (nonatomic, strong) NSString *service;

- (BOOL)addItem:(NSData *)data errorMsg:(NSString **)errorMsg accessControl:(BOOL)accessControl;

- (OSStatus)addItem:(NSData *)data errorMsg:(__autoreleasing NSString **)anErrorMsg protection:(CFTypeRef)protection;

- (BOOL)updateItem:(NSData *)data prompt:(NSString *)prompt errorMsg:(NSString **)errorMsg;
- (BOOL)deleteItemAndReturnErrorMsg:(NSString **)errorMsg;
- (NSData *)queryItem:(NSString *)prompt errorMsg:(NSString **)errorMsg;

- (NSData *)queryItem:(NSString **)anErrorMsg;
- (BOOL)updateItem:(NSData *)data errorMsg:(NSString **)anErrorMsg;

@end
