//
//  MsgModel.m
//  RRDT1.0
//
//  Created by riverman on 15/12/9.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "MsgModel.h"

@implementation MsgModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    if ([key isEqualToString:@"id"]) {
        self.msgId=value;
    }
}
@end
