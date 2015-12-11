//
//  CheckProgressViewController.h
//  RRDT1.0
//
//  Created by riverman on 15/12/5.
//  Copyright © 2015年 RRDT002. All rights reserved.
//


/**
 *  审核进度详情
 */
#import <UIKit/UIKit.h>
#import "BackBaseViewController.h"
#import "TaskDetailModel.h"
@interface CheckProgressViewController : BackBaseViewController

@property(nonatomic,strong)TaskDetailModel *model;

@end
