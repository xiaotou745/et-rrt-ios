//
//  NSDictionary+JsonStirng.h
//  RRDT1.0
//
//  Created by riverman on 16/1/25.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonStirng)

-(NSDictionary *)security;
- (NSString*)dictionaryToJson;
@end
