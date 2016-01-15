//
//  InComeView.m
//  RRDT1.0
//
//  Created by riverman on 16/1/11.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "InComeView.h"
#import "BillDetailCell.h"

@implementation InComeView


- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 64-40) style:UITableViewStylePlain];
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
    return _modeArr.count;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return _modeArr.count;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 10;
//    }
//    return 5;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        static NSString *idenifier = @"BillDetailCellID";
        BillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"BillDetailCell" owner:self options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    cell.isInComeCell=YES;
    cell.model=_modeArr[indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BillDetailModel *model=_modeArr[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:notify_selectBillDetailCell object:@{@"model":model,@"isInComeCell":@(YES)}];
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
        
        NSDictionary *parmeters = @{@"userId":user.userId,
                                    @"itemsCount":@"10",
                                    @"nextId":[NSString stringWithFormat:@"%zi",_nextId]
                                    ,@"recordType":@(1)};
        
        
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_getbalancerecordlist] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            if (_nextId == 0) {
                [_modeArr removeAllObjects];
            }
            NSLog(@"json2%@",responseObject);
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
                
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeSelcct" object:self userInfo:@{
//                                                                                                                 @"passTotal":[[responseObject objectForKey:@"data"] objectForKey:@"passTotal"],
//                                                                                                                 @"refuseTotal":[[responseObject objectForKey:@"data"] objectForKey:@"refuseTotal"]
//                                                                                                                 }];
                
                if ([[responseObject objectForKey:@"data"] [@"count"]intValue] == 0 ) {
                    
                }else{
                    _nextId = [[[responseObject objectForKey:@"data"] objectForKey:@"nextId"] integerValue];
                    for ( NSDictionary *dic in [responseObject objectForKey:@"data"][@"content"] ) {
                        BillDetailModel *task  = [[BillDetailModel alloc] init];
                        
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
    NSString *text = @"还没有资金收入明细";
    
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
    return 60;
}
- (NSString *)timeFinsh:(NSString *)timeStr andCycle:(NSString *)cycle{
    
    
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mydata = [dateformatter dateFromString:timeStr];
    //返回给定时间距离现在经过的秒数
    NSTimeInterval mytimenow =  [mydata timeIntervalSinceNow] + [cycle intValue] * 60 * 60;
    NSString *returnStr ;
    if (mytimenow < 60) {
        if (mytimenow <= 0) {
            returnStr = [NSString stringWithFormat:@"已结束"];
        }else{
            returnStr = [NSString stringWithFormat:@"%.f秒",mytimenow];
        }
    }else if (mytimenow < 60*60){
        returnStr = [NSString stringWithFormat:@"%.f分",mytimenow/60];
    }else if (mytimenow < 60*60*24){
        returnStr = [NSString stringWithFormat:@"%.f小时",mytimenow/60/60];
    }else{
        returnStr = [NSString stringWithFormat:@"%.f天",mytimenow/60/60/24];
    }
    return returnStr;
}
@end
