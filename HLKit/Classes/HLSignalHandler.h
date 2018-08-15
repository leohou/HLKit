//
//  HLSignalHandler.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSignalHandler : NSObject
+(void)hl_saveCreash:(NSString *)exceptionInfo;

@end
void hl_InstallSignalHandler(void);
