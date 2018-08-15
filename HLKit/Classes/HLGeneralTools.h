//
//  HL_GeneralTools.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kHLFileHashDefaultChunkSizeForReadingData 1024*8
@interface HLGeneralTools : NSObject
//  获取设备型号
+ (NSString *)getCurrentDeviceModel;

+(NSString*)getFileMD5WithPath:(NSString*)path;

//是否是密码格式
+ (BOOL)isPassword:(NSString *)key;

//是否是手机号格式
+ (BOOL)isPhoneNumber:(NSString *)key;

//是否是邮箱格式
+ (BOOL)isEmail:(NSString *)key;

//是否是验证码格式
+ (BOOL)isVerificationCode:(NSString *)key;

//是否是以0开始的
+ (BOOL)isZeroBeginString:(NSString *)key;

//是否是数字
+ (BOOL)isNumber:(NSString *)key;

//是否可以打电话
+ (BOOL)canTel:(NSString *)telStr;

//转换为MD5
+ (NSString *)md5:(NSString *)input;

//转换为sha1
+ (NSString *)sha1:(NSString *)input;

//获取IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

//获取IP地址
+ (NSDictionary *)getIPAddresses;

//获取字符长度（中文为两个字符）
+ (int)getLengthOfString:(NSString *)str;

//是否以中文和应为显示
+ (BOOL)isChineseOrABCBegin:(NSString *)str;

//指定key值是否为空
+ (BOOL)isValidKey:(NSString*)key;

//把float中最后的小数点都去掉
+ (NSString *)stringDisposeWithFloat:(float)floatValue;

+ (BOOL)isChineseOrABCBeginString:(NSString *)str;

//是否含有非法字符
+ (BOOL)isIncludeSpecialCharact: (NSString *)str;
+ (BOOL)islength: (NSString *)str;

//手机号 加密格式 138****0000
+ (NSString *)phoneNumberEncryption:(NSString *)phone;

//是否为汉字
+ (BOOL)isChinese:(unichar)aChar;
@end
