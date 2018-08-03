//
//  YSThemeMananger.h
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTheme.h"
NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const YSCurrentThemeChangedNotification;

UIKIT_EXTERN NSString * const YSThemeInfoProfilePath;

typedef NSString * YSThemeKey;
extern YSThemeKey  const  kYSTheme_themeID;
extern YSThemeKey  const  kYSTheme_themeName;
extern YSThemeKey  const  kYSTheme_themeVersion;
extern YSThemeKey  const  kYSTheme_themeImageBasePath;

@interface YSThemeMananger : NSObject

@property (nonatomic, strong , class ,readonly) YSThemeMananger *defaultMananger;
@property (nonatomic, strong) YSTheme  * currentTheme;
@property (nonatomic, strong) NSString * defaultTheme;
@property (nonatomic, strong, nullable) NSString * defaultImageBasePath; ///< 默认从该路径下读取图片资源
@property (nonatomic, strong) NSArray<NSDictionary<YSThemeKey,id> *> * themes;

/// 初始化
-(void)initializeAllTheme;

/// 如果必要可以继承重写
-(NSString *)themeInfoFilePath;

/// 如果必要可以继承重写
-(void)updateThemeMananger;

/**
 根据ThemeID 获取 主题
 
 @param themeID 主题唯一标识
 @return ThemeInfo Dic
 */
-(NSDictionary<YSThemeKey,id> * __nullable)getThemeInfo:(NSString *)themeID;

/**
 根据ThemeID 获取 主题
 
 @param themeID 主题唯一标识
 @param error 否发生错误
 @return YSTheme
 */
-(YSTheme * __nullable)readTheme:(NSString *)themeID error:(NSError ** __nullable)error;

/**
 切换当前皮肤

 @param themeID 主题唯一标识
 @param error 是否发生错误
 @return 是否切换成功
 */
-(BOOL)changeCurrentTheme:(NSString *)themeID error:(NSError ** __nullable)error;

/**
 切换当前皮肤

 @param themeID 主题唯一标识
 @param force 当前主题为切换的目标主题时，是否从新读取缓存，切换
 @param error 否发生错误
 @return 是否切换成功
 */
-(BOOL)changeCurrentTheme:(NSString *)themeID force:(BOOL)force error:(NSError ** __nullable)error;


/// 更新配置并持久化,可用于设置默认皮肤样式，或者新增皮肤,可以考虑在子线程完成，成功后如果需要更新皮肤回主线程更新
-(BOOL)writeThemeInfoAndPersistenceKey:(NSString*)key forValue:(NSString *)value;

@end
NS_ASSUME_NONNULL_END
