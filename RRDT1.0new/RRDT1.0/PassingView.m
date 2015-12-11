//
//  PassingView.m
//  RRDT1.0
//
//  Created by riverman on 15/12/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "PassingView.h"

#import "CoreStatusBtn.h"
#import "TaskDetailCell.h"


@implementation PassingView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(WIDTH * 1, 0, WIDTH, HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        _modeArr = [NSMutableArray array];
        self.dataSource = self;
        self.delegate = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        self.backgroundColor = UIColorFromRGB(0xe8e8e8);
        
        
        self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _nextId = 0;
            [self.header beginRefreshing];
            [self post];
        }];
        self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self.footer beginRefreshing];
            [self post];
        }];
        
        
        //        [MBProgressHUD showHUDAddedTo:self animated:YES];
        //
        //        [self post];
    }
    return self;
}
#pragma mark table代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modeArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    TaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TaskDetailCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    TaskDetailModel *task = [_modeArr objectAtIndex:indexPath.section];
    cell.model=task;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskDetailModel *task = [_modeArr objectAtIndex:indexPath.section];
    [[NSNotificationCenter defaultCenter]postNotificationName:gotoCheckProgressVC object:task userInfo:nil];
}

#pragma mark 请求数据
- (void)post{
    //    [MBProgressHUD showHUDAddedTo:self animated:YES];
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    }else{
        
        [CoreViewNetWorkStausManager dismiss:self animated:YES];
        
        
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        
        User *user = [[User alloc] init];
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
        NSDictionary *parmeters = @{@"userId"       :user.userId,
                                    @"itemsCount"   :@"10",
                                    @"auditStatus"    :@(auditStatusPass),
                                    @"nextId"       :[NSString stringWithFormat:@"%zi",_nextId],
                                    @"taskId":_taskId
                                    };
        if (_nextId == 0) {
            [_modeArr removeAllObjects];
        }
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_Getmytaskdatumlist] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            
            NSLog(@"pass%@",responseObject);
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
                [[NSNotificationCenter defaultCenter]postNotificationName:TaskDetailVC_BadgeValue object:self userInfo:@{
                                                                                                                         @"waitTotal":[[responseObject objectForKey:@"data"] objectForKey:@"waitTotal"],
                                                                                                                         @"passTotal":[[responseObject objectForKey:@"data"] objectForKey:@"passTotal"],
                                                                                                                         @"refuseTotal":[[responseObject objectForKey:@"data"] objectForKey:@"refuseTotal"]}];
                
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"count"] intValue] == 0 ) {
                    //                    [self makeToast:@"没有更多了" duration:1.0 position:CSToastPositionCenter];
                    //                    [_mytable reloadData];
                    //                    [self.footer endRefreshingWithNoMoreData];
                }else{
                    _nextId = [[[responseObject objectForKey:@"data"] objectForKey:@"nextId"] integerValue];
                    for ( NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"content"]) {
                        TaskDetailModel *task  = [[TaskDetailModel alloc] init];

                        [task setValuesForKeysWithDictionary:dic];
                        
                        [_modeArr addObject:task];
                    }
                    
                }
                [self reloadData];
            }else{
                [self makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionCenter];
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"error:::%@",error);
            [self makeToast:@"加载失败" duration:1.0 position:CSToastPositionCenter];
            [MBProgressHUD hideHUDForView:self animated:YES];
        }];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有通过审核的任务";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSString *text = @"点我刷新";;
    UIFont *font = [UIFont boldSystemFontOfSize:20.0];
    UIColor *textColor = UIColorFromRGB(0x00bcd5);
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    _nextId = 0;
    [self post];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
    
}
- (void)againReceived:(CoreStatusBtn *)btn{
    NSLog(@">>>>>>%zi",btn.tag);
    //    btn.status = CoreStatusBtnStatusProgress;
    
    Task *task = [_modeArr objectAtIndex:btn.tag];
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]){
        [self makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        
        btn.status = CoreStatusBtnStatusProgress;
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        User *user = [[User alloc] init];
        NSDictionary *parameters = @{@"userId":user.userId,
                                     @"taskId":task.taskId};
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_ReceiverTask] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@">>>>>reservetask ----%@",responseObject);
            NSNumber *code = [responseObject objectForKey:@"code"];
            int code_int = [code intValue];
            if (code_int == 200) {
                
                
                btn.status = CoreStatusBtnStatusSuccess;
                
                NSString *timeStr = [NSString stringWithFormat:@"请在%@小时内完成任务。\n 提示:完成之后不要忘记提交审核哦",task.taskCycle];
                
                CustomIOSAlertView *alert = [self successAlert:@"icon_success" andtitle:@"领取成功" andmsg:timeStr andButtonItem:[NSMutableArray arrayWithObjects:@"确定",@"当前任务", nil]];
                [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                    NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                    
                    [alertView close];
                    
                    if (buttonIndex == 1) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"passAgain" object:nil userInfo:nil];
                    }else{
                        _nextId = 0;
                        
                        [self post];
                    }
                    
                    
                    
                }];
                [alert show];
                
            }else{
                btn.status = CoreStatusBtnStatusFalse;
                [[[self superview] superview] makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
    
}
- (CustomIOSAlertView *)successAlert:(NSString *)imgStr andtitle:(NSString *)title andmsg:(NSString *)msg andButtonItem:(NSMutableArray *)item{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 40, HEIGHT/4)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
    UILabel *lab_titile = [[UILabel alloc] init];
    lab_titile.font = [UIFont systemFontOfSize:16];
    lab_titile.textColor = UIColorFromRGB(0x666666);
    lab_titile.textAlignment = NSTextAlignmentCenter;
    UILabel*lab_msg = [[UILabel alloc] init];
    lab_msg.font = [UIFont systemFontOfSize:14];
    lab_msg.textColor = UIColorFromRGB(0x888888);
    lab_msg.numberOfLines = 0;
    lab_msg.textAlignment = NSTextAlignmentCenter;
    [view addSubview:img];
    [view addSubview:lab_titile];
    [view addSubview:lab_msg];
    lab_titile.text = title;
    lab_msg.text = msg;
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.mas_equalTo(HEIGHT/15);
        make.width.mas_equalTo(HEIGHT/15);
    }];
    [lab_titile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.left.equalTo(view).with.offset(20);
        make.right.equalTo(view).with.offset(-20);
    }];
    [lab_msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile.mas_bottom);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.left.equalTo(view).with.offset(20);
        make.right.equalTo(view).with.offset(-20);
    }];
    
    // Add some custom content to the alert view
    [alertView setContainerView:view];
    
    // Modify the parameters
    [alertView setButtonTitles:item];
    
    // You may use a Block, rather than a delegate.
    
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    
    
    return alertView;
}

@end
