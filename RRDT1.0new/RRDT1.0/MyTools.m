//
//  MyTools.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/18.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "MyTools.h"
#define DEFAULT_VOID_COLOR [UIColor blackColor]

@implementation MyTools

+ (void)closeKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

+ (void)call:(NSString *)phoneNumber atView:(UIView *)aView{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phoneNumber];
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [aView addSubview:callWebview];
    
}

+(NSString *)getTasktypeImageName:(int)type{
    NSString *tasktype;
    if (taskType_write==type) {
        tasktype=@"taskType_write";
    }else if (taskType_share==type){
        tasktype=@"taskType_share";
    }else if (taskType_download==type){
        tasktype=@"taskType_download";
    }
    return tasktype;
}

+(NSString *)getTasktype:(int)type{
    NSString *tasktype;
    if (taskType_write==type) {
        tasktype=@"签约";
    }else if (taskType_share==type){
        tasktype=@"分享";
    }else if (taskType_download==type){
        tasktype=@"下载";
    }
    return tasktype;
}
+(UIColor *)getTasktypeBGColor:(int)type{
    UIColor *color=[UIColor whiteColor];
    if (taskType_write==type) {
        color=UIColorFromRGB(0x32bcf6);
    }else if (taskType_share==type){
        color=UIColorFromRGB(0xfda72f);
    }else if (taskType_download==type){
        color=UIColorFromRGB(0x2a8ffc);
    }
    return color;
}

@end

@implementation MyTools (times)


+(NSString *)timeString:(NSString *)string{

    NSString *time;
    if (string.length==19) {
        time=[string substringToIndex:16];
    }else time=string;

    return time;
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

/// 当前系统时间
#pragma mark - 当前时间
+ (NSString *)currentTime{
    NSDate * date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormatter stringFromDate:localeDate];
}
+(BOOL)sharePlatform{

    if ([WXApi isWXAppInstalled]) {
        return YES;
    }
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        return YES;
    }

    if ([TencentOAuth iphoneQQInstalled]) {
        return YES;
    }
    
//    if ([TencentOAuth iphoneQZoneInstalled]) {
//        return YES;
//    }
    return NO;
}
@end

@implementation MyTools (CityAddressManager)

//存储CityAddress.plist
+(void)writeToFile:(NSArray *)CityAddress{
    
    NSString *plistPath =[self filePath];
    BOOL flag = [CityAddress writeToFile:plistPath atomically:YES];
    NSLog(@"MyTools CityAddress== %d",flag);

}

//读取CityAddress.plist
+(NSArray *)readCityAddress
{
    NSString *plistPath =[self filePath];
    NSArray *arr = [NSArray arrayWithContentsOfFile:plistPath];
    // NSLog(@"%@", array);//直接打印数据。
    return arr;
}

+(NSString *)filePath
{
    return  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject ] stringByAppendingPathComponent:[NSString stringWithFormat:@"CityAddress.plist"]];//添加储存的文件名
}

@end

