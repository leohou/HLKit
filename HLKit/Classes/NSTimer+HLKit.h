//
//  NSTimer+HLKit.h
//  HLIntegrationlibrary_Example
//
//  Created by houli on 2018/8/14.
//  Copyright © 2018年 leohou. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^TimerCallback)(NSTimer *timer);
@interface NSTimer (HLKit)
+ (NSTimer *)wh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                      callback:(TimerCallback)callback;

+ (NSTimer *)wh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         count:(NSInteger)count
                                      callback:(TimerCallback)callback;

/** 暂停NSTimer */
- (void)pauseTimer;

/** 开始NSTimer */
- (void)resumeTimer;

/** 延迟开始NSTimer */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
