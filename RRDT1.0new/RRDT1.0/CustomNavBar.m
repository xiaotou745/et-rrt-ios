//
//  CustomNavBar.m
//  RRDT1.0
//
//  Created by riverman on 16/1/20.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "CustomNavBar.h"

@implementation CustomNavBar

-(id)init{

    self=[super initWithFrame:CGRectMake(0, 0, 100, 25)];
    if (self) {
        [self ConfigView];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)ConfigView{

    _cityNameeeeee=[ManFactory createLabelWithFrame:CGRectMake(0, 0, 45, 25) Font:15 Text:@""];
    _cityNameeeeee.textColor=[UIColor whiteColor];
//    _cityNameeeeee.backgroundColor=[UIColor redColor];
    _cityIcon=[ManFactory createImageViewWithFrame:CGRectMake(_cityNameeeeee.right+3, 9, 12,8) ImageName:@"WaitVC_cityIcon"];
//    _cityIcon.backgroundColor=[UIColor orangeColor];
    [self addSubview:_cityNameeeeee];
    [self addSubview:_cityIcon];

}
-(void)tapHandle{
    self.click();
}
-(void)configView:(NSString *)title{

    _cityNameeeeee.text=title;
    _cityNameeeeee.frame=CGRectMake(0, 0, 15*title.length, 25);
    _cityIcon.frame=CGRectMake(_cityNameeeeee.right+3, 9, 12,8);
}


@end
