//
//  TDListCheckingView.h
//  RRDT1.0
//
//  Created by riverman on 16/1/19.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TaskDListVC_BadgeValue @"TaskDListVC_BadgeValue"
#define TaskDListVC_toTaskDetail @"TaskDListVC_toTaskDetail"

@interface TDListCheckingView : UITableView<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic,strong) NSMutableArray     *modeArr;

@property (nonatomic,assign) NSInteger          nextId;

- (void)post;
@end
