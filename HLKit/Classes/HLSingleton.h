//
//  HLSingleton.h
//  HLIntegrationlibrary
//
//  Created by houli on 2018/8/15.
//  Copyright © 2018年 leohou. All rights reserved.
//

#define WHSingletonH(ClassName) +(instancetype) share##ClassName;


#define WHSingletonM(ClassName) static id _instance;\
\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
\
return _instance;\
}\
\
\
+(instancetype)share##ClassName\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
\
return _instance;\
}\
\
\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
\
- (id)mutableCopyWithZone:(nullable NSZone *)zone\
{\
return _instance;\
}

