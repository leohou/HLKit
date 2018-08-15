# HLKit
开发小工具

### 使用方法
```objc
pod 'HLKit', '~>0.1'
如果没找到, 请先pod setup

也可以直接在本网页下载，然后把WHKit文件加入到工程中使用

在使用的地方：#import "HLKit.h"
推荐直接在pch文件中：#import "HLKit.h"
```
### 这个文件中包含了如下内容
```objc
/************* 分类 *************/
#import "NSArray+HLKit.h"
#import "NSDate+HLKit.h"
#import "NSDictionary+HLKit.h"
#import "NSFileManager+HLKit.h"
#import "NSNumber+HLKit.h"
#import "NSObject+HLKit.h"
#import "NSObject+HLRuntime.h"
#import "NSString+HLKit.h"
#import "NSTimer+HLKit.h"
#import "UIBarButtonItem+HLKit.h"
#import "UIButton+HLKit.h"
#import "UIColor+HLKit.h"
#import "UIDevice+HLKit.h"
#import "UIImage+HLKit.h"
#import "UILabel+HLKit.h"
#import "UINavigationController+HLKit.h"
#import "UIScrollView+HLKit.h"
#import "UITableView+HLKit.h"
#import "UIView+HLKit.h"
#import "UIViewController+HLKit.h"
#import "HLMethods.h"
#import "HLSerializeKit.h"
#import "HLSingleton.h"
#import "CALayer+HLLayer.h"
#import "UIAlertController+HLKit.h"
#import "Foundation+HLSafe.h"
/******************************/



/************* 宏 *************/
#import "HLMacro.h"
/******************************/
```

### 例子 Example
```objc
//点击按钮
[button hl_addActionHandler:^{
NSLog(@"我被点击了");
}];

//是否为iPhone X的宏，返回BOOL值
#define kIs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//快速创建单例
HLSingletonH(ClassName)
HLSingletonM(ClassName)

//快速创建一个Button, 其中KBLACK_COLOR是颜色的宏
UIButton *button = [UIButton HL_buttonWithTitle:@"Test" backColor:KBLACK_COLOR backImageName:nil titleColor:KWHITE_COLOR fontSize:14 frame:CGRectMake(100, 100, 50, 50) cornerRadius:7];

//改变手机状态栏的颜色
[HLMethods hl_setStatusBarBackgroundColor:[UIColor lightGrayColor]];

//高效添加圆角图片
- (UIImage*)hl_imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;

/** mac地址*/
NSString *macAddress = [UIDevice macAddress];

/**反转数组*/
- (NSArray *)hl_reverseArray;

//获得一般模型属性
-(void)hl_createProperty;

/**根据左边和右边的字符串,获得中间特定字符串*/
- (NSString*)hl_substringWithinBoundsLeft:(NSString*)strLeft right:(NSString*)strRight;

/**@brief  渐变颜色*/
+ (UIColor*)hl_gradientFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor withHeight:(CGFloat)height;
```

### MIT LICENSE
