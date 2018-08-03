//
//  YSPathParser.h
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/21.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (NSFileManager)
@property(nonatomic, assign, readonly)BOOL ys_isNotEmpty;
@property(nonatomic, assign, readonly)BOOL ys_existPath;
@property(nonatomic, assign, readonly)BOOL ys_existFile;
@property(nonatomic, assign, readonly)BOOL ys_existDirectory;
@end


@interface YSPathParser : NSObject
@property(nonatomic, strong, class , readonly)YSPathParser * defaultParser;
@property(nonatomic, strong, readonly)NSString * regularExpressionString;

/// 注册 string 作为 某个路径的代名词
-(BOOL)registerMathRegExString:(NSString *)string asPath:(NSString *)path;

///解析字符串 获取 真实路径 如果必要可以继承重写
-(NSString *)pathByParseString:(NSString*)path;

///cache Path
-(NSString *)cacheDiskBasePath;

@end
NS_ASSUME_NONNULL_END
