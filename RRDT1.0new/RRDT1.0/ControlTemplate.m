//
//  ControlTemplate.m
//  RRDT1.0
//
//  Created by riverman on 15/12/8.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "ControlTemplate.h"

@implementation ControlTemplate

-(id)init{
    self=[super init];
    if (self) {
        _controlList=[NSArray array];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
