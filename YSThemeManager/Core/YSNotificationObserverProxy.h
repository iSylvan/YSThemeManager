//
//  YSNotificationObserverProxy.h
//  NSNotificationCenterDemo
//
//  Created by yt_liyanshan on 2017/12/4.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YSForwardProxy : NSProxy

/**
 The proxy target.
 */
@property (nonatomic, weak, readonly) id target;

/**
 Creates a new weak proxy for target.
 */
+ (instancetype)proxyWithTarget:(id)target;

@end

@interface YSNotificationObserverProxy : YSForwardProxy

@property (nonatomic, strong) NSMutableDictionary<NSNotificationName,NSMutableArray *>* notificationMuSet;
-(void)notificationMuSetAddName:(NSNotificationName)aName object:(id)anObject;
-(void)notificationMuSetRemovName:(NSNotificationName)aName object:(id)anObject;
@end
