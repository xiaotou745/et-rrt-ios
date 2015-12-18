//
//  CheckingTaskView.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "CheckingTaskView.h"
#import "ReceivedTableViewCell.h"
#import "CheckingTaskTableViewCell.h"

@implementation CheckingTaskView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(WIDTH*1, 0, WIDTH, HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
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
    
    Task *task = [_modeArr objectAtIndex:indexPath.section];
    if (task.taskType==taskType_write) {
        
        static NSString *idenifier = @"ReceivedTableViewCell";
        ReceivedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
        if (!cell) {
            cell = [[ReceivedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.headLabel.text = [NSString stringWithFormat:@"%@",task.taskName];
        
        cell.infoLabel.text =[NSString stringWithFormat:@" %@  %@",[MyTools getTasktype:task.taskType],task.taskGeneralInfo];
        
        [cell.infoLabel addAttr:CoreLabelAttrColor value:[UIColor whiteColor] range:NSMakeRange(0,4)];
        [cell.infoLabel addAttr:CoreLabelAttBackgroundColor value:[MyTools getTasktypeBGColor:task.taskType] range:NSMakeRange(0,4)];
        
        [cell.infoLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(4,cell.infoLabel.text.length - 4)];
        
        
        cell.waitLab.text = [NSString stringWithFormat:@"审核中(%d)",task.auditWaitNum];
        cell.passLab.text = [NSString stringWithFormat:@"已通过(%d)",task.auditPassNum];
        cell.refuseLab.text = [NSString stringWithFormat:@"未通过(%d)",task.auditRefuseNum];
        
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
        __block CheckingTaskView *blockSelf=self;
        cell.waitBlock=^{
            [blockSelf  gotoTaskDetail:task Index:0];
        };
        cell.passBlock=^{
            [blockSelf  gotoTaskDetail:task Index:1];
            
        };
        cell.refuseBlock=^{
            [blockSelf  gotoTaskDetail:task Index:2];
            
        };
        return cell;
        
        
    }else{
        static NSString *checkIdenifier = @"CheckingTaskTableViewCell";
        CheckingTaskTableViewCell *checkCell = [tableView dequeueReusableCellWithIdentifier:checkIdenifier];
        if (!checkCell) {
            checkCell = [[CheckingTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:checkIdenifier];
            checkCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        checkCell.headLabel.text = [NSString stringWithFormat:@"%@",task.taskName];
        
        checkCell.infoLabel.text =[NSString stringWithFormat:@" %@  %@",[MyTools getTasktype:task.taskType],task.taskGeneralInfo];
        
        [checkCell.infoLabel addAttr:CoreLabelAttrColor value:[UIColor whiteColor] range:NSMakeRange(0,4)];
        [checkCell.infoLabel addAttr:CoreLabelAttBackgroundColor value:[MyTools getTasktypeBGColor:task.taskType] range:NSMakeRange(0,4)];
        
        [checkCell.infoLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(4,checkCell.infoLabel.text.length - 4)];
        checkCell.waitLab.text = [NSString stringWithFormat:@"成功分享 %d次",task.complateNum];
        
        //    cell.moneyLab.text = [NSString stringWithFormat:@"￥9999.99/次"];
        checkCell.moneyLab.textColor = [UIColor clearColor];
        checkCell.moneyLab.text = [NSString stringWithFormat:@"￥%.2f/次",task.amount];
        [checkCell.moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(0,1)];
        [checkCell.moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(1,checkCell.moneyLab.text.length - 3)];
        [checkCell.moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:10] range:NSMakeRange(checkCell.moneyLab.text.length - 2,2)];
        [checkCell.moneyLab addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(0,checkCell.moneyLab.text.length - 2)];
        [checkCell.moneyLab addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(checkCell.moneyLab.text.length - 2,2)];
        //    [cell.moneyLab updateLabelStyle];
        
        
        
        [checkCell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",task.logo]] placeholderImage:[UIImage imageNamed:@"icon_morentu"] options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        __block CheckingTaskView *blockSelf=self;
        checkCell.recBTNClick=^{
            
            [blockSelf doShare:task];
        };
        return checkCell;
    }
}
-(void)doShare:(Task *)task{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedView_doShare object:task];
}

-(void)gotoTaskDetail:(Task *)task Index:(NSInteger)index{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedView_toTaskDetail object:@{@"task":task,@"index":@(index)}];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *task = [_modeArr objectAtIndex:indexPath.section];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"select" object:task userInfo:@{@"type":@"3"}];
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
                                    ,@"taskStatus":@(3)};
        
        
        
       
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_GetreceiveTaskList] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            if (_nextId == 0) {
                [_modeArr removeAllObjects];
            }
            NSLog(@"json2%@",responseObject);
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeSelcct" object:self userInfo:@{
                                                                                                                 @"passTotal":[[responseObject objectForKey:@"data"] objectForKey:@"passTotal"],
                                                                                                                 @"refuseTotal":[[responseObject objectForKey:@"data"] objectForKey:@"refuseTotal"]
                                                                                                                 }];
                
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"count"] intValue] == 0 ) {
                    
                }else{
                    _nextId = [[[responseObject objectForKey:@"data"] objectForKey:@"nextId"] integerValue];
                    for ( NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"content"]) {
                        Task *task  = [[Task alloc] init];
                        
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
    NSString *text = @"还没有进行中的任务";
    
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
