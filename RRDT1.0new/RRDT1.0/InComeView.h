//
//  InComeView.h
//  RRDT1.0
//
//  Created by riverman on 16/1/11.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

#define InComeView_showProgressHUD @"InComeView_showProgressHUD"
#define InComeView_hideProgressHUD @"InComeView_hideProgressHUD"

@interface InComeView : UITableView<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSMutableArray     *modeArr;

@property (nonatomic,assign) NSInteger          nextId;

- (void)post;
@end
