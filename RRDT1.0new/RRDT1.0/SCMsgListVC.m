//
//  SCMsgListVC.m
//  SupermanC
//
//  Created by riverman on 15/6/18.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "SCMsgListVC.h"
#import "SCMsgListCell.h"
#import "SCMsgDetailVC.h"
#import "MJRefresh.h"

@interface SCMsgListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *scmlTableView;
@property (weak, nonatomic) IBOutlet UILabel *noMsgLab;

@property(assign ,nonatomic)NSUInteger readMeg_index;
@property (strong, nonatomic)NSMutableDictionary *readDic;//读取的 信息字典

@property (nonatomic,assign) NSInteger          nextId;

@end

@implementation SCMsgListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self setupRefresh];
    [self downPullRefreshAction];

}
- (void)setupRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    self.scmlTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _nextId = 0;
        [self.scmlTableView.header beginRefreshing];
        [weakSelf downPullRefreshAction];
    }];
    self.scmlTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.scmlTableView.footer beginRefreshing];
        [weakSelf addMOreMsg];
    }];


}

-(void)addMOreMsg
{
    [self.scmlTableView.footer  beginRefreshing];
    [self requestMsgList];
}
-(void)downPullRefreshAction
{
    [self.scmlTableView.header  beginRefreshing];
    [self requestMsgList];
}

-(void)requestMsgList
{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    _user = [[User alloc] init];
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parmeters = @{@"userId":_user.userId,
                                @"itemsCount":@"10",
                                @"nextId":[NSString stringWithFormat:@"%zi",_nextId]};
    
    
    
   
    [self.scmlTableView.header endRefreshing];
    [self.scmlTableView.footer endRefreshing];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_Getmymsglist] parameters:parmeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@">>>>>%@",operation);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (_nextId == 0) {
            [_dataArray removeAllObjects];
        }
        
        NSLog(@"JSON: %@", responseObject);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"count"] intValue] == 0 ) {
                
            }else{
                
                
                _nextId = [[[responseObject objectForKey:@"data"] objectForKey:@"nextId"] integerValue];
                for ( NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"content"]) {
                    MsgModel *task  = [[MsgModel alloc] init];
                    
                    [task setValuesForKeysWithDictionary:dic];
                    
                    [_dataArray addObject:task];
                }
                
                
                
            }
            [self.scmlTableView reloadData];
        }else{
            [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:[responseObject objectForKey:@"msg"] offsetY:-100 failClickBlock:^{
                NSLog(@"?>?>>>>>??>?>");
            }];
        }
     
        [self showNoMsgView];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"未知错误" offsetY:-100 failClickBlock:^{
             NSLog(@"?>?>>>>>??>?>");
         }];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self showNoMsgView];

     }];
    
}

-(void)configNavBar
{
    self.title=@"消息中心";
    
    self.scmlTableView.delegate=self;
    self.scmlTableView.dataSource=self;
    self.scmlTableView.sectionFooterHeight=0;
    self.scmlTableView.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    _dataArray=[NSMutableArray array];
}
-(void)showNoMsgView{

    if (_dataArray.count==0) {
        [_noMsgLab setHidden:NO];
    }else{
        [_noMsgLab setHidden:YES];

    }
}
#pragma mark tableView  delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 60;
    MsgModel *task  = [[MsgModel alloc] init];
    task=self.dataArray[indexPath.row];
    CGSize size = [task.msg boundingRectWithSize:CGSizeMake(WIDTH-20, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    return size.height + 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuserID=@"SCMsgListCellID";
    SCMsgListCell *cell=[tableView dequeueReusableCellWithIdentifier:reuserID];
    if (nil == cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SCMsgListCell" owner:self options:nil]firstObject];
    }
    
    cell.model=self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgModel *task  = [[MsgModel alloc] init];
    task=self.dataArray[indexPath.row];
//    task.hasRead=1;
//    [_scmlTableView reloadData];
    SCMsgDetailVC *vc=[[SCMsgDetailVC alloc]initWithNibName:@"SCMsgDetailVC" bundle:nil];
    vc.model=task;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
