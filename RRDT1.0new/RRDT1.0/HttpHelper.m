//
//  HttpHelper.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/29.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "HttpHelper.h"

//#import "Security.h"

@implementation HttpHelper

+(AFHTTPRequestOperationManager *)initHttpHelper{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", @"text/html", nil];
    
    return manager;
}
//+(NSDictionary *)security:(NSDictionary *)mydic{
//    NSString *mydicStr = [mydic JSONString];
//    NSDictionary *parameter = @{@"data":[Security AesEncrypt:mydicStr]};
//    return parameter;
//}
@end
