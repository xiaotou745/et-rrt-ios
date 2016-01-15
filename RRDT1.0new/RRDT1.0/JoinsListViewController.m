//
//  JoinsListViewController.m
//  RRDT1.0
//
//  Created by riverman on 16/1/13.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "JoinsListViewController.h"
#import "JoinsListCell.h"

@interface JoinsListViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray     *modeArr;

@property (nonatomic,assign) NSInteger          nextId;
@end

@implementation JoinsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"参与人列表";
    [self configView];
    _nextId = 0;
    [self post];
}

-(void)configView{

    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
//    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _modeArr = [NSMutableArray array];
    
    self.myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _nextId = 0;
        [self.myTableView.header beginRefreshing];
        [self post];
    }];
    self.myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.myTableView.footer beginRefreshing];
        [self post];
    }];

    
}
#pragma mark table代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    //    TaskTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JoinsListCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JoinsListCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.model=_modeArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
#pragma mark 请求数据
- (void)post{
    //    [MBProgressHUD showHUDAddedTo:self animated:YES];
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else{
        
        [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
        
        
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        
        User *user = [[User alloc] init];
        
        [self.myTableView.header endRefreshing];
        [self.myTableView.footer endRefreshing];
        
        NSDictionary *parmeters = @{@"userId"       :user.userId,
                                    @"itemsCount"   :@"10",
                                    @"nextId"       :[NSString stringWithFormat:@"%zi",_nextId],
                                    @"taskId":_taskId
                                    };
        
        //        NSString *jsonsss=[parmeters JSONString];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_getclienterlistbytaskid] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (_nextId == 0) {
                [_modeArr removeAllObjects];
            }
            NSLog(@"pass%@",responseObject);
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
                
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"count"] intValue] == 0 ) {
                    
                }else{
                    _nextId = [[[responseObject objectForKey:@"data"] objectForKey:@"nextId"] integerValue];
                    for ( NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"content"]) {
                        ParterModel *model  = [[ParterModel alloc] init];
                        [model setValuesForKeysWithDictionary:dic];
                        [_modeArr addObject:model];
                    }
                    
                }
                [self.myTableView reloadData];
            }else{
                [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionCenter];
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"error:::%@",error);
            [self.view makeToast:@"加载失败" duration:1.0 position:CSToastPositionCenter];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
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
