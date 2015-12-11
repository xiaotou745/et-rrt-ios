//
//  RefuseView.h
//  RRDT1.0
//
//  Created by riverman on 15/12/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//
// 未通过

#import <UIKit/UIKit.h>
#include "WaitingView.h"
@interface RefuseView : UITableView<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSMutableArray     *modeArr;

@property (nonatomic,assign) NSInteger          nextId;
@property (nonatomic,strong) NSString          *taskId;

- (void)post;


@end
