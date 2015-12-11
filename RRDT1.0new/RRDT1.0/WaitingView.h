//
//  WaitingView.h
//  RRDT1.0
//
//  Created by riverman on 15/12/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//
// 审核中
#import <UIKit/UIKit.h>

#define TaskDetailVC_BadgeValue @"TaskDetailVC_BadgeValue"
@interface WaitingView : UITableView<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic,strong) NSMutableArray     *modeArr;

@property (nonatomic,assign) NSInteger          nextId;

@property (nonatomic,strong) NSString          *taskId;

- (void)post;

@end
