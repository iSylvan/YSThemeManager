//
//  YSSkinItem.h
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
// skinfile 中定义的 一项 or ThemeFragment

#import <UIKit/UIKit.h>

typedef NS_ENUM(char, YSSkinvalueResolverType) {
    kSkinvalueResolverUnknow = '\0',
    kSkinvalueResolverImage  = 'm',
    kSkinvalueResolverColor  = 'c',
    kSkinvalueResolverCustom = 'z',
}; ///< skinvalue 的解析方式

@class YSSkinItem;
@protocol YSSkinItemResolverProtol;
typedef id (^YSSkinItemRenderBlock)(YSSkinItem * skinItem);
typedef id (^YSSkinItemResolverBlock)(YSSkinItem * skinItem);
typedef void (^YSSkinItemWorkBlock)(YSSkinItem * skinItem ,id target);


@interface YSSkinItem : NSObject
/*基础值*/
@property (nonatomic, strong) NSString * skinkey;     ///< 键 must
@property (nonatomic, strong, readonly) id skinvalue; ///< 原值

/*解析辅助*/
@property (nonatomic, strong, readonly) NSString * imageBasePath;            ///< 图片存放基础路径
@property (nonatomic, assign) YSSkinvalueResolverType skinvalueResolverType; ///< 解析类型,默认kSkinvalueResolverUnknow
@property (nonatomic, strong) YSSkinItemResolverBlock resolverSkinBlock;     ///< 自定义skinvalue的解析方式
@property (nonatomic, weak, class, readonly) Class<YSSkinItemResolverProtol> resolverClass;   ///< skinvalue的解析方式

/*解析结果*/
@property (nonatomic, strong, readonly) id skin;         ///< 解析结果
@property (nonatomic, strong, readonly) UIColor * color; ///< 解析结果
@property (nonatomic, strong, readonly) UIImage * image; ///< 解析结果

/*增加的解析结果渲染方式，解析skinvalue出结果后用这个block渲染过后赋值给控件*/
@property (nonatomic, strong) YSSkinItemRenderBlock renderSkinBlock;    ///< skin 渲染方式
@property (nonatomic, strong) YSSkinItemWorkBlock   skinWorkBlock;  ///< 自定义 skin 如何作用于视图

- (instancetype)initWithSkinKey:(NSString *)skinkey;

@end


@protocol YSSkinItemResolverProtol <NSObject>

+(id)resolverValue:(YSSkinItem *)skinItem;
+(UIImage *)resolverImage:(id)skinvalue imageBasePath:(NSString *)imageBasePath;
+(UIColor *)resolverColor:(id)skinvalue ;

@end


@interface YSSkinItemResolver :NSObject <YSSkinItemResolverProtol>

+(id)resolverValue:(YSSkinItem *)skinItem;
+(UIImage *)resolverImage:(id)skinvalue imageBasePath:(NSString *)imageBasePath;
+(UIColor *)resolverColor:(id)skinvalue ;

@end




