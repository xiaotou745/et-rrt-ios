//
//  ParterModel.m
//  RRDT1.0
//
//  Created by riverman on 16/1/15.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "ParterModel.h"

@implementation ParterModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.ctId=value;
    }
}
@end
