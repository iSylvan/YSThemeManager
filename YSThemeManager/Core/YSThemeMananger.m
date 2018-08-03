//
//  YSThemeMananger.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import "YSThemeMananger.h"
#import "YSPathParser.h"
#import "YSThemeHelper.h"

#import "YSThemeSupport.h"

YSThemeKey  const  kYSTheme_themeID = @"themeID";
YSThemeKey  const  kYSTheme_themeName  = @"themeName";
YSThemeKey  const  kYSTheme_themeVersion = @"themeVersion";
YSThemeKey  const  kYSTheme_themeImageBasePath = @"themeImageBasePath";

NSString *const YSThemeInfoProfilePath = @"YSThemeInfoProfilePath";
NSString *const YSThemeInfoCurrentThemeId = @"YSThemeInfoCurrentThemeId";
NSString *const YSCurrentThemeChangedNotification = @"YSCurrentThemeChangedNotification";

@interface YSThemeMananger ()

@property (nonatomic, strong) NSString  * currentThemeId;

@end

@implementation YSThemeMananger

#pragma mark - init

+(YSThemeMananger *)defaultMananger{
    static YSThemeMananger*  _defaultMananger;
    if (!_defaultMananger) {
        _defaultMananger = [[self alloc] init];
    }
    return _defaultMananger;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self updateThemeMananger];
    }
    return self;
}

-(void)updateThemeMananger{
    NSString * filePath = [self themeInfoFilePath];
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]&&!isDir){
        NSDictionary * info = [YSThemeHelper dictFromCheckTypeForPath:filePath];
        if ([info isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:info];
        }
    }else{
        YSThemeWarningLog(@"没有找到themeInfo");
    }
}

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

#pragma mark - init all theme

-(void)initializeAllTheme{
    NSString * currentThemeId = self.currentThemeId;
    YSTheme  * currentTheme;
    for (int i = 0; i< self.themes.count; i++) {
        NSDictionary<YSThemeKey,id> * obj = [self.themes objectAtIndex:i];
        YSTheme *theme = [[YSTheme alloc] initWithJsonData:obj];
        [theme initializeTheme];
        NSString * objId = [obj objectForKey:kYSTheme_themeID];
        if ([objId isEqualToString:currentThemeId]) {
            if([theme updateSkinSourceIfNeeded]) currentTheme = theme;
        }
    }
    if (!currentTheme) {
        currentTheme= [self readTheme:self.defaultTheme error:nil];
    }
    NSAssert(currentTheme,@"theme no can used ");
    self.currentTheme = currentTheme;
}

#pragma mark - public func

-(NSString *)defaultTheme{
    if (!_defaultTheme|| _defaultTheme.length == 0) {
       NSDictionary<YSThemeKey,id> * obj = [self.themes firstObject];
       NSString * objId = [obj objectForKey:kYSTheme_themeID];
       _defaultTheme = objId;
    }
    return _defaultTheme;
}

-(NSDictionary<YSThemeKey,id> * __nullable)getThemeInfo:(NSString *)themeID{
    NSDictionary<YSThemeKey,id> * themeinfo;
    for (int i = 0; i< self.themes.count; i++) {
        NSDictionary<YSThemeKey,id> * obj = [self.themes objectAtIndex:i];
        NSString * objId = [obj objectForKey:kYSTheme_themeID];
        if ([themeID isEqualToString:objId]) {
            themeinfo = obj;break;
        }
    }
    return themeinfo;
}

-(YSTheme * __nullable)readTheme:(NSString *)themeID error:(NSError ** __nullable)error{
    NSDictionary<YSThemeKey,id> * themeinfo = [self getThemeInfo:themeID];
    if (!themeinfo) {
        if(error) * error = [YSThemeHelper makeErrorDesc:@"themeID不存在%@",themeID, nil];
        return nil;
    }
    YSTheme *theme = [[YSTheme alloc] initWithJsonData:themeinfo];
    if (![theme updateSkinSourceIfNeeded]){
        if(error) * error = [YSThemeHelper makeErrorDesc:@"theme %@ updateSkinSource failed",themeID, nil];
        return nil;
    }
    return theme;
}

-(BOOL)changeCurrentTheme:(NSString *)themeID error:(NSError ** __nullable)error{
    return [self changeCurrentTheme:themeID force:NO error:error];
}

-(BOOL)changeCurrentTheme:(NSString *)themeID force:(BOOL)force error:(NSError ** __nullable)error{
    BOOL changeTheme = force;
    if (!force) {
        changeTheme = ![self.currentTheme.themeID isEqualToString:themeID];
    }
    if (changeTheme) {
       NSError * readErr;
       YSTheme * theme = [self readTheme:themeID error:&readErr];
        if (theme && !readErr) {
            self.currentTheme = theme;
            [[NSNotificationCenter defaultCenter] postNotificationName:YSCurrentThemeChangedNotification object:nil];
            [[YSThemeSupport sharedSupport] resumeThemeChangedHandler];
            return YES;
        }
        *error = readErr;
    }
    return NO;
}

-(BOOL)writeThemeInfoAndPersistenceKey:(NSString*)key forValue:(NSString *)value{
    return YES;
}

#pragma mark - other
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

-(NSString *)currentThemeId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:YSThemeInfoCurrentThemeId];
}

-(void)setCurrentThemeId:(NSString *)currentThemeId{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:currentThemeId forKey:YSThemeInfoCurrentThemeId];
}

-(void)setCurrentTheme:(YSTheme *)currentTheme{
    if(!currentTheme) return;
    _currentTheme = currentTheme;
    self.currentThemeId = currentTheme.themeID;
}

-(void)setDefaultImageBasePath:(NSString *)defaultImageBasePath{
    _defaultImageBasePath = [YSPathParser.defaultParser pathByParseString:defaultImageBasePath];
}

@end
