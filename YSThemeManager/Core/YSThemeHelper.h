//
//  YSThemeHelper.h
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const YSThemeErrorDomain;

@interface YSThemeHelper : NSObject


+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIImage *)imageFromColor:(UIColor *)color;

+ (UIImage *)imageFromName:(NSString *)name imageBasePath:(NSString *)imageBasePath;

+ (NSError *)makeErrorDesc:(NSString *)desc,...;

+ (NSDictionary *)dictFromCheckTypeForPath:(NSString *)path;
+ (NSDictionary *)jsonDictionaryWithContentsOfFile:(NSString *)string;
+ (NSDictionary *)trimmingKeyWithDictionary:(NSDictionary *)dict;

@end

typedef id (^YSWeakReference)(void);
YSWeakReference ys_weakReference(id object);
id ys_objFromWeakReference(YSWeakReference ref);
