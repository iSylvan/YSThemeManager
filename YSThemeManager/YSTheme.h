//
//  YSTheme.h
//  YSThemeManagerExample
//
//  Created by liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#ifndef YSTheme_h
#define YSTheme_h

#import "YSSkinItem.h"
#import "YSThemeSupport.h"
#import "NSObject+YSThemeSupport.h"

//#define YT_SkinCollectorGenerated(class, property) _color_claify(class, property)
//#define _color_claify(CLASSNAME, PROPERTY) \
//@interface \
//CLASSNAME (YTSkin) \
//@property (nonatomic, strong) YT_SkinCollector *yt_ ## PROPERTY ## Collector; \
//@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, YT_SkinCollector *> *collectors;\
//@end \
//@implementation \
//CLASSNAME (YTSkin) \
//- (YT_SkinCollector *)yt_ ## PROPERTY ## Collector { \
//return objc_getAssociatedObject(self, @selector(yt_ ## PROPERTY ## Collector)); \
//} \
//- (void)setYt_ ## PROPERTY ## Collector:(YT_SkinCollector *)yt_ ## PROPERTY ## Collector { \
//objc_setAssociatedObject(self, @selector(yt_ ## PROPERTY ## Collector), yt_ ## PROPERTY ## Collector, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
//[self setValue:yt_ ## PROPERTY ## Collector.yt_skin forKey:(@#PROPERTY)];\
//[self.collectors setObject:yt_ ## PROPERTY ## Collector forKey:(@#PROPERTY)]; \
//} \
//@end

#endif /* YSTheme_h */
