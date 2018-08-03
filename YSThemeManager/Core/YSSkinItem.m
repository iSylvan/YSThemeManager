//
//  YSSkinItem.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import "YSSkinItem.h"
#import "YSTheme.h"
#import "YSThemeMananger.h"
#import "YSThemeHelper.h"
#import "YSPathParser.h"

@interface YSSkinItem ()
@property (nonatomic, weak ,readonly) NSDictionary<YSThemeSkinItemInfoKey,id> * skinItemData;  ///< 当前项数据

@end

@implementation YSSkinItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.skinkey = @"";
    }
    return self;
}

- (instancetype)initWithSkinKey:(NSString *)skinkey
{
    self = [super init];
    if (self) {
        self.skinkey = skinkey;
    }
    return self;
}

+(Class<YSSkinItemResolverProtol>)resolverClass{
    return [YSSkinItemResolver class];
}

-(NSDictionary<YSThemeSkinItemInfoKey,id> *)skinItemData{
    YSTheme * currentTheme = [YSThemeMananger defaultMananger].currentTheme;
    return  [currentTheme.skinSource objectForKey:self.skinkey];
}

-(id)skinvalue{
    return [self.skinItemData objectForKey:kYSThemeSkinItem_skinvalue];
}

-(NSString *)imageBasePath{
    return [self.skinItemData objectForKey:kYSThemeSkinItem_imageBasePath];
}

-(id)skin{
    switch (self.skinvalueResolverType) {
        case kSkinvalueResolverCustom:
            if (self.resolverSkinBlock) {
                return self.resolverSkinBlock(self);
            }
            break;
        case kSkinvalueResolverImage:
                return self.image;
            break;
        case kSkinvalueResolverColor:
                return self.color;
            break;
        default:
                return [self.class.resolverClass resolverValue:self];
            break;
    }
    return nil;
}

-(UIImage *)image{
    return [self.class.resolverClass resolverImage:self.skinvalue imageBasePath:self.imageBasePath];
}

-(UIColor *)color{
    return [self.class.resolverClass resolverColor:self.skinvalue];
}

@end


@implementation YSSkinItemResolver

+(id)resolverValue:(YSSkinItem *)skinItem{
    id orginValue = skinItem.skinvalue;
    id rs = [self resolverImage:orginValue imageBasePath:skinItem.imageBasePath];
    if (!rs) rs = [self resolverColor:orginValue];
    return rs;
}

+(UIImage *)resolverImage:(id)skinvalue imageBasePath:(NSString *)imageBasePath{
    UIImage *image = nil;
    if ([skinvalue isKindOfClass:[NSString class]]) {
        NSString * imgP = imageBasePath;/// 使用图片单独定义的位置
        if(imgP) imgP = [[YSPathParser defaultParser] pathByParseString:imageBasePath];
        else imgP = [YSThemeMananger defaultMananger].currentTheme.themeImageBasePath; /// 使用当前主题图片定义的位置
        if (!imgP)imgP = [YSThemeMananger defaultMananger].defaultImageBasePath; /// 使用默认地址
        image = [YSThemeHelper imageFromName:(NSString *)skinvalue imageBasePath:imgP];
    } else if ([skinvalue isKindOfClass:[NSData class]]) {
        image = [UIImage imageWithData:(NSData *)skinvalue];
    } else  if ([skinvalue isKindOfClass:[UIImage class]]) {
        image = (UIImage *)skinvalue;
    } else {}
    
    return image;
}

+(UIColor *)resolverColor:(id)skinvalue{
    UIColor * color =nil;
    if ([skinvalue isKindOfClass:[NSString class]]) {
        color = [YSThemeHelper colorFromHexString:(NSString *)skinvalue];
    } else if ([skinvalue isKindOfClass:[UIColor class]]) {
        color = (UIColor *)skinvalue;
    } else {}
    
    return color;
}
@end
