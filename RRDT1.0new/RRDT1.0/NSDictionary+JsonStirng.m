//
//  NSDictionary+JsonStirng.m
//  RRDT1.0
//
//  Created by riverman on 16/1/25.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "NSDictionary+JsonStirng.h"

@implementation NSDictionary (JsonStirng)

-(NSDictionary *)security{
    
    if (isUseAESEncrypt) {
        
        NSString *mydicStr = [self dictionaryToJson];
        NSDictionary *parameter = @{@"data":[Security AesEncrypt:mydicStr]};
        return parameter;
        
    }else{
        return self;
    }
}
- (NSString*)dictionaryToJson

{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
