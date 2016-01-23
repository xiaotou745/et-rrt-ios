//
//  TDListCheckingView.m
//  RRDT1.0
//
//  Created by riverman on 16/1/19.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "TDListCheckingView.h"
#import "TaskDListCell.h"
@implementation TDListCheckingView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64-40) style:UITableViewStyleGrouped];
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
    TaskDListCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TaskDListCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.model=[_modeArr objectAtIndex:indexPath.section];;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskDetailModel *task = [_modeArr objectAtIndex:indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:TaskDListVC_toTaskDetail object:@{@"task":task,@"index":@(0)}];
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
                                    @"auditStatus"    :@(auditStatusWaiting),
                                    @"nextId"       :[NSString stringWithFormat:@"%zi",_nextId]
                                    };
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        parmeters=[HttpHelper  security:parmeters];
        
        //        NSString *jsonsss=[parmeters JSONString];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_getmytaskdatumgrouplist] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            
            if (_nextId == 0) {
                [_modeArr removeAllObjects];
            }
            NSLog(@"pass%@",responseObject);
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
                [[NSNotificationCenter defaultCenter]postNotificationName:TaskDListVC_BadgeValue object:self userInfo:@{
                                                                                                                         @"waitTotal":[[responseObject objectForKey:@"data"] objectForKey:@"waitTotal"],
                                                                                                                         @"passTotal":[[responseObject objectForKey:@"data"] objectForKey:@"passTotal"],
                                                                                                                         @"refuseTotal":[[responseObject objectForKey:@"data"] objectForKey:@"refuseTotal"]}];
                
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"count"] intValue] == 0 ) {
                    
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
    NSString *text = @"还没有审核中的资料";
    
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
    return 85;
}



@end
