//
//  HttpHelper.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/29.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "HttpHelper.h"
#import "ETSUUID.h"
#import "Security.h"
#import "MyTools.h"

@implementation HttpHelper

+(AFHTTPRequestOperationManager *)initHttpHelper{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues=YES;
//    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", @"text/html", nil];
    
    NSString * ssid = [ETSUUID getUniqueDeviceIDFromKeychain];
    [manager.requestSerializer setValue:ssid forHTTPHeaderField:@"ssid"];
    
    NSString *currentVersion=[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:currentVersion forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"sysversion"];

    
    return manager;
}
+(NSDictionary *)security:(NSDictionary *)mydic{
    
    if (isUseAESEncrypt) {
        
        NSString *mydicStr = [self dictionaryToJson:mydic];
        NSDictionary *parameter = @{@"data":[Security AesEncrypt:mydicStr]};
        return parameter;
        
    }else{
        return mydic;
    }
    
}
+ (NSString*)dictionaryToJson:(NSDictionary *)info

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
