//
//  PartnerListViewController.m
//  RRDT1.0
//
//  Created by riverman on 16/3/1.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "PartnerListViewController.h"
#import "ParterModel.h"
#import "PartnerListCell.h"
@interface PartnerListViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *PLTableVIew;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger          nextId;

@end

@implementation PartnerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self setupRefresh];
    [self downPullRefreshAction];
    
}
-(void)configNavBar
{
    self.title=@"我的合伙人";
    
    self.PLTableVIew.delegate=self;
    self.PLTableVIew.dataSource=self;
    self.PLTableVIew.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.PLTableVIew.sectionFooterHeight=0;
    self.PLTableVIew.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    _dataArray=[NSMutableArray array];
    
    UIView *BGView=[ManFactory createImageViewWithFrame:CGRectMake(0, 0, DEF_SCEEN_WIDTH, 40) ImageName:@""];
    
    UIImageView *logoV=[ManFactory createImageViewWithFrame:CGRectMake(10, 10, 20, 20) ImageName:@"icon_part"];
    UILabel *title=[ManFactory createLabelWithFrame:CGRectMake(logoV.right+10, 0, 200, 40) Font:15 Text:[NSString stringWithFormat:@"目前已有%@位合伙人",_partnerNUm]];
    title.textColor=[UIColor colorWithRed:0.13 green:0.76 blue:0.85 alpha:1];
    [BGView addSubview:logoV];
    [BGView addSubview:title];
    self.PLTableVIew.tableHeaderView=BGView;
    
}

- (void)setupRefresh
{
    __weak __typeof(self) weakSelf = self;
    self.PLTableVIew.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _nextId = 0;
        [self.PLTableVIew.header beginRefreshing];
        [weakSelf downPullRefreshAction];
    }];
    self.PLTableVIew.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.PLTableVIew.footer beginRefreshing];
        [weakSelf addMOreMsg];
    }];
    
    
}

-(void)addMOreMsg
{
    [self.PLTableVIew.footer  beginRefreshing];
    [self requestMsgList];
}
-(void)downPullRefreshAction
{
    [self.PLTableVIew.header  beginRefreshing];
    [self requestMsgList];
}

-(void)requestMsgList
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _user = [[User alloc] init];
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parmeters = @{@"userId":_user.userId,
                                @"itemsCount":@"10",
                                @"nextId":[NSString stringWithFormat:@"%zi",_nextId]};
    
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    parmeters=[parmeters security];
    
    [self.PLTableVIew.header endRefreshing];
    [self.PLTableVIew.footer endRefreshing];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_getpartnerlist] parameters:parmeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                    ParterModel *parter  = [[ParterModel alloc] init];
                    
                    [parter setValuesForKeysWithDictionary:dic];
                    
                    [_dataArray addObject:parter];
                }
                
                
                
            }
            [self.PLTableVIew reloadData];
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


-(void)showNoMsgView{
    
//    if (_dataArray.count==0) {
//        [_noMsgLab setHidden:NO];
//    }else{
//        [_noMsgLab setHidden:YES];
//        
//    }
}
#pragma mark tableView  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuserID=@"PartnerListCellID";
    PartnerListCell *cell=[tableView dequeueReusableCellWithIdentifier:reuserID];
    if (nil == cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PartnerListCell" owner:self options:nil]firstObject];
    }
    
    cell.model=self.dataArray[indexPath.row];
    return cell;
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
