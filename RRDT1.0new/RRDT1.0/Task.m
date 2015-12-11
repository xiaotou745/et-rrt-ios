//
//  Task.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/9.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "Task.h"

@implementation Task

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.taskId=value;
    }
}
@end
