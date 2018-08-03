//
//  NSObject+YSThemeSupport.h
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2018/2/22.
//  Copyright © 2018年 iSylvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSSkinItem.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (YSThemeSupport)

//KVC 设置控件属性
-(void)ys_setSkinItem:(YSSkinItem * _Nullable)skinItem forKeyPath:(NSString *)keyPath;

-(YSSkinItem * _Nullable)ys_getSkinItemForKeyPath:(NSString *)keyPath;

//子类重写
-(void)ys_resolverKeyPath:(NSString *)key andUpdateUIWithSkinItem:(YSSkinItem *)item;

@end
NS_ASSUME_NONNULL_END
