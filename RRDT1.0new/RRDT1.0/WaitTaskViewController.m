//
//  WaitTaskViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/22.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "WaitTaskViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "LoginViewController.h"

#import "WaitTaskTableViewCell.h"

#import "MyCenterViewController.h"

#import "CurrentTaskViewController.h"

#import "NewTaskContentViewController.h"

@interface WaitTaskViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    CLLocationManager *_manager;
    
}

@property (nonatomic,strong) UITableView *mytable;

@property (nonatomic,strong) UILabel *cityLabel;

@property (nonatomic,strong) NSMutableArray     *modeArr;

@property (nonatomic,assign) float              Longitude;

@property (nonatomic,assign) float              Latitude;

@property (nonatomic,assign) NSInteger          nextId;

@end

@implementation WaitTaskViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
    
//    NSData *data = [dd objectForKey:@"myUser"];
//    
//    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *cityname = [dd objectForKey:@"cityname"];
    
    if (cityname.length == 0) {
        _cityLabel.text = @"北京市";
    }else{
        _cityLabel.text = cityname;
    }
    User *user = [[User alloc] init];
    
    
    
    if (user.isLogin == NO) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"0xffffff" alpha:0.8]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_mytask"] style:UIBarButtonItemStylePlain target:self action:@selector(mytask)];
        [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_center"] style:UIBarButtonItemStylePlain target:self action:@selector(mycenter)];
        [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _nextId = 0;
    [self post];
    
    
}
- (void)receive{
    NSLog(@">>>>>通知");
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    [self getLocation];
    
    [self viewCreat];
    
}
- (void)current{
    [self mytask];
}
- (void)viewCreat{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive) name:@"ChangePasswordNototification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(current) name:@"CurrentNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passAgain:) name:@"passAgain" object:nil];
    
    _modeArr = [NSMutableArray array];
    _nextId = 0;
    UIImageView *address_img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_address"]];
    address_img.frame = CGRectMake(10, 10, 20, 20);
    [self.view addSubview:address_img];
    
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, WIDTH - 40, 40)];
    _cityLabel.backgroundColor = [UIColor whiteColor];
    _cityLabel.textColor = UIColorFromRGB(0x333333);
    _cityLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_cityLabel];
    
    _mytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.emptyDataSetDelegate = self;
    _mytable.emptyDataSetSource = self;
    _mytable.showsHorizontalScrollIndicator = NO;
    _mytable.showsVerticalScrollIndicator = NO;
    _mytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mytable];
    _mytable.backgroundColor = UIColorFromRGB(0xe8e8e8);
    _mytable.tableFooterView = [UIView new];
    _mytable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _nextId = 0;
        [_mytable.header beginRefreshing];
        [self post];
//        [_mytable.header endRefreshing];
    }];
    _mytable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_mytable.footer beginRefreshing];
        [self post];
//        [_mytable.footer endRefreshing];
    }];
    

    
    self.title = @"可接任务";
    
    
    
}
- (void)mycenter{
    MyCenterViewController *mycenter = [[MyCenterViewController alloc] init];
    
    [self.navigationController pushViewController:mycenter animated:YES];
}
- (void)mytask{
    CurrentTaskViewController *currentVC = [[CurrentTaskViewController alloc] init];
    [self.navigationController pushViewController:currentVC animated:YES];
}
- (void)login{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 定位

- (void)getLocation{
    _manager = [[CLLocationManager alloc] init];
    
//    if (![CLLocationManager locationServicesEnabled]) {
//        NSLog(@"定位不可用");
//    }
//    
//    if([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [_manager requestAlwaysAuthorization]; // 永久授权
//        [_manager requestWhenInUseAuthorization]; //使用中授权
//    }
    
    _manager.delegate = self;
    _manager.desiredAccuracy=kCLLocationAccuracyBest;
    _manager.distanceFilter=10.0;
    
    [_manager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                
                [_manager requestWhenInUseAuthorization];
                
            }
            
            break;
            
        case kCLAuthorizationStatusDenied:
            
            NSLog(@"请在设置-隐私-定位服务中开启定位功能！");
            [self alertshowWithStr:@"请在设置-隐私-定位服务中开启定位功能！"];
//             [_manager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusRestricted:
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"定位服务无法使用！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            NSLog(@"定位服务无法使用！");
            [self alertshowWithStr:@"定位服务无法使用！"];
            
        default:
            
            break;
            
    }
}
- (void)alertshowWithStr:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];

}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //定位失败
    NSLog(@"----定位失败");
    _cityLabel.text = @"北京市";
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *test = [placemark addressDictionary];
            
            //  Country(国家)  State(城市)  SubLocality(区)
            
            NSLog(@"》》》》》》》》》%@", [test objectForKey:@"State"]);
            _cityLabel.text = [NSString stringWithFormat:@"%@",[test objectForKey:@"State"]];
            NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
            [dd setValue:[test objectForKey:@"State"] forKey:@"cityname"];
            [dd synchronize];
        }
        
    }];
}

