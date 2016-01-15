//
//  BillDetailViewController.m
//  RRDT1.0
//
//  Created by riverman on 16/1/4.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "BillDetailViewController.h"
#import "DZNSegmentedControl.h"

#import "UIScrollView+DZNSegmentedControl.h"
#import "InComeView.h"
#import "ExpendView.h"
#import "SCBillDetailVC.h"

@interface BillDetailViewController ()<UIScrollViewDelegate,DZNSegmentedControlDelegate>

{
    InComeView *incomeView;
    
    ExpendView *expendView;
    
}
@property (nonatomic,strong) UIScrollView *myScroll;

@property (nonatomic,strong) DZNSegmentedControl *mySegment;
@end

@implementation BillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"资金明细";
    [self viewCreat];
    [self getTaskList];
}
- (void)viewCreat{
    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:@"select" object:nil];//点击列表通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changeSelcct" object:nil];//数量改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoBillDetailVC:) name:notify_selectBillDetailCell object:nil];//账单详情
    
    
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor whiteColor]];
    [[DZNSegmentedControl appearance] setTintColor:UIColorFromRGB(0x09a3b8)];
    [[DZNSegmentedControl appearance] setHairlineColor:[UIColor clearColor]];
    
    [[DZNSegmentedControl appearance] setFont:[UIFont systemFontOfSize:15]];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:1.0];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
    
    
    _myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 64 - 40)];
    _myScroll.delegate = self;
    _myScroll.pagingEnabled = YES;
    _myScroll.contentSize = CGSizeMake(WIDTH*2, 0);
    _myScroll.backgroundColor = UIColorFromRGB(0xf9f9f9);
    _myScroll.showsHorizontalScrollIndicator = NO;
    _myScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myScroll];
    
    _mySegment = [[DZNSegmentedControl alloc] initWithItems:@[@"收入",@"支出"]];
    _mySegment.showsCount = NO;
    _mySegment.selectedSegmentIndex = 0;
    _mySegment.bouncySelectionIndicator = NO;
    _mySegment.height = 40;
    [self.view addSubview:_mySegment];
    [_mySegment addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    
    
    
    incomeView = [[InComeView alloc] init];
    [_myScroll addSubview:incomeView];
    
    expendView = [[ExpendView alloc] init];
    [_myScroll addSubview:expendView];
    
}
# pragma mark 滑动点击监听
- (void)didChangeSegment:(DZNSegmentedControl *)control
{
    [_myScroll setContentOffset:CGPointMake(WIDTH * control.selectedSegmentIndex, 0) animated:YES];//设置scrollView滚动到某个位置，是否有动画效果
    NSLog(@">>>>>%zi",control.selectedSegmentIndex);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    NSLog(@">>>>>%zi",index);
    _mySegment.selectedSegmentIndex = index;
    
}
- (void)getTaskList{
    [MBProgressHUD showHUDAddedTo:incomeView animated:YES];
    incomeView.nextId = 0;
    [incomeView post];
    [MBProgressHUD showHUDAddedTo:expendView animated:YES];
    expendView.nextId = 0;
    [expendView post];
}
-(void)gotoBillDetailVC:(NSNotification *)notif{

    SCBillDetailVC *detailVC=[[SCBillDetailVC alloc]initWithNibName:@"SCBillDetailVC" bundle:nil];
    detailVC.model=notif.object[@"model"];
    detailVC.isInCome=[notif.object[@"isInComeCell"]boolValue];
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
