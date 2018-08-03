//
//  YSThemePrivate.h
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#ifndef YSThemePrivate_h
#define YSThemePrivate_h


// 日志输出
#ifdef DEBUG
#define YSThemeLog(...) NSLog(__VA_ARGS__)
#define YSThemeWarningLog(...) NSLog(@"** YSTheme Warning ** %@", [NSString stringWithFormat:__VA_ARGS__])
#else
#define YSThemeLog(...)
#define YSThemeWarningLog(...) 
#endif

#define YSDefineGetSetFunc(keyName) \
- (void)setSi_ ## keyName:(YSSkinItem *)item { \
return [self ys_setSkinItem:item forKeyPath:(__bridge NSString *)CFSTR(#keyName)]; \
} \
- (YSSkinItem *)si_ ## keyName { \
return [self ys_getSkinItemForKeyPath:(__bridge NSString *)CFSTR(#keyName)]; \
}

#import "YSPathParser.h"
#import "YSThemeHelper.h"
#import "YSThemeMananger.h"

#endif /* YSThemePrivate_h */
