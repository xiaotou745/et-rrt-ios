//
//  CustomSortBar.h
//  RRDT1.0
//
//  Created by riverman on 16/1/21.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomSortBarClick)(void);

@interface CustomSortBar : UIView


@property(nonatomic,strong)UILabel *sortTitle;
@property(nonatomic,strong)UIImageView *sortIcon;

@property(copy)CustomSortBarClick click;
@end
