//
//  TaskDListCell.h
//  RRDT1.0
//
//  Created by riverman on 16/1/19.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailModel.h"
#import "CoreLabel.h"
@interface TaskDListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet CoreLabel *taskAmount;
@property (weak, nonatomic) IBOutlet UIImageView *taskTypeImgView;
@property (weak, nonatomic) IBOutlet UILabel *taskTypeName;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *taskDatumCount;

@property(nonatomic,strong)TaskDetailModel *model;
@end
