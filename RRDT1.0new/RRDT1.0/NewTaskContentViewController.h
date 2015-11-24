//
//  NewTaskContentViewController.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskContentViewController : UIViewController

@property (nonatomic,strong) Task *task;

/** 1待领取2已领取3审核中4未通过5已通过6已失效7已取消*/
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger onlyType;
@end
