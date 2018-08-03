//
//  NSNotificationCenter+securityFunction.h
//  NSNotificationCenterDemo
//
//  Created by yasin on 2017/12/4.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YSNotificationObserverProxy;

@interface NSNotificationCenter (securityFunction)

- (void)ys_addObserver:(__kindof NSObject *)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(nullable id)anObject;
- (void)ys_removeObserver:(__kindof NSObject *)observer name:(nullable NSNotificationName)aName object:(nullable id)anObject;
@end
NS_ASSUME_NONNULL_END
