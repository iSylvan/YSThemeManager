# YSThemeManager

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Requires iOS 7.0 or later
- Requires Automatic Reference Counting (ARC)

## Installation

YT_SkinSupport is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YT_SkinSupport'
```

## Usage

First in **application:didFinishLaunchingWithOptions:** set your configuration file.

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[YSThemeMananger defaultMananger] initializeAllTheme];
    return YES;
}
```

func1
```objc
//use category

//category define like this
@interface UIImageView (YSSkin)

@property (nonatomic, strong) YSSkinItem * si_image;
@property (nonatomic, strong) YSSkinItem * si_highlightedImage;

@end


//use
UIImageView * imgV = [self.view viewWithTag:11];
imgV.si_image = [[YSSkinItem alloc] initWithSkinKey:@"image01"];

```

func2
```objc

[[YSThemeSupport sharedSupport] addThemeChangedHandler1ToTarget:self operation:^(TabOneViewController * Target) {
    if(Target.isSUN)[Target.tabBarItem setTitle:@"01"];else[Target.tabBarItem setTitle:@"02"];
}](self);

```

func3
```objc
YSThemeSupport addThemeChangedHandler0ToTarget:(__kindof NSObject *)target sel:(SEL)sel;
```

##配置文件说明


#### 介绍文件路径参数
可以自定义更多参数，继承YSPathParser重写pathByParseStringPath：
```
@(MAINBUNDLE)app包路径
@(SANDBOX) 沙盒路径，下载的skinSource文件或者下载的图片资源包可以放在沙盒内

```

#### 介绍SkinInfo配置文件

SkinInfo 皮肤配置索引文件
![skinInfo改变文件路径](readmeImageSource/skinInfo.png )

```objc
YSThemeMananger.m

NSString *const YSThemeInfoProfilePath = @"YSThemeInfoProfilePath";

-(NSString *)themeInfoFilePath{
//用户配置文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * infoPath = [userDefaults valueForKey:YSThemeInfoProfilePath];
    if (infoPath&&[infoPath isKindOfClass:[NSString class]]) {
    return [YSPathParser.defaultParser pathByParseString:infoPath];
    }
//读info.plist
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    infoPath = [infoDictionary objectForKey:YSThemeInfoProfilePath];
    if (infoPath&&[infoPath isKindOfClass:[NSString class]]) {
    return [YSPathParser.defaultParser pathByParseString:infoPath];
    }
//默认
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    return [bundlePath stringByAppendingPathComponent:@"themeInfo.plist"];
}

```

#### 介绍DAY配置文件
具体皮肤配置文件
```
@interface YSTheme : NSObject <NSCopying>

@property(nonatomic, strong)NSString    * themeID;              ///< 唯一标识
@property(nonatomic, assign)NSString    * themeName;            ///< 主题名字
@property(nonatomic, assign)NSUInteger    themeVersion;         ///< 版本号
@end
```

## Author

## License

YSThemeSupport is available under the MIT license. See the LICENSE file for more info.


