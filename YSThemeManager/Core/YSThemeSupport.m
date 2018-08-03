//
//  YSThemeSupport.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import "YSThemeSupport.h"
#import <objc/message.h>

@interface YSThemeSupport ()
@property(nonatomic,strong)NSHashTable * targetSet;
@end

@implementation YSThemeSupport

+ (instancetype)sharedSupport{
    static id instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.targetSet = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)resumeThemeChangedHandler{
    [self themeChangedHandle];
}

#pragma mark -  core

const char *themeChangedHandlerSels = "themeChangedHandlerSels";
const char *themeChangedHandlerOperations = "themeChangedHandlerOperations";
const char *themeChangedHandlerOperations2 = "themeChangedHandlerOperations2";

#pragma mark themeChangedHandle0 (NSMutableSet *)

/** 设置当皮肤样式改变时，target 回调的方法 不会立刻调用*/
-(void)addThemeChangedHandler0ToTarget:(__kindof NSObject *)target sel:(SEL)sel{
    if (target) {
        //储存sel
        NSMutableSet * sels = objc_getAssociatedObject(target, themeChangedHandlerSels);
        if (!sels) {
            sels = [NSMutableSet set];
            objc_setAssociatedObject(target, themeChangedHandlerSels, sels, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [sels addObject:NSStringFromSelector(sel)];
        //储存target
        [self.targetSet addObject:target];
    }
}

/** 移除 target 回调的方法*/
-(void)removeThemeChangedHandler0FromTarget:(__kindof NSObject *)target sel:(SEL)sel{
    if (target) {
        NSMutableSet * sels = objc_getAssociatedObject(target, themeChangedHandlerSels);
        if (sels) {
            [sels removeObject:NSStringFromSelector(sel)];
        }
    }
}

#pragma mark themeChangedHandle1 (NSMutableSet *)
/** 设置当皮肤样式改变时，由target管理生命周期的operation 不会立刻调用 ,成功返回operation，失败返回nil*/
-(YSThemeChangedHandleOperation)addThemeChangedHandler1ToTarget:(__kindof NSObject *)target operation:(YSThemeChangedHandleOperation)operation{
    if (target) {
        NSMutableSet * operations = objc_getAssociatedObject(target, themeChangedHandlerOperations);
        if (!operations) {
            operations = [NSMutableSet set];
            objc_setAssociatedObject(target, themeChangedHandlerOperations, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [operations addObject:operation];
        //储存target
        [self.targetSet addObject:target];
        return operation;
    }
    return nil;
}

-(void)removeThemeChangedHandler1Form:(__kindof NSObject *)target{
    if (target) {
        NSMutableSet * operations = objc_getAssociatedObject(target, themeChangedHandlerOperations);
        if (operations) {
            operations = [NSMutableSet set];
        }
    }
}

#pragma mark themeChangedHandle2 (NSMutableDictionary *)
/** 设置当皮肤样式改变时，由target管理生命周期的operation 不会立刻调用 ,成功返回operation，失败返回nil*/
-(YSThemeChangedHandleOperation)setThemeChangedHandler2ToTarget:(__kindof NSObject *)target operationKey:(NSString *)operationKey operation:(YSThemeChangedHandleOperation)operation{
    if (target&&operationKey) {
        NSMutableDictionary * operations = objc_getAssociatedObject(target, themeChangedHandlerOperations2);
        if (!operations) {
            operations = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(target, themeChangedHandlerOperations2, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [operations setObject:operation forKey:operationKey];
        //储存target
        [self.targetSet addObject:target];
        return operation;
    }
    return nil;
}

-(void)removeThemeChangedHandler2From:(__kindof NSObject *)target operationKey:(NSString *)operationKey{
    if (target&&operationKey) {
        NSMutableDictionary * operations = objc_getAssociatedObject(target, themeChangedHandlerOperations2);
        if (operations) {
            [operations removeObjectForKey:operationKey];
        }
    }
}

-(void)removeThemeChangedHandler2From:(__kindof NSObject *)target{
    if (target) {
        NSMutableDictionary * operations = objc_getAssociatedObject(target, themeChangedHandlerOperations2);
        if (operations) {
            operations = [NSMutableDictionary dictionary];
        }
    }
}

#pragma mark -  themeUpdate

-(void)themeChangedHandle
{
    NSArray * arr = self.targetSet.allObjects;
    [arr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self themeChangedObserverUpdatetheme:obj];
    }];
}

-(void)themeChangedObserverUpdatetheme:(NSObject *)target{
        //SELs
        NSMutableSet * sels = objc_getAssociatedObject(target, themeChangedHandlerSels);
        NSSet * set = [sels copy];
        [set enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            SEL sel = NSSelectorFromString(obj);
            if (sel&&[target respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [target performSelector:sel];
#pragma clang diagnostic pop
            }
        }];
        
        //Operations
        NSMutableSet * blocks = objc_getAssociatedObject(target, themeChangedHandlerOperations);
        NSSet * arr = [blocks copy];
        [arr  enumerateObjectsUsingBlock:^(YSThemeChangedHandleOperation _Nonnull obj, BOOL * _Nonnull stop) {
            obj(target);
        }];
        
        //OperationDic || Operations2
        NSMutableDictionary * operationDic = objc_getAssociatedObject(target, themeChangedHandlerOperations2);
        NSDictionary * dict = [operationDic copy];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, YSThemeChangedHandleOperation  _Nonnull obj, BOOL * _Nonnull stop) {
            obj(target);
        }];
}

@end