#pragma mark table代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
//    TaskTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WaitTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    
    if (!cell) {
        cell = [[WaitTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (_modeArr.count > 0) {
        Task *task = [_modeArr objectAtIndex:indexPath.section];
        cell.headLabel.text = [NSString stringWithFormat:@"%@",task.taskName];
        cell.infoLabel.text = task.taskGeneralInfo;
        cell.leftLab.text = [NSString stringWithFormat:@"可领 %@",task.availableCount];
        
        
        NSLog(@">>>>>%@",[task.endTime substringWithRange:NSMakeRange(0, 18)]);
        cell.rightLab.text = [NSString stringWithFormat:@"%@",[self timeHelper:[task.endTime substringWithRange:NSMakeRange(0, 18)]]];
        
        
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
#pragma mark 请求数据
- (void)post{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else{
        
        
        
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        
        User *user = [[User alloc] init];
        
        NSDictionary *parmeters = @{@"userId"       :user.isLogin?user.userId:@"0",
                                    @"longitude"    :[NSString stringWithFormat:@"%f",_Longitude],
                                    @"latitude"     :[NSString stringWithFormat:@"%f",_Latitude],
                                    @"nextId"       :[NSString stringWithFormat:@"%zi",_nextId],
                                    @"itemsCount"   :@"10"
                                    };
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_GetNewTaskList] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSLog(@"wait%@ and %@",responseObject,operation);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"total"] intValue] == 0 ) {
//                    [self.view makeToast:@"没有更多了" duration:1.0 position:CSToastPositionCenter];
//                    [_mytable reloadData];
                }else{
                    if (_nextId == 0) {
                        [_modeArr removeAllObjects];
                    }
                    _nextId = [[[responseObject objectForKey:@"data"] objectForKey:@"nextId"] integerValue];
                    
                    
                    
                    for ( NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"content"]) {
                        Task *task  = [[Task alloc] init];
                        task.taskId             = [dic objectForKey:@"taskId"];
                        task.taskGeneralInfo    = [dic objectForKey:@"taskGeneralInfo"];
                        task.logo               = [dic objectForKey:@"logo"];
                        task.taskName           = [dic objectForKey:@"taskName"];
                        task.availableCount     = [dic objectForKey:@"availableCount"];
                        task.amount             = [[dic objectForKey:@"amount"] floatValue];
                        task.orderId            = [dic objectForKey:@"orderId"];
                        task.endTime            = [dic objectForKey:@"endTime"];
                        [_modeArr addObject:task];
                        
                        
                    }
                    
                }
                [_mytable reloadData];
            }else{
                NSLog(@">>>>>>%@",[responseObject objectForKey:@"msg"]);
                [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionCenter];
                
            }
            [_mytable.header endRefreshing];
            [_mytable.footer endRefreshing];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
            [_mytable.header endRefreshing];
            [_mytable.footer endRefreshing];
            
            
            [self.view makeToast:@"加载失败" duration:1.0 position:CSToastPositionCenter];
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *task = [_modeArr objectAtIndex:indexPath.section];
    NewTaskContentViewController *newTask = [[NewTaskContentViewController alloc] init];
    newTask.task = task;
    newTask.type = 1;
    newTask.onlyType = 999;
    [self.navigationController pushViewController:newTask animated:YES];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有可接任务";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSString *text = @"点我刷新";;
    UIFont *font = [UIFont boldSystemFontOfSize:20.0];
    UIColor *textColor = UIColorFromRGB(0x00bcd5 );
    
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _nextId = 0;
    [self post];
}
- (NSString *)timeHelper:(NSString *)timeStr{
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mydata = [dateformatter dateFromString:timeStr];
    //返回给定时间距离现在经过的秒数
    NSTimeInterval mytimenow = [mydata timeIntervalSinceNow];
    
    NSString *myStr;
    if (mytimenow < 60) {
        if (mytimenow <= 0) {
            myStr = [NSString stringWithFormat:@"已结束"];
        }else{
            myStr = [NSString stringWithFormat:@"%.f秒",mytimenow];
        }
    }else if (mytimenow < 60*60){
        myStr = [NSString stringWithFormat:@"剩余领取时间 %.f分",mytimenow/60];
    }else if (mytimenow < 60*60*24){
        myStr = [NSString stringWithFormat:@"剩余领取时间 %.f小时",mytimenow/60/60];
    }else{
        myStr = [NSString stringWithFormat:@"剩余领取时间 %.f天",mytimenow/60/60/24];
    }
    
    return myStr;
}
- (void)dealloc{
     
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangePasswordNototification" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CurrentNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passAgain" object:nil];
}
@end
