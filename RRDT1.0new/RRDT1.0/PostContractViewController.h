//
//  PostContractViewController.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

/**
 *  资料录入
 */

#import <UIKit/UIKit.h>

#import "BackBaseViewController.h"

#define  againEnterPostVC @"againEnterPostVC"

@protocol ContractContentDele <NSObject>

-(void)backPostContract;

@end

@interface PostContractViewController : BackBaseViewController

@property (nonatomic,strong)Task *task;
@property (nonatomic,strong)NSString *taskId;
@property (nonatomic,strong)NSString *taskDatumId;

/** 没有提交过的111   提交过的但是可以再次提交的222   提交过但是不能修改333*/
@property (nonatomic,assign)NSInteger tag;

@property (nonatomic,assign)NSInteger onlyType;

-(void)postGetMyTask;

@property (nonatomic,assign)id<ContractContentDele> delegate;

@end


