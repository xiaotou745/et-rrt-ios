//
//  OrderByBGView.h
//  RRDT1.0
//
//  Created by riverman on 16/1/27.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>
//orderBy	排序方式 1是佣金，2是审核周期，3是预计用时，4是参与人数，5是发布时间（int类型）
typedef enum : NSUInteger {
    orderByCommission=1,
    orderByCycle,
    orderByAverageTime,
    orderByJoinNumbers,
    orderByCreateTime,
    
} orderByType;

#define OrderByTypeView_select @"OrderByTypeView_select"
@interface OrderByBGView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *titles;
    NSMutableArray *images;
    NSMutableArray *colors;
    
}

@property(nonatomic,strong)UITableView *orderByTypeView;

@end
