//
//  HL_GeneralTools.m
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import "HLGeneralTools.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "sys/utsname.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation HLGeneralTools
+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return@"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return@"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return@"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])   return@"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return@"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return@"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return@"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return@"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return@"iPhone X";
    if ([platform isEqualToString:@"iPod1,1"])      return@"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return@"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return@"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return@"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return@"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return@"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])      return@"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])      return@"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return@"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])      return@"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return@"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])      return@"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])      return@"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])      return@"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])      return@"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])      return@"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return@"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])      return@"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return@"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])      return@"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return@"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])      return@"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return@"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])      return@"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])      return@"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return@"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return@"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return@"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])      return@"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,2"])      return@"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,3"])      return@"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return@"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])      return@"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"])      return@"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"])      return@"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])      return@"iPad Pro 12.9";
    if ([platform isEqualToString:@"i386"])         return@"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])       return@"iPhone Simulator";
    return platform;
}

+ (BOOL)isPassword:(NSString *)key
{
    NSPredicate *pwdPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"\\w{6,20}"];
    return [pwdPre evaluateWithObject:key];
}

+ (BOOL)isPhoneNumber:(NSString *)key
{
    NSPredicate *phonePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1\\d{10}"];
    return [phonePre evaluateWithObject:key];
}

+ (BOOL)isEmail:(NSString *)key
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:key];
}

+ (BOOL)isVerificationCode:(NSString *)key
{
    NSString *emailRegex = @"[0-9]{4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:key];
}

+ (BOOL)isZeroBeginString:(NSString *)key
{
    NSString *emailRegex = @"0[0-9]{1}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:key];
}

+ (BOOL)isNumber:(NSString *)key
{
    NSString *emailRegex = @"[0-9]+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:key];
}

+ (int)getLengthOfString:(NSString *)str
{
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (BOOL)isChineseOrABCBegin:(NSString *)str
{
    NSString *emailRegex = @"[a-zA-Z\u4e00-\u9fa5]+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

+ (BOOL)canTel:(NSString *)telStr
{
    telStr = [telStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!(telStr && telStr.length)) {
        return NO;
    }
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telStr]]];
}

+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return  output;
}

+ (NSString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}

+ (BOOL)isValidKey:(NSString*)key
{
    if (!key || [key length] == 0 || (NSNull*)key == [NSNull null]) {
        return NO;
    }
    return YES;
}

+ (NSString *)stringDisposeWithFloat:(float)floatValue
{
    if (floatValue<=0) {
        floatValue=0.01;
    }
    NSString *str = [NSString stringWithFormat:@"%.2f",floatValue];
    int len = (unsigned int)str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        str =[str substringToIndex:[str length]-1];
        if ([str isEqualToString:@"0"]){
            str =@"0.01";
        }
        return str;
        //s.substring(0, len - i - 1);
    }
    else
    {
        if ([str isEqualToString:@"0"]){
            str =@"0.01";
        }
        return str;
    }
}

+(NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString *)hl_fileMD5HashCreateWithPath((__bridge CFStringRef)path, kHLFileHashDefaultChunkSizeForReadingData);
}


CFStringRef hl_fileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData)
{
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = kHLFileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}
+ (BOOL)isIncludeSpecialCharact:(NSString *)str
{
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"!?~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|$_€：；:;%^=，,。、‘`′'！-$"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
+ (BOOL)isChineseOrABCBeginString:(NSString *)str
{
    
    NSString *emailRegex = @"^[a-zA-Z\u4e00-\u9fa5]+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
    
}
+ (BOOL)islength:(NSString *)str
{
    NSString *emailRegex = @"[\u4e00-\u9fa5]{2,12}$|[\\dA-Za-z_]{4,24}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}
//138****0000
+(NSString *)phoneNumberEncryption:(NSString *)phone
{
    if ([self isPhoneNumber:phone]) {
        
        NSString *_phoneString = [NSString stringWithFormat:@"%@****%@",[phone substringToIndex:3],[phone substringFromIndex:7]];
        return _phoneString;
    }
    return nil;
}

//是否为汉字
+ (BOOL)isChinese:(unichar)aChar
{
    if (0x4e00 <= aChar && aChar <= 0x9fa5)
        return YES;
    else if (0x2e80 <= aChar && aChar <= 0x2eff)
        return YES;
    else if (0x31c0 <= aChar && aChar < 0x31ef)
        return YES;
    else if (0x2f00 <= aChar && aChar <= 0x2fdf)
        return YES;
    
    return NO;
}

@end
