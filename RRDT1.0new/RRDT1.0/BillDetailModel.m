//
//  BillDetailModel.m
//  RRDT1.0
//
//  Created by riverman on 16/1/11.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "BillDetailModel.h"

@implementation BillDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.recordId=[value intValue];
    }
}
@end
