//
//  YSNotificationObserverProxy.m
//  NSNotificationCenterDemo
//
//  Created by yt_liyanshan on 2017/12/4.
//  Copyright © 2017年 Yasin. All rights reserved.
//

#import "YSNotificationObserverProxy.h"
#import "YSThemePrivate.h"

@implementation YSForwardProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[self alloc] initWithTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

@end

#pragma mark - >>-

@implementation YSNotificationObserverProxy

-(NSMutableDictionary<NSNotificationName,NSMutableArray *> *)notificationMuSet{
    if (!_notificationMuSet) {
        _notificationMuSet = [NSMutableDictionary dictionary];
    }
    return _notificationMuSet;
}

-(void)notificationMuSetAddName:(NSNotificationName)aName object:(id)anObject{
    NSMutableArray * objects = [self.notificationMuSet objectForKey:aName];
    if (!objects) {
        objects = [NSMutableArray array];
        [self.notificationMuSet setObject:objects forKey:aName];
    }
    if (anObject) {
        [objects addObject:anObject];
    }
}

-(void)notificationMuSetRemovName:(NSNotificationName)aName object:(id)anObject{
    if (anObject) {
        NSMutableArray * objects = [self.notificationMuSet objectForKey:aName];
        [objects removeObject:anObject];
    }else{
        [self.notificationMuSet removeObjectForKey:aName];
    }
}

-(void)freeNotificationMuSet{
     self.notificationMuSet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc{
    [self freeNotificationMuSet];
}

@end
