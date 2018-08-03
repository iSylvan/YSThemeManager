//
//  NSNotificationCenter+securityFunction.m
//  NSNotificationCenterDemo
//
//  Created by yasin on 2017/12/4.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import "NSNotificationCenter+securityFunction.h"
#import "YSNotificationObserverProxy.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

const char NotificationObserverProxyKey = '\0';
@interface NSObject(securityFunction)
@property(nonatomic,strong)YSNotificationObserverProxy * ys_notificationObserverProxy;
@end
@implementation NSObject (securityFunction)

-(void)setYs_notificationObserverProxy:(YSNotificationObserverProxy *)ys_notificationObserverProxy{
    objc_setAssociatedObject(self, &NotificationObserverProxyKey, ys_notificationObserverProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(YSNotificationObserverProxy *)ys_notificationObserverProxy{
   return  objc_getAssociatedObject(self, &NotificationObserverProxyKey);
}

-(void)makeNotificationObserverProxy{
    if (!self.ys_notificationObserverProxy) {
        self.ys_notificationObserverProxy = [YSNotificationObserverProxy proxyWithTarget:self];
    }
}
@end;


@implementation NSNotificationCenter (securityFunction)

- (void)ys_addObserver:(__kindof NSObject *)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0){
        [observer makeNotificationObserverProxy];
        [self addObserver:observer.ys_notificationObserverProxy selector:aSelector name:aName object:anObject];
//        [observer.ys_notificationObserverProxy notificationMuSetAddName:aName object:anObject];
    }else{
        [self addObserver:observer selector:aSelector name:aName object:anObject];
    }
}


- (void)ys_removeObserver:(__kindof NSObject *)observer name:(nullable NSNotificationName)aName object:(nullable id)anObject{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0){
        if (observer.ys_notificationObserverProxy) {
             [self removeObserver:observer.ys_notificationObserverProxy name:aName object:anObject];
//             [observer.ys_notificationObserverProxy notificationMuSetRemovName:aName object:anObject];
        }
    }else{
        [self removeObserver:observer name:aName object:anObject];
    }
}

@end
