//
//  YSThemeHelper.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import "YSThemeHelper.h"
#import "YSPathParser.h"

NSString *const YSThemeErrorDomain = @"YSThemeErrorDomain";

@implementation NSString (YSThemeHelper)

- (NSString *)stringByAppendingPathScaleString:(NSString *)scaleString {
    if (self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    return [self stringByReplacingCharactersInRange:extRange withString:scaleString];
}

@end

@implementation YSThemeHelper

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (!hexString) return nil;
    NSString* hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"])
        hex = [hex substringFromIndex:1];
    if (hex.length == 6)
        hex = [hex stringByAppendingString:@"FF"];
    else if (hex.length != 8) return nil;
    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    UIColor *color = [UIColor colorWithRed:((rgba >> 24)&0xFF) / 255. green:((rgba >> 16)&0xFF) / 255. blue:((rgba >> 8)&0xFF) / 255. alpha:(rgba&0xFF) / 255.];
    return color;
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)imageFromName:(NSString *)name imageBasePath:(NSString *)imageBasePath{
    UIImage * image;
    if (imageBasePath.ys_isNotEmpty) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *bundlePath = mainBundle.resourcePath;
        if([imageBasePath hasPrefix:bundlePath]){ // main bundle
            if ([imageBasePath isEqualToString:bundlePath]) {
                image = [UIImage imageNamed:name];
            }else{
                NSBundle *bundle = [NSBundle bundleWithPath:imageBasePath];
                return  [self _imageNamed:name inBundle:bundle];
            }
        }else{ // sandbox path
            return [self _imageNamed:name atPath:imageBasePath];
        }
    }else{
        image = [UIImage imageNamed:name];
    }

    return image;
}

+ (UIImage *)_imageNamed:(NSString *)name atPath:(NSString *)path {
    NSString *fullPath = [path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:fullPath];
}

+ (UIImage *)_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    else name = name.stringByDeletingPathExtension;
    NSString *path = [self pathForScaledResource:name ofType:ext inBundle:bundle];
    return [UIImage imageWithContentsOfFile:path];
    //iOS 8.0
//    return [UIImage imageNamed:path.lastPathComponent inBundle:[NSBundle bundleWithPath:path.stringByDeletingLastPathComponent] compatibleWithTraitCollection:nil];
}

+ (NSArray *)preferredScalesString{
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@"@1x", @"", @"@2x", @"@3x"];
        } else if (screenScale <= 2) {
            scales = @[@"@2x", @"@3x", @"@1x", @""];
        } else {
            scales = @[@"@3x", @"@2x", @"@1x", @""];
        }
    });
    return scales;
}

+ (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inBundle:(NSBundle *)bundle {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [bundle pathForResource:name ofType:ext];
    NSString *path = nil;
    NSArray *scales = [self preferredScalesString];
    for (int i = 0; i < scales.count; i ++) {
        NSString * scale = [scales objectAtIndex:i];
        NSString *scaledName = ext.length ? [name stringByAppendingString:scale]
        : [name stringByAppendingPathScaleString:scale];
        path = [bundle pathForResource:scaledName ofType:ext];
        if (path) break;
    }
    return path;
}

+ (NSError *)makeErrorDesc:(NSString *)desc,... NS_REQUIRES_NIL_TERMINATION{
    va_list args;
    va_start(args, desc);
    va_end(args);
    NSString * descx = [[NSString alloc]initWithFormat:desc arguments:args];
    return [NSError errorWithDomain:YSThemeErrorDomain code:0 userInfo:@{@"desc":descx}];
}

+ (NSDictionary *)dictFromCheckTypeForPath:(NSString *)path {
    NSString *fileType = path.pathExtension.lowercaseString;
    if ([fileType isEqualToString:@"plist"]) {
        return [NSDictionary dictionaryWithContentsOfFile:path];
    } else if ([fileType isEqualToString:@"json"]) {
        return [YSThemeHelper jsonDictionaryWithContentsOfFile:path];
    } else {}
    return nil;
}

+ (NSDictionary *)jsonDictionaryWithContentsOfFile:(NSString *)string {
    NSString *jsonString = [NSString stringWithContentsOfFile:string encoding:NSUTF8StringEncoding error:nil];
    id object = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSAssert2([object isKindOfClass:[NSDictionary class]],
              @"File contents must be a dictionary format (%@) . file path (%@)",
              string.lastPathComponent, string);
    return (NSDictionary *)object;
}

+ (NSDictionary *)trimmingKeyWithDictionary:(NSDictionary *)dict {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *triKey = [key stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        [dictionary setObject:obj forKey:triKey];
    }];
    return dictionary;
}
@end


#pragma mark -

YSWeakReference ys_weakReference(id object) {
    __weak id weakref = object;
    return ^{
        return weakref;
    };
}

id ys_objFromWeakReference(YSWeakReference ref) {
    return ref ? ref() : nil;
}
