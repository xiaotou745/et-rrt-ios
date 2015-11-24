//
//  CheckingTaskView.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckingTaskView : UITableView<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

//@property (nonatomic,strong) UITableView        *mytable;

@property (nonatomic,strong) NSMutableArray             *modeArr;

@property (nonatomic,assign) NSInteger                  nextId;

- (void)post;
@end
