//
//  NSString+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#define MD5_LENGTH 16

@interface NSString (HLKit)
//json转数组
- (NSArray *)hl_jsonToArray;

//获取拼音的首字母
- (NSString *)hl_gainPinYinFirstCharacter;

//判断是否是小数
- (BOOL)hl_isFloatNumber;

// 判断是否是整数
- (BOOL)hl_isIntNumber;

//身份证号码验证
- (BOOL)hl_isCardIdValid;

///  追加文档目录
- (NSString *)appendDocumentPath;
///  追加缓存目录
- (NSString *)appendCachePath;
///  追加临时目录
- (NSString *)appendTempPath;


/**
 根据左边和右边的字符串,获得中间特定字符串
 @param strLeft 左边匹配字符串
 @param strRight 右边匹配的字符串
 */
- (NSString*)wh_substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight;

/**
 阿拉伯数字转成中文
 
 @param arebic 阿拉伯数字
 @return 返回的中文数字
 */
+(NSString *)wh_translation:(NSString *)arebic;

/**
 字符串反转
 
 @param str 要反转的字符串
 @return 反转之后的字符串
 */
- (NSString*)wh_reverseWordsInString:(NSString*)str;

/**
 获得汉字的拼音
 
 @param chinese 汉字
 @return 拼音
 */
+ (NSString *)wh_transform:(NSString *)chinese;

/** 判断URL中是否包含中文 */
- (BOOL)isContainChinese;

/** 获取字符数量 */
- (int)wordsCount;

/** JSON字符串转成NSDictionary */
-(NSDictionary *)dictionaryValue;


/**
 *  手机号码的有效性:分电信、联通、移动和小灵通
 */
- (BOOL)isMobileNumberClassification;
/**
 *  手机号有效性
 */
- (BOOL)isMobileNumber;

/**
 *  邮箱的有效性
 */
- (BOOL)isEmailAddress;

/**
 *  简单的身份证有效性
 *
 */
- (BOOL)simpleVerifyIdentityCardNum;

/**
 *  精确的身份证号码有效性检测
 *
 *  @param value 身份证号
 */
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

/**
 *  车牌号的有效性
 */
- (BOOL)isCarNumber;

/**
 *  银行卡的有效性
 */
- (BOOL)bankCardluhmCheck;

/**
 *  IP地址有效性
 */
- (BOOL)isIPAddress;

/**
 *  Mac地址有效性
 */
- (BOOL)isMacAddress;

/**
 *  网址有效性
 */
- (BOOL)isValidUrl;

/**
 *  纯汉字
 */
- (BOOL)isValidChinese;

/**
 *  邮政编码
 */
- (BOOL)isValidPostalcode;

/**
 *  工商税号
 */
- (BOOL)isValidTaxNo;



/** 清除html标签 */
- (NSString *)stringByStrippingHTML;

/** 清除js脚本 */
- (NSString *)stringByRemovingScriptsAndStrippingHTML;

/** 去除空格 */
- (NSString *)trimmingWhitespace;

/** 去除空格与空行 */
- (NSString *)trimmingWhitespaceAndNewlines;



/** 加密 */
- (NSString *)toMD5;
- (NSString *)to16MD5;
- (NSString *)sha1;
- (NSString *)sha256;
- (NSString *)sha512;

#pragma mark - Data convert to string or string to data.
/**
 *    string与Data转化
 */
- (NSData *)toData;
+ (NSString *)toStringWithData:(NSData *)data;


//MD5
// 计算md5，全小写
- (NSString *)md5String;
// 计算md5，全大写
- (NSString *)md5StringInUpperCase;

- (NSData *)md5Data;

- (NSString*)md5Encrypt16;


//URL
- (NSString *)URLEncodedString;
+ (NSString *)getStringFromUrl: (NSString*)url needle:(NSString *)needle;

- (NSString *)WP_URLDecodedString;
- (NSDictionary *)WP_URLParameterDictionary;
- (BOOL)isURLString;
- (NSMutableDictionary *)getURLParameters;


//price
+ (NSString *)stringForShowPrice:(NSInteger)price;
+ (NSAttributedString *)attributeStringForShowPrice:(NSInteger)price;
+ (NSString *)stringForMoviePrice:(CGFloat)price;


//
- (BOOL)isStartWithString:(NSString*)start;
- (BOOL)isEndWithString:(NSString*)end;

- (NSInteger)numberOfLinesWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth;

- (CGFloat)heightWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth;

- (NSString*)md5;
- (NSString*)encodeUrl;


//CompareToVersion
-(NSComparisonResult)compareToVersion:(NSString *)version;

-(BOOL)isOlderThanVersion:(NSString *)version;
-(BOOL)isNewerThanVersion:(NSString *)version;
-(BOOL)isEqualToVersion:(NSString *)version;
-(BOOL)isEqualOrOlderThanVersion:(NSString *)version;
-(BOOL)isEqualOrNewerThanVersion:(NSString *)version;


//fromat
+ (NSString *)stringWithUnichar:(unichar)value;
+ (NSString *)timeFormattedToHHMMSS:(NSInteger)totalSeconds; //HH:MM:SS
+ (NSString *)timeFormattedToHHMM:(NSInteger)totalSeconds; //HH:MM
+ (NSString *)timeFormattedToMMSS:(NSInteger)totalSeconds; //MM:SS
+ (NSString *)timeFormattedToHHMMSSWithoutSplit:(NSInteger)totalSeconds;  //HH:MMSS
+ (NSString *)timeFormattedToHHMMWithSuccess:(NSInteger)totalSeconds;  //H:MM
+ (NSString *)timeFormattedToHHMMWithChinese:(NSTimeInterval)totalSeconds;
- (NSString *)MD5Hash;
//- (unsigned long long)unsignedLongLongValue;

+ (NSString *)stringForLikeCount:(NSInteger)likeCount;



@end
