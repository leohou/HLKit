
#ifndef iTotemFrame_ITTCommonMacros_h
#define iTotemFrame_ITTCommonMacros_h
////////////////////////////////////////////////////////////////////////////////
#pragma mark - shortcuts

#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth  ([UIScreen mainScreen].bounds.size.width)

////////////////////////////////////////////////////////////////////////////////
#pragma mark - iOS 7 detection functions

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0f)
#define IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0f)
#define IOS2 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0f)
////////////////////////////////////////////////////////////////////////////////
#pragma mark - iphone 5 detection functions

#define SCREEN_HEIGHT_OF_IPHONE5 568

#define is4InchScreen() ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE5)

#define isLess4InchScreen() ([UIScreen mainScreen].bounds.size.height < SCREEN_HEIGHT_OF_IPHONE5)
////////////////////////////////////////////////////////////////////////////////
#pragma mark - iphone 6 detection functions

#define SCREEN_HEIGHT_OF_IPHONE6 667

#define is5InchScreen() ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE6)
////////////////////////////////////////////////////////////////////////////////

#pragma mark - iphone 6p detection functions
#define SCREEN_HEIGHT_OF_IPHONE6P 736

#define is5_5InchScreen() ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE6P)
////////////////////////////////////////////////////////////////////////////////
#pragma mark - degrees/radian functions 

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define radianToDegrees(radian) (radian*180.0)/(M_PI)

////////////////////////////////////////////////////////////////////////////////
#pragma mark - color functions 

#define SHOULDOVERRIDE(basename, subclassname){ NSAssert([basename isEqualToString:subclassname], @"subclass should override the method!");}
#endif
