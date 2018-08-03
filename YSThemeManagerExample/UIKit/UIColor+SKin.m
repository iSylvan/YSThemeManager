//
//  UIColor+SKin.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2018/7/9.
//  Copyright © 2018年 iSylvan. All rights reserved.
//

#import "UIColor+SKin.h"
#import "YSTheme.h"

@implementation UIColor (SKin)

+ (NSDictionary<YSThemeSkinItemInfoKey,id> *)skinItemDataWithSkinKey:(NSString *)skinkey{
    YSTheme * currentTheme = [YSThemeMananger defaultMananger].currentTheme;
    return  [currentTheme.skinSource objectForKey:skinkey];
}


+ (Class <YSSkinItemResolverProtol>)resolverClass{
    return [[YSSkinItem class] resolverClass];
}

+ (UIColor *) colorWithSkinKey:(NSString * )skinKey {
  NSDictionary<YSThemeSkinItemInfoKey,id> * skinData = [self skinItemDataWithSkinKey:skinKey];
  id orgV =  [skinData objectForKey:kYSThemeSkinItem_skinvalue];
  if (orgV) {
         return [self.resolverClass resolverColor:orgV];
   }
    return [UIColor clearColor];
}

@end

@implementation UIImage (SKin)

+ (NSDictionary<YSThemeSkinItemInfoKey,id> *)skinItemDataWithSkinKey:(NSString *)skinkey{
    YSTheme * currentTheme = [YSThemeMananger defaultMananger].currentTheme;
    return  [currentTheme.skinSource objectForKey:skinkey];
}


+ (Class <YSSkinItemResolverProtol>)resolverClass{
    return [[YSSkinItem class] resolverClass];
}

+ (UIImage *) imageWithSkinKey:(NSString * )skinKey {
    NSDictionary<YSThemeSkinItemInfoKey,id> * skinData = [self skinItemDataWithSkinKey:skinKey];
    id orgV =  [skinData objectForKey:kYSThemeSkinItem_skinvalue];
    id path =  [skinData objectForKey:kYSThemeSkinItem_imageBasePath];
    if (orgV) {
        return [self.resolverClass resolverImage:orgV imageBasePath:path];
    }
    return [[UIImage alloc] init];
}

@end
