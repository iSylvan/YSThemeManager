//
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import "UIView+Skin.h"
#import "YSThemePrivate.h"

@implementation UIView (Skin)

- (YSSkinItem *)si_tintColor {
    return [self ys_getSkinItemForKeyPath:@"color"];
}

- (void)setSi_tintColor:(YSSkinItem *)si_Color {
    return [self ys_setSkinItem:si_Color forKeyPath:@"color"];
}

- (YSSkinItem *)si_backgroundColor {
    return [self ys_getSkinItemForKeyPath:@"backgroundColor"];
}

- (void)setSi_backgroundColor:(YSSkinItem *)si_backgroundColor {
    return [self ys_setSkinItem:si_backgroundColor forKeyPath:@"backgroundColor"];
}

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
