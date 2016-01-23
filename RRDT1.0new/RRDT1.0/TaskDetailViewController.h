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

@property(assign)BOOL navBackToHomeVC;
@property(nonatomic,assign)BOOL fromPCenterVC;
@property(nonatomic,assign)BOOL overTime;//是否为过期任务
@property (nonatomic,strong)Task *task;
@property(nonatomic,strong)NSString *taskId;
@property(assign)NSInteger contentOfSet_index;

@end
