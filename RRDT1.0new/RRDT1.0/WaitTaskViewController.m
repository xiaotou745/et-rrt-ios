
//
//  WaitTaskViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/22.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "WaitTaskViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "WaitTaskTableViewCell.h"
#import "NewTaskContentViewController.h"
#import "CitysViewController.h"
#import "OrderByTypeView.h"

@interface WaitTaskViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    CLLocationManager *_manager;
    
}

@property (nonatomic,strong) UITableView *mytable;

@property (nonatomic,strong) NSMutableArray     *modeArr;

@property (nonatomic,assign) float              Longitude;

@property (nonatomic,assign) float              Latitude;

@property (nonatomic,assign) NSInteger          currentPage;

@property(nonatomic,strong)NSDictionary *currentCityInfo;
@property(nonatomic,strong)NSString *StateName;//定位到的 城市名

@property (nonatomic,strong) NSMutableArray     *citysArr;

//排序的自定义view
@property(nonatomic,strong)OrderByTypeView *oderByView;
@property (nonatomic,assign) NSInteger      orderByType;

@end

@implementation WaitTaskViewController


-(void)viewWillAppear:(BOOL)animated
{
    [self showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可接任务";

    _modeArr = [NSMutableArray array];
    self.citysArr=[NSMutableArray array];
    
    _currentPage = 0;
    _orderByType=1;
    //默认为北京
    _currentCityInfo=@{cityName:@"北京市",cityCode:@(110100)};
    
    self.view.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_mytask"] style:UIBarButtonItemStylePlain target:self action:@selector(sortType)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_currentCityInfo[cityName]  style:UIBarButtonItemStylePlain target:self action:@selector(address_imgHandle)];
    [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0xffffff)];
    
 

    [self viewCreat];
    [self createOderByView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCurrentCity:) name:kChooseCityNotif object:nil];
    //领取任务后刷新当前城市的数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:loginSuccess_refreshWaitVC object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeOrderType:) name:OrderByTypeView_select object:nil];
    
    [self getLocation];
    [self getCitysRegion];
    
}

-(void)changeCurrentCity:(NSNotification *)notif{
    _currentCityInfo=notif.object;
    [self requestNewCityDatas];
}

-(void)loginSuccess{
    [self getLocation];

}
-(void)requestNewCityDatas{
    [self.navigationItem.leftBarButtonItem setTitle:_currentCityInfo[cityName]];
    _currentPage = 0;
    [self post];

}

- (void)viewCreat{

    
    _mytable = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 -IOS_TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
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
        _currentPage = 0;
//        [_mytable.header beginRefreshing];
        [self post];
//        [_mytable.header endRefreshing];
    }];
    _mytable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
//        [_mytable.footer beginRefreshing];
        _currentPage++;
        [self post];
//        [_mytable.footer endRefreshing];
    }];
    
}

