//
//  CustomNavBar.h
//  RRDT1.0
//
//  Created by riverman on 16/1/20.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomNavBarClick)(void);
@interface CustomNavBar : UIView


@property(nonatomic,strong)UILabel *cityNameeeeee;
@property(nonatomic,strong)UIImageView *cityIcon;

@property(copy)CustomNavBarClick click;

-(void)configView:(NSString *)title;
@end
