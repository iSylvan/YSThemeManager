//
//  YSTheme.m
//  YSThemeManagerExample
//
//  Created by yt_liyanshan on 2017/12/15.
//  Copyright © 2017年 iSylvan. All rights reserved.
//

#import "YSTheme.h"
#import "YSThemePrivate.h"

typedef NSString *  YSThemeSkinFileInfoKey;
YSThemeSkinFileInfoKey  const  kYSThemeSkinFileInfo_skinfileType = @"@skinfileType";
YSThemeSkinFileInfoKey  const  kYSThemeSkinFileInfo_imageBasePath = @"@imageBasePath";
YSThemeSkinFileInfoKey  const  kYSThemeSkinFileInfo_image = @"@image";
YSThemeSkinFileInfoKey  const  kYSThemeSkinFileInfo_color = @"@color";
YSThemeSkinFileInfoKey  const  kYSThemeSkinFileInfo_other = @"@other";

YSThemeSkinItemInfoKey  const  kYSThemeSkinItem_skinvalue = @"skinvalue" ;
YSThemeSkinItemInfoKey  const  kYSThemeSkinItem_imageBasePath = @"imageBasePath" ;

@implementation YSTheme

#pragma mark - path

+(NSString *)skinSourceCachePath{
    return  [YSPathParser defaultParser].cacheDiskBasePath;
}