-(void)address_imgHandle{
       CitysViewController *citysVC=[[CitysViewController alloc]initWithNibName:@"CitysViewController" bundle:nil];
    citysVC.modeArr=[NSMutableArray arrayWithArray:_citysArr];
    citysVC.title= [NSString stringWithFormat:@"当前城市－%@",_currentCityInfo[cityName]];

    [self.navigationController pushViewController:citysVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 定位

- (void)getLocation{
    _manager = [[CLLocationManager alloc] init];
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
            break;
            
        case kCLAuthorizationStatusRestricted:
            
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
    [_manager stopUpdatingLocation];
    _manager.delegate=nil;

    [self requestNewCityDatas];

}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [_manager stopUpdatingLocation];
    _manager.delegate=nil;

    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
//    double Latitude=44.060679;
//    double longitude=87.259918;
//116.390471,39.926002
//    117.876627,39.830765
//    114.900865,39.056902
//    112.440226,37.932754
//    111.170813,41.387036
//    117.499483,36.698461
//    121.455516,31.244703
//    87.259918,44.060679
//    CLLocation *loca=[[CLLocation alloc]initWithLatitude:Latitude longitude:longitude];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            _StateName=placemark.locality;
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@" locality(城市) %@", _StateName);
            [self checkCityCode];
        }
        
    }];
}
-(void)checkCityCode{

    if (_StateName!=nil) {
        for (NSDictionary *sectionInfo in self.citysArr) {
            
            for (NSDictionary *cityInfo in sectionInfo[KCitys_regions]) {
                
                if ([_StateName isEqualToString:cityInfo[cityName]]) {
                    
                    NSInteger code=[cityInfo[cityCode]intValue];
                    _currentCityInfo=@{cityName:_StateName,cityCode:@(code)};
                    [self requestNewCityDatas];
                    return;
                }
            }
        }
        //未匹配到 cityCode  默认为北京
        if (self.citysArr.count)  [self requestNewCityDatas];
    }
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
        cell.infoLabel.text =task.taskGeneralInfo;
        cell.taskTypeView.image=[UIImage imageNamed:[MyTools getTasktypeImageName:task.taskType]];
        cell.taskType.text=[MyTools getTasktype:task.taskType];
        
        
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

-(void)createOderByView{
    
    _oderByView=[[OrderByTypeView alloc]init];
    [self.view addSubview:_oderByView];
    [self sortType];
    
}

-(void)sortType{
    
      [_oderByView setHidden:!_oderByView.hidden];
}
-(void)changeOrderType:(NSNotification *)notif{
    
    [self sortType];
    _orderByType=[notif.object integerValue];
    [self post];
}
#pragma mark 请求数据
- (void)post{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else{
        
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        
        User *user = [[User alloc] init];
        //pageSize	每次获取数据的条数(不需要时传0，则每页15条记录)
        NSDictionary *parmeters = @{@"userId"       :user.isLogin?user.userId:@"0",
                                    @"currentPage"       :[NSString stringWithFormat:@"%zi",_currentPage],
                                    @"pageSize":@(0),
                                    @"cityCode":_currentCityInfo[cityCode],@"orderBy":@(_orderByType)};
        
        NSLog(@"_orderByType===%ld",(long)_orderByType);
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_GetNewTaskList] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if (_currentPage == 0) {
                [_modeArr removeAllObjects];
            }
//            NSLog(@"wait%@ and %@",responseObject,operation);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSInteger code = [[responseObject objectForKey:@"code"] intValue];
            if (code == 200) {
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"count"] intValue] == 0 ) {

                }else{
                                       
                    for ( NSDictionary *dic in [[responseObject objectForKey:@"data"] objectForKey:@"content"]) {
                        Task *task  = [[Task alloc] init];
                        [task setValuesForKeysWithDictionary:dic];
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
    return 85;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //滚动表视图  隐藏排序view
    if (!_oderByView.hidden) {
        [self sortType];
    }
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
    [self requestNewCityDatas];
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

#pragma mark 请求数据
- (void)getCitysRegion{
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    
    NSDictionary *parmeters = @{@"version":@"20151127"};
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_Gethotregionandall] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"wait%@ and %@",responseObject,operation);
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 200) {
            
            NSDictionary *citysData=[responseObject objectForKey:@"data"];
            if (citysData) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self configCitys:citysData];
                    [self checkCityCode];
                    
                });
            }
        }else{
            NSLog(@">>>>>>%@",[responseObject objectForKey:@"msg"]);
            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionCenter];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [self.view makeToast:@"加载失败" duration:1.0 position:CSToastPositionCenter];
        
    }];
}


-(void)configCitys:(NSDictionary *)citysData{
    
//    NSLog(@"citysArr==%@",self.citysArr);

    if ([citysData[@"hotRegionModel"] isKindOfClass:[NSArray class]]) {
        if ([citysData[@"hotRegionModel"] count]) {
            [self.citysArr addObject:@{KCitys_sectionTitle:@"热门城市",KCitys_regions:citysData[@"hotRegionModel"]}];
        }
    }
    
    if ([citysData[@"firstLetterRegionModel"] isKindOfClass:[NSArray class]]) {
        
        for (NSDictionary *cityModel in citysData[@"firstLetterRegionModel"]) {
            [self.citysArr addObject:@{KCitys_sectionTitle:cityModel[@"firstLetter"],KCitys_regions:cityModel[@"regionModel"]}];
        }
    }
//    NSLog(@"citysArr==%@",self.citysArr);
//    [MyTools writeToFile:self.citysArr];
//    NSArray *ssssss=[MyTools readCityAddress];
}

@end
