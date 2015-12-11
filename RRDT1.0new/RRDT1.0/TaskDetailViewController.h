//
//  TaskDetailViewController.h
//  RRDT1.0
//
//  Created by riverman on 15/12/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//


/**
 *  资料审核详情
 */
#import <UIKit/UIKit.h>
#import "BackBaseViewController.h"

@interface TaskDetailViewController : BackBaseViewController

@property (nonatomic,strong)Task *task;
@property(assign)NSInteger contentOfSet_index;
@end
