//
//  YSThemeSupport.h
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSTheme;
typedef void (^YSThemeChangedHandleOperation)(id Target);

@interface YSThemeSupport : NSObject

+ (instancetype)sharedSupport;

- (void)resumeThemeChangedHandler;

#pragma mark themeChangedHandle0

/** 设置当皮肤样式改变时，target 回调的方法 不会立刻调用*/
-(void)addThemeChangedHandler0ToTarget:(__kindof NSObject *)target sel:(SEL)sel;

/** 移除 target 回调的方法*/
-(void)removeThemeChangedHandler0FromTarget:(__kindof NSObject *)target sel:(SEL)sel;

#pragma mark themeChangedHandle1
/** 设置当皮肤样式改变时，由target管理生命周期的operation 不会立刻调用 ,成功返回operation，失败返回nil*/
-(YSThemeChangedHandleOperation)addThemeChangedHandler1ToTarget:(__kindof NSObject *)target operation:(YSThemeChangedHandleOperation)operation;

-(void)removeThemeChangedHandler1Form:(__kindof NSObject *)target;

#pragma mark themeChangedHandle2
/** 设置当皮肤样式改变时，由target管理生命周期的operation 不会立刻调用 ,成功返回operation，失败返回nil*/
-(YSThemeChangedHandleOperation)setThemeChangedHandler2ToTarget:(__kindof NSObject *)target operationKey:(NSString *)operationKey operation:(YSThemeChangedHandleOperation)operation;
-(void)removeThemeChangedHandler2From:(__kindof NSObject *)target operationKey:(NSString *)operationKey;
-(void)removeThemeChangedHandler2From:(__kindof NSObject *)target;

@end
