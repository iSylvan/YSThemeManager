//
//  YSTheme.h
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *  YSThemeSkinItemInfoKey;
extern YSThemeSkinItemInfoKey  const  kYSThemeSkinItem_skinvalue;
extern YSThemeSkinItemInfoKey  const  kYSThemeSkinItem_imageBasePath;

@interface YSTheme : NSObject <NSCopying>

@property(nonatomic, strong)NSString    * themeID;              ///< 唯一标识
@property(nonatomic, assign)NSString    * themeName;            ///< 主题名字
@property(nonatomic, assign)NSUInteger    themeVersion;         ///< 版本号
@property(nonatomic, strong)NSString    * themeImageBasePath;   ///< 图片存放基础路径

@property(nonatomic, strong)NSDictionary<NSString *,NSDictionary<YSThemeSkinItemInfoKey,id> * > * skinSource; ///< skinitemset /ThemeFragment
@property(nonatomic, strong)NSArray    * skinFilePathArr; ///< skinitemsetFile

/**
 初始化
 */
-(void)initializeTheme;
/**
 call skinSourceWithResolverSkinFiles (skinFilePathArr) and rs set at skinSource
 */
-(BOOL)updateSkinSourceIfNeeded;
-(BOOL)updateSkinSource:(NSError **)error;

/**
 实例化方法

 @param jsonDictionary 所需字段
 @return YSTheme
 */
-(instancetype)initWithJsonData:(NSDictionary *)jsonDictionary;
@end
