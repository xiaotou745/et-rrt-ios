//
//  ReceivedView.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/26.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ReceivedView_doShare @"ReceivedView_doShare"
#define ReceivedView_toTaskDetail @"ReceivedView_toTaskDetail"

@interface ReceivedView : UITableView<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSMutableArray     *modeArr;

@property (nonatomic,assign) NSInteger          nextId;

- (void)post;

@end
