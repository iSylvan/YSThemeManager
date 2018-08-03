//
//  TabOneViewController.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2018/2/26.
//  Copyright © 2018年 iSylvan. All rights reserved.
//

#import "TabOneViewController.h"
#import "YSTheme.h"
#import "UIColor+SKin.h"
#import "UILabel+Skin.h"
#import "UIView+Skin.h"
#import "UIImageView+Skin.h"

@interface TabOneViewController ()

@end

@implementation TabOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     UILabel * lable = [self.view viewWithTag:22];
     lable.si_backgroundColor = [[YSSkinItem alloc] initWithSkinKey:@"color01"];
    
     UIImageView * imgV = [self.view viewWithTag:11];
     imgV.si_image = [[YSSkinItem alloc] initWithSkinKey:@"image01"];
    
     [[YSThemeSupport sharedSupport] addThemeChangedHandler1ToTarget:self operation:^(TabOneViewController * Target) {
         if(Target.isSUN)[Target.tabBarItem setTitle:@"01"];else[Target.tabBarItem setTitle:@"02"];
     }](self);
    
    UISwitch * sender = [self.view viewWithTag:33];
    sender.on = [[YSThemeMananger defaultMananger].currentTheme.themeID isEqual:@"02"];
}


- (BOOL)isSUN {
    return [[YSThemeMananger defaultMananger].currentTheme.themeID isEqual:@"01"];
}

- (IBAction)themeChange:(UISwitch *)sender {
    NSString * theme = sender.isOn?@"02":@"01";
    if ([[YSThemeMananger defaultMananger] changeCurrentTheme:theme error:nil]) {
        NSLog(@"换肤成功");
    }else{
        NSLog(@"换肤失败");
    }
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
