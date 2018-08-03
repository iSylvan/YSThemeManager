//
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import "UILabel+Skin.h"
#import "YSThemePrivate.h"
@interface UILabel ()
@end

@implementation UILabel (Skin)

YSDefineGetSetFunc(textColor);
YSDefineGetSetFunc(shadowColor);
YSDefineGetSetFunc(highlightedTextColor);

-(void)ys_resolverKeyPath:(NSString *)key andUpdateUIWithSkinItem:(YSSkinItem *)item{
    id value = item.skin;
    if (item.renderSkinBlock) {
        value = item.renderSkinBlock(item);
    }
    if (value) {
        [self setValue:value forKeyPath:key];
    }
}

@end
