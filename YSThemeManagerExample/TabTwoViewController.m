//
//  TabTwoViewController.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2018/2/26.
//  Copyright © 2018年 iSylvan. All rights reserved.
//

#import "TabTwoViewController.h"
#import "YSTheme.h"
#import "UIColor+SKin.h"
#import "UILabel+Skin.h"
#import "UIView+Skin.h"
#import "UIImageView+Skin.h"
#import "YSThemePrivate.h"

@interface TabTwoViewController ()

@end

@implementation TabTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[YSThemeSupport sharedSupport] addThemeChangedHandler1ToTarget:self operation:^(TabTwoViewController * Target) {
        Target.view.layer.contents = (__bridge id _Nullable)([UIImage imageWithSkinKey:@"image01"].CGImage);
    }](self);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
