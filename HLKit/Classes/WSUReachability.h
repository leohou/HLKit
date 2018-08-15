//
//  WSReachability.h
//  WSUserSDK
//
//  Created by houli on 2017/6/16.
//  Copyright © 2017年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

/**
 * Create NS_ENUM macro if it does not exist on the targeted version of iOS or OS X.
 *
 * @see http://nshipster.com/ns_enum-ns_options/
 **/
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

extern NSString *const kWSUReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, WSUNetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    WSUNotReachable = 0,
    WSUReachableViaWiFi = 2,
    WSUReachableViaWWAN = 1
};
@class WSUReachability ;

typedef void (^WSUNetworkReachable)(WSUReachability * reachability);
typedef void (^WSUNetworkUnreachable)(WSUReachability * reachability);


@interface WSUReachability : NSObject
@property (nonatomic, copy) WSUNetworkReachable    reachableBlock;
@property (nonatomic, copy) WSUNetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(WSUReachability*)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(WSUReachability*)reachabilityWithHostName:(NSString*)hostname;
+(WSUReachability*)reachabilityForInternetConnection;
+(WSUReachability*)reachabilityWithAddress:(void *)hostAddress;
+(WSUReachability*)reachabilityForLocalWiFi;

-(WSUReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(WSUNetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;

@end