+(NSString *)skinSourceCacheDiskThemeCachePath:(NSString *)theme{
    theme = [theme stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (theme&&theme.length>0) {
        NSString * cacheDiskPath =  [self skinSourceCachePath];
        NSString * dirPath = [NSString stringWithFormat:@"%@/skinsource_%@",cacheDiskPath,theme];
        return dirPath;
    }
    return nil;
}

+(NSString *)skinSourceCacheDiskThemeCacheFileName:(NSString *)theme verson:(NSString *)verson{
    theme = [theme stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    verson = [verson stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (theme&&theme.length>0&&verson&&verson.length>0) {
        NSString * fileName = [NSString stringWithFormat:@"%@_%@.plist",theme,verson];
        return fileName;
    }
    return nil;
}

+(NSString *)skinSourceCacheDiskThemeCacheFilePath:(NSString *)theme verson:(NSString *)verson{
    NSString * dirPath = [self skinSourceCacheDiskThemeCachePath:theme];
    NSString * fileName = [self skinSourceCacheDiskThemeCacheFileName:theme verson:verson];
    if (dirPath && fileName ) return [dirPath stringByAppendingPathComponent:fileName];
    return nil;
}

+(void)cleanSkinSourceCacheDiskPath:(NSString *)theme async:(BOOL)onbg{
    NSString * dirPath = [self.class skinSourceCacheDiskThemeCachePath:theme];
    if (dirPath.ys_existDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:dirPath error:nil];
    }
}

-(NSString *)skinSourceCacheDiskThemeCachePath{
    return [self.class skinSourceCacheDiskThemeCachePath:self.themeID];
}

-(NSString *)skinSourceCacheDiskThemeCacheFileName{
    return [self.class skinSourceCacheDiskThemeCacheFileName:self.themeID verson:[NSString stringWithFormat:@"%zd",self.themeVersion]];
}

-(NSString *)skinSourceCacheDiskThemeCacheFilePath{
    return [self.class skinSourceCacheDiskThemeCacheFilePath:self.themeID verson:[NSString stringWithFormat:@"%zd",self.themeVersion]];
}

#pragma mark - getter config

-(BOOL)shouldSkinSourceCacheDisk{
    return YES;
}

#pragma mark - func

-(void)initializeTheme{
    if (self.shouldSkinSourceCacheDisk){
         if (!self.skinSourceCacheDiskThemeCacheFilePath.ys_existFile) {
            self.skinSource = [self skinSourceWithResolverSkinFiles:nil];
            [self saveSkinSourceToCacheDisk:YES];
         }
         [self delSkinSourceToCacheDiskExcutionCurrentVersonFile:YES];
    }
}

-(BOOL)updateSkinSourceIfNeeded{
    if (!self.skinSource||self.skinSource.count == 0) {
       return [self updateSkinSource:nil];
    }
    return YES;
}

-(BOOL)updateSkinSource:(NSError **)error{
    if (self.shouldSkinSourceCacheDisk) {
        self.skinSource = [self skinSourceWithCacheDisk:error];
    }
    if (!self.skinSource || self.skinSource.count == 0) {
        self.skinSource = [self skinSourceWithResolverSkinFiles:error];
        if (self.shouldSkinSourceCacheDisk) [self saveSkinSourceToCacheDisk:YES];
    }
    return (self.skinSource&&self.skinSource.count>0);
}

-(void)saveSkinSourceToCacheDisk:(BOOL)async{
    NSString * dirPath =  [self skinSourceCacheDiskThemeCachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirPath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString * fileName = [self skinSourceCacheDiskThemeCacheFileName];
    NSString * filePath = [dirPath stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [self.skinSource writeToFile:filePath atomically:YES];
#ifdef DEBUG
    if (!isSuccess) YSThemeWarningLog(@"存储失败！！！%@",filePath);
#endif
    [self.skinSource writeToFile:filePath atomically:YES];
}

-(void)delSkinSourceToCacheDiskExcutionCurrentVersonFile:(BOOL)async{
    NSString * dirPath = [self skinSourceCacheDiskThemeCachePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL sign = NO;
    if([fileManager fileExistsAtPath:dirPath isDirectory:&sign]&&sign){
         NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
         NSString * fileName = [self skinSourceCacheDiskThemeCacheFileName];
        [fileNames enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:fileName]) {
                NSString * moveItem = [dirPath stringByAppendingPathComponent:obj];
                [fileManager removeItemAtPath:moveItem error:nil];
            }
        }];
    }
}

#pragma mark - file resolve

-(NSDictionary<NSString *,NSDictionary * > *)skinSourceWithCacheDisk:(NSError **)error{
    NSString * filePath = [self skinSourceCacheDiskThemeCacheFilePath];
    if (filePath.ys_existFile) {
         NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
         return dic;
    }else{
        [YSThemeHelper makeErrorDesc:@"%@ not exitst",filePath];
    }
    return nil;
}


-(NSDictionary<NSString *,NSDictionary * > *)skinSourceWithResolverSkinFiles:(NSError **)error{
    NSMutableArray * files = [NSMutableArray array];
    for (int i = 0; i < self.skinFilePathArr.count; i++) {
        NSString * filepath = [self.skinFilePathArr objectAtIndex:i];
        filepath = [[YSPathParser defaultParser] pathByParseString:filepath];
        if (filepath.ys_existFile) {
            [files addObject:filepath];
        }else{
            YSThemeWarningLog(@"%@找不到对应文件",[self.skinFilePathArr objectAtIndex:i]);
        }
    }
    if (files.count == 0){
        [YSThemeHelper makeErrorDesc:@"skinFilePathArr没有可用对象"];
        return nil;
    }
    NSMutableDictionary<NSString *,NSDictionary * > * rs = [NSMutableDictionary dictionary];
    for (int i = 0; i < files.count; i++) {
        NSString * filepath = [files objectAtIndex:i];
        NSDictionary * dic = [YSThemeHelper dictFromCheckTypeForPath:filepath];
        NSDictionary * dicSt = [self skinSourceStandardization:dic];
        [self dict:rs appendedDic:dicSt];
    }
    return rs;
}

-(NSDictionary<NSString *,NSDictionary * > *)skinSourceStandardization:(NSDictionary *)source{
    if (!source || ![source isKindOfClass:[NSDictionary class]]) return nil;
     NSMutableDictionary * dicSt = [source mutableCopy];
    //@skinfileType
     NSNumber *skinfileType = [dicSt objectForKey:kYSThemeSkinFileInfo_skinfileType];
     [dicSt removeObjectForKey:kYSThemeSkinFileInfo_skinfileType];
     if (!skinfileType) skinfileType = @0;
    
    //@imageBasePath
    NSString * imageBasePath = [dicSt objectForKey:kYSThemeSkinFileInfo_imageBasePath];
    [dicSt removeObjectForKey:kYSThemeSkinFileInfo_imageBasePath];
    NSDictionary *itemNeedAppend ;
    if (imageBasePath) itemNeedAppend = @{kYSThemeSkinItem_imageBasePath:imageBasePath};
    
    //standardization
    if ([skinfileType integerValue] == 0) {
        return  [self dictStandardization:dicSt itemAppended:itemNeedAppend];
    }else{
        NSMutableDictionary * dicStRs = [NSMutableDictionary dictionary];
        NSDictionary * dic_c = [dicSt objectForKey:kYSThemeSkinFileInfo_color];
        NSDictionary * dic_i = [dicSt objectForKey:kYSThemeSkinFileInfo_image];
        NSDictionary * dic_o = [dicSt objectForKey:kYSThemeSkinFileInfo_other];
        [self dict:dicStRs appendedDic:[self dictStandardization:dic_c]];
        [self dict:dicStRs appendedDic:[self dictStandardization:dic_o]];
        [self dict:dicStRs appendedDic:[self dictStandardization:dic_i itemAppended:itemNeedAppend]];
        return dicStRs;
    }
}

-(NSDictionary *)dictStandardization:(NSDictionary *)dict{
    NSMutableDictionary * rs = [dict mutableCopy];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary * item = @{kYSThemeSkinItem_skinvalue:obj};
            [rs setValue:item forKey:key];
        }
    }];
    return rs;
}

