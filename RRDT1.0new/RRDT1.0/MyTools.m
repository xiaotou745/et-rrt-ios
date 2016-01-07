//
//  MyTools.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/18.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "MyTools.h"

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

