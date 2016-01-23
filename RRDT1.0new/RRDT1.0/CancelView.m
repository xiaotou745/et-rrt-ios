//
//  CancelView.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/28.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "CancelView.h"

#import "MyTaskTableViewCell.h"

@implementation CancelView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(WIDTH * 2, 0, WIDTH, HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
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
    MyTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    
    if (!cell) {
        cell = [[MyTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (_modeArr.count > 0){
        Task *task = [_modeArr objectAtIndex:indexPath.section];
        cell.headLabel.text = [NSString stringWithFormat:@"%@",task.taskName];
        cell.infoLabel.text = task.taskGeneralInfo;
        cell.topLab.text = [NSString stringWithFormat:@"取消时间 %@",[task.cancelTime substringToIndex:16]];
        
        
        
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
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *task = [_modeArr objectAtIndex:indexPath.section];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"myselect" object:task userInfo:@{@"type":@"7"}];
}
#pragma mark 请求数据
- (void)post{
    //[MBProgressHUD showHUDAddedTo:self animated:YES];
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    }else{
        
        [CoreViewNetWorkStausManager dismiss:self animated:YES];
        
        
        User *user = [[User alloc] init];
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        
        NSDictionary *parmeters = @{@"userId"       :user.userId,
                                    @"itemsCount"   :@"10",
                                    @"orderType"    :@"2",
                                    @"nextId"       :[NSString stringWithFormat:@"%zi",_nextId]
                                    };
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        parmeters=[HttpHelper  security:parmeters];
       
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_GetAlltaskList] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            if (_nextId == 0) {
                [_modeArr removeAllObjects];
            }
            NSLog(@"cancel%@",responseObject);
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
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
//                    task.cancelTime         = [dic objectForKey:@"cancelTime"];
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
    return 120;
}

@end
