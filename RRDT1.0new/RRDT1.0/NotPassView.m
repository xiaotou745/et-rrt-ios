//
//  NotPassView.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "NotPassView.h"

#import "NotPassTableViewCell.h"

@implementation NotPassView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(WIDTH*2, 0, WIDTH, HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
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
        //        [self addSubview:self];
        
        
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
    NotPassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    
    if (!cell) {
        cell = [[NotPassTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (_modeArr.count > 0){
        Task *task = [_modeArr objectAtIndex:indexPath.section];
        cell.headLabel.text = [NSString stringWithFormat:@"%@",task.taskName];
        cell.infoLabel.text = task.taskGeneralInfo;
//        cell.topLab.text = [NSString stringWithFormat:@"审核时间 %@",[task.auditTime substringToIndex:16]];
//        
//        
//        cell.buttomLab.text = [NSString stringWithFormat:@"提交时间 %@",[task.receivedTime substringToIndex:16]];
//        
        cell.lab_last.text = [NSString stringWithFormat:@"失败原因"];
        
        //    cell.moneyLab.text = [NSString stringWithFormat:@"￥9999.99/次"];
        cell.moneyLab.textColor = [UIColor clearColor];
        cell.moneyLab.text = [NSString stringWithFormat:@"￥%.2f/次",task.amount];
        [cell.moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(0,1)];
        [cell.moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(1,cell.moneyLab.text.length - 3)];
        [cell.moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:10] range:NSMakeRange(cell.moneyLab.text.length - 2,2)];
        [cell.moneyLab addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(0,cell.moneyLab.text.length - 2)];
        [cell.moneyLab addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(cell.moneyLab.text.length - 2,2)];
        //    [cell.moneyLab updateLabelStyle];
        
        
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",task.logo]] placeholderImage:[UIImage imageNamed:@"icon_morentu"] options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        [cell.btn_giveup addTarget:self action:@selector(giveupTask:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_giveup.tag = indexPath.section;
        
        cell.btn_post.tag = indexPath.section;
        [cell.btn_post addTarget:self action:@selector(againPost:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
- (void)againPost:(UIButton *)btn{
    //再次提交
    Task *task = [_modeArr objectAtIndex:btn.tag];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"againPost" object:task userInfo:nil];
}
- (void)giveupTask:(CoreStatusBtn *)btn{
    
    

                    CustomIOSAlertView *alert = [self successAlert:@"icon_tishi" andtitle:@"提示" andmsg:@"任务还未完成，确认要放弃吗？" andButtonItem:[NSMutableArray arrayWithObjects:@"确定",@"取消", nil]];
                    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                        [alertView close];
                        if (buttonIndex == 0) {
                            if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]){
                                [self makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
                            }else{
                                
                                Task *task = [_modeArr objectAtIndex:btn.tag];
                                btn.status = CoreStatusBtnStatusProgress;
                                User *user = [[User alloc] init];
                                
                                NSDictionary *parameters = @{@"userId":user.userId,
                                                             @"orderId":task.orderId,
                                                             @"remark":@""};
                                AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
                                parameters=[parameters security];
                                
                                NSLog(@">>>>>%@",parameters);
                                [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_GiveUpTask] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSLog(@"JSON: %@", responseObject);
                                    NSNumber *code = [responseObject objectForKey:@"code"];
                                    int code_int = [code intValue];
                                    if (code_int == 200) {
                                        
                                        btn.status = CoreStatusBtnStatusSuccess;
                                        
                                        
                                        
                                        [self makeToast:@"放弃成功" duration:1.0 position:CSToastPositionTop];
                                        [self.header beginRefreshing];
                                        
                                    }else{
                                        btn.status = CoreStatusBtnStatusFalse;
                                        NSLog(@"code : %zi    %@",code,[responseObject objectForKey:@"msg"]);
                                        [[[self superview] superview] makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
                                    }
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    btn.status = CoreStatusBtnStatusFalse;
                                    NSLog(@"Error: %@", error);
                                }];
                            }
                        }
    
                    }];
                    [alert show];
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *task = [_modeArr objectAtIndex:indexPath.section];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"select" object:task userInfo:@{@"type":@"4"}];
}
#pragma mark 请求数据
- (void)post{
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    }else{
        
        [CoreViewNetWorkStausManager dismiss:self animated:YES];
        
        User *user = [[User alloc] init];
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
        NSDictionary *parmeters = @{@"userId"       :user.userId,
                                    @"itemsCount"   :@"10",
                                    @"orderType"    :@"5",
                                    @"nextId"       :[NSString stringWithFormat:@"%zi",_nextId]
                                    };
    
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        parmeters=[parmeters security];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_GetAlltaskList] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            if (_nextId == 0) {
                [_modeArr removeAllObjects];
            }
            NSLog(@"json2%@",responseObject);
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeSelcct" object:self userInfo:@{
                                                                                                                @"receivedCount":[[responseObject objectForKey:@"data"] objectForKey:@"receivedCount"],
                                                                                                                @"passCount":[[responseObject objectForKey:@"data"] objectForKey:@"passCount"],
                                                                                                                @"noPassCount":[[responseObject objectForKey:@"data"] objectForKey:@"noPassCount"]}];
                
                
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"total"] intValue] == 0 ) {
                    //                    [self makeToast:@"没有更多了" duration:1.0 position:CSToastPositionCenter];
                    //                    [_mytable reloadData];
//                    [self.footer endRefreshingWithNoMoreData];
                }else{
                    _nextId = [[[responseObject objectForKey:@"data"] objectForKey:@"nextId"] integerValue];
                for ( NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"content"]) {
                    Task *task  = [[Task alloc] init];
//                    task.amount             = [[dic objectForKey:@"amount"] floatValue];
//                    task.auditTime          = [dic objectForKey:@"auditTime"];
//                    task.availableCount     = [dic objectForKey:@"availableCount"];
//                    task.beginTime          = [dic objectForKey:@"beginTime"];
//                    task.endTime            = [dic objectForKey:@"endTime"];
//                    task.finishTime         = [dic objectForKey:@"finishTime"];
//                    task.logo               = [dic objectForKey:@"logo"];
//                    task.orderId            = [dic objectForKey:@"orderId"];
//                    task.receivedTime       = [dic objectForKey:@"receivedTime"];
//                    task.status             = [dic objectForKey:@"status"];
//                    task.taskCycle          = [dic objectForKey:@"taskCycle"];
//                    task.taskGeneralInfo    = [dic objectForKey:@"taskGeneralInfo"];
//                    task.taskId             = [dic objectForKey:@"taskId"];
//                    task.taskName           = [dic objectForKey:@"taskName"];
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
    NSString *text = @"还没有未通过的任务";
    
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
    return 200;
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
