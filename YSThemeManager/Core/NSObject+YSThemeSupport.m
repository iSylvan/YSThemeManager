//
//  NSObject+YSThemeSupport.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2018/2/22.
//  Copyright © 2018年 iSylvan. All rights reserved.
//

#import "NSObject+YSThemeSupport.h"
#import <objc/runtime.h>
#import "NSNotificationCenter+securityFunction.h"
#import "YSThemePrivate.h"

@interface NSObject ()

@property (nonatomic,assign) BOOL ys_hadSkinSupport;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, YSSkinItem *> *ys_collectors;
@end

@implementation NSObject (YSThemeSupport)

-(BOOL)ys_hadSkinSupport{
    NSNumber * num  = objc_getAssociatedObject(self, _cmd);
    return [num boolValue];
}
-(void)setYs_hadSkinSupport:(BOOL)ys_hadSkinSupport{
    NSNumber * num  = [NSNumber numberWithBool:ys_hadSkinSupport];
    objc_setAssociatedObject(self, @selector(ys_hadSkinSupport), num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary<NSString *,YSSkinItem *> *)ys_collectors{
     NSMutableDictionary * collectors  = objc_getAssociatedObject(self, _cmd);
    if (!collectors) {
        collectors = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, collectors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self ys_addThemeSupport];
    }
    return collectors;
}

-(void)ys_addThemeSupport{
    if (self.ys_hadSkinSupport) return;
    self.ys_hadSkinSupport = YES;
    [[NSNotificationCenter defaultCenter] ys_addObserver:self selector:@selector(ys_handleCurrentThemeChange) name:YSCurrentThemeChangedNotification object:nil];
}

#pragma mark 换肤回调

-(void)ys_handleCurrentThemeChange{
    [self.ys_collectors enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YSSkinItem * _Nonnull obj, BOOL * _Nonnull stop) {
        [self ys_resolverKeyPath:key andUpdateUIWithSkinItem:obj];
    }];
}

#pragma mark 添加 SkinItem

//KVC 设置控件属性
-(void)ys_setSkinItem:(YSSkinItem * _Nullable)skinItem forKeyPath:(NSString *)keyPath{
    if (keyPath&&skinItem) {
        //设置属性
        [self ys_resolverKeyPath:keyPath andUpdateUIWithSkinItem:skinItem];
        //储存collector
        [self.ys_collectors setObject:skinItem forKey:keyPath];
    }
}

-(YSSkinItem * _Nullable)ys_getSkinItemForKeyPath:(NSString *)keyPath{
    if (keyPath) {
        return  [self.ys_collectors objectForKey:keyPath];
    }
    return nil;
}

//子类重写
-(void)ys_resolverKeyPath:(NSString *)key andUpdateUIWithSkinItem:(YSSkinItem *)item{
    if (item.skinWorkBlock) {
        item.skinWorkBlock(item, self);
    }else{
        id value = item.skin;
        if (item.renderSkinBlock) {
            value = item.renderSkinBlock(item);
        }
        if (value) {
            [self setValue:value forKeyPath:key];
        }
    }
}


@end
