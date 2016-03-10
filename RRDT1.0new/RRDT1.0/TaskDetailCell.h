//
//  TaskDetailCell.h
//  RRDT1.0
//
//  Created by riverman on 15/12/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "TaskDetailModel.h"

typedef void(^TaskDetailCellBlock)(NSInteger index);

@interface TaskDetailCell : UITableViewCell


@property(strong,nonatomic)TaskDetailModel *model;
@property(copy)TaskDetailCellBlock block;

-(void)hideBottomViews;
@end
