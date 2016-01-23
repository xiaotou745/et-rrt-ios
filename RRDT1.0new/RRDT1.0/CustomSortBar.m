//
//  CustomSortBar.m
//  RRDT1.0
//
//  Created by riverman on 16/1/21.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "CustomSortBar.h"

@implementation CustomSortBar

-(id)init{
    
    self=[super initWithFrame:CGRectMake(0, 0, 50, 25)];
    if (self) {
        [self ConfigView];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)ConfigView{
    
    _sortTitle=[ManFactory createLabelWithFrame:CGRectMake(0, 0, 30, 25) Font:15 Text:@"排序"];
    _sortTitle.textColor=[UIColor whiteColor];

    _sortIcon=[ManFactory createImageViewWithFrame:CGRectMake(_sortTitle.right+5, 8,10,10) ImageName:@"icon_taskSort"];
//        _sortIcon.backgroundColor=[UIColor orangeColor];
    [self addSubview:_sortTitle];
    [self addSubview:_sortIcon];
    
}
-(void)tapHandle{
    self.click();
}

@end