-(NSDictionary *)dictStandardization:(NSDictionary *)dict itemAppended:(NSDictionary *)dictTarget{
    BOOL itemAppended = (dictTarget && [dictTarget isKindOfClass:[NSDictionary class]]);
    NSMutableDictionary * rs = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *item;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            item = [((NSDictionary*)obj) mutableCopy];
            if (itemAppended)
            [dictTarget enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (![item objectForKey:key]) {
                    [item setObject:obj forKey:key];
                }
            }];
        }else{
            item = [NSMutableDictionary dictionary];
            [item setValue:obj forKey:kYSThemeSkinItem_skinvalue];
            if (itemAppended) [item setValuesForKeysWithDictionary:dictTarget];
        }
        if (item) {
             [rs setValue:[item copy] forKey:key];
        }
    }];
    return rs;
}

#ifdef DEBUG
-(void)dict:(NSMutableDictionary *)dict appendedDic:(NSDictionary *)dictTarget{
    [dictTarget enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id value = [dict objectForKey:key];
        if (value) {
            YSThemeWarningLog(@"%@重复定义了",key);
        }
        [dict setObject:obj forKey:key];
    }];
}
#else
-(void)dict:(NSMutableDictionary *)dict appendedDic:(NSDictionary *)dictTarget{
    [dict setValuesForKeysWithDictionary:dictTarget];
}
#endif


#pragma mark - init

-(instancetype)initWithJsonData:(NSDictionary *)jsonDictionary{
    self = [super init];
    if (self) {
        if ([jsonDictionary isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:jsonDictionary];
        }
    }
    return self;
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}


#pragma mark - copy

-(id)copyWithZone:(NSZone *)zone{
    YSTheme * obj = [[self.class allocWithZone:zone] init];
    obj.themeID = self.themeID;
    obj.themeName = self.themeName;
    obj.themeVersion = self.themeVersion;
    obj.themeImageBasePath = self.themeImageBasePath;
    obj.skinSource = self.skinSource;
    obj.skinFilePathArr = self.skinFilePathArr;
    return obj;
}

#pragma mark - other

-(NSMutableDictionary *)dict:(NSDictionary *)dict appendDic:(NSDictionary *)dictTarget __deprecated_msg("Use -dict:appendedDic:"){
    NSMutableDictionary * rs = [dict mutableCopy];
    [dictTarget enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id value = [rs objectForKey:key];
        id value_Target = obj;
        if (value) {
            if ([value isKindOfClass:[NSDictionary class]]&&[obj isKindOfClass:[NSDictionary class]]) {
                value_Target = [self dict:value appendDic:obj];
            }else{
                YSThemeWarningLog(@"%@重复定义了",key);
            }
        }
        [rs setObject:value_Target forKey:key];
    }];
    return rs;
}

-(void)setThemeImageBasePath:(NSString *)themeImageBasePath{
    _themeImageBasePath = [YSPathParser.defaultParser pathByParseString:themeImageBasePath];
}
@end



