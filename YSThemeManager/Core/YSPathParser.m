//
//  YSPathParser.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/21.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import "YSPathParser.h"
#import "YSThemePrivate.h"

//$(MAINBUNDLE)app包路径
//$(SANDBOX) 沙盒路径，下载的skinSource文件或者下载的图片资源包可以放在沙盒内
NSString *const YSMainBundldPath  = @"@(MAINBUNDLE)";//mainBundle
NSString *const YSSandBoxPath   =  @"@(SANDBOX)";

@interface YSPathParser ()
@property(nonatomic, strong)NSMutableDictionary * parserSource;
@property(nonatomic, strong)NSRegularExpression * regexp;
@end

@implementation YSPathParser

static YSPathParser * __defaultParser;
+(YSPathParser *)defaultParser{
    if (!__defaultParser) {
        __defaultParser = [[self alloc]init];
    }
    return __defaultParser;
}

-(NSMutableDictionary *)parserSource{
    if (!_parserSource) {
        _parserSource = [NSMutableDictionary dictionary];
        [self addDefParserSource];
    }
    return _parserSource;
}

-(void)addDefParserSource{
    [_parserSource setObject:[NSBundle mainBundle].bundlePath forKey:YSMainBundldPath];
    [_parserSource setObject:NSHomeDirectory() forKey:YSSandBoxPath];
}

-(NSString *)regularExpressionString{
    return @"@\\([A-Za-z0-9_]{1,}\\)";
}

-(NSRegularExpression *)regexp{
    if (!_regexp) {
        _regexp = [NSRegularExpression regularExpressionWithPattern:self.regularExpressionString options:NSRegularExpressionAnchorsMatchLines error:NULL];
    }
    return _regexp;
}

- (BOOL)checkMathRegExString:(NSString *)string{
    NSString *regex = self.regularExpressionString;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

/// 注册 string 作为 某个路径的代名词
-(BOOL)registerMathRegExString:(NSString *)string asPath:(NSString *)path{
    NSAssert(string, @"string不能为空");NSAssert(path,  @"path不能为空");
    if ([self checkMathRegExString:string]) {
#ifdef DEBUG
        if ([self.parserSource objectForKey:string]) {
            YSThemeWarningLog(@"%@ 已存在",string);
        }
#endif
        [self.parserSource setObject:path forKey:string];
        return YES;
    }
    return NO;
}

///解析字符串 获取 真实路径 如果必要可以继承重写
-(NSString *)pathByParseString:(NSString*)path{
    NSRegularExpression * regexp = self.regexp;
    NSTextCheckingResult *result = [regexp firstMatchInString:path options:0 range:NSMakeRange(0, path.length)];
    if (result && result.range.length >0) {
        NSString * key = [path substringWithRange:result.range];
        NSString * value = [self.parserSource objectForKey:key];
        path = [path stringByReplacingCharactersInRange:result.range withString:value];
//        [self pathByParseString:path];
    }
    return path;
}

-(NSString *)cacheDiskBasePath{
   NSString * documentDir =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
   return [documentDir stringByAppendingPathComponent:@"ys_theme_cache_disk"];
}
@end


#pragma mark - NSString (NSFileManager)

@implementation  NSString (NSFileManager)

-(BOOL)ys_isNotEmpty{
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)ys_existPath{
     return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

-(BOOL)ys_existFile{
    BOOL isDirectory = NO;
    BOOL has = [[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:&isDirectory];
    return (has&&!isDirectory);
}

-(BOOL)ys_existDirectory{
    BOOL isDirectory = NO;
    BOOL has = [[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:&isDirectory];
    return (has&&isDirectory);
}

@end

