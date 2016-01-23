//
//  TaskDListViewController.m
//  RRDT1.0
//
//  Created by riverman on 16/1/19.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "TaskDListViewController.h"
#import "TaskDetailViewController.h"
#import "DZNSegmentedControl.h"

#import "UIScrollView+DZNSegmentedControl.h"
#import "CoreStatusBtn.h"

#import "TDListCheckingView.h"
#import "TDListPassView.h"
#import "TDListUnPassView.h"
#import "TaskDetailModel.h"
#define kBakgroundColor     [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define kTintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define kHairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:100/255.0 alpha:1.0]
@interface TaskDListViewController ()<UIScrollViewDelegate,DZNSegmentedControlDelegate>

{
    
    TDListCheckingView  *checkingView;
    TDListPassView      *passView;
    TDListUnPassView    *unPassView;
    
}
@property (nonatomic,strong) UIScrollView *myScroll;

@property (nonatomic,strong) DZNSegmentedControl *mySegment;

@end

@implementation TaskDListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    
       self.title = @"资料审核详情";
    
    // Do any additional setup after loading the view.
}
- (void)viewCreat{
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePage_BadgeValue:) name:TaskDListVC_BadgeValue object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toTaskDetail:) name:TaskDListVC_toTaskDetail object:nil];//

    
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor whiteColor]];
    [[DZNSegmentedControl appearance] setTintColor:UIColorFromRGB(0x09a3b8)];
    [[DZNSegmentedControl appearance] setHairlineColor:[UIColor clearColor]];
    
    [[DZNSegmentedControl appearance] setFont:[UIFont systemFontOfSize:15]];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:1.0];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
    
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:18.0]}];
    
    
    _myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 64 - 40)];
    _myScroll.delegate = self;
    _myScroll.pagingEnabled = YES;
    _myScroll.contentSize = CGSizeMake(WIDTH*3, 0);
    _myScroll.backgroundColor = UIColorFromRGB(0xf9f9f9);
    _myScroll.showsHorizontalScrollIndicator = NO;
    _myScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myScroll];
    
    _mySegment = [[DZNSegmentedControl alloc] initWithItems:@[@"审核中(0)",@"已通过(0)",@"未通过(0)"]];
    _mySegment.showsCount = NO;
    _mySegment.selectedSegmentIndex = 0;
    _mySegment.bouncySelectionIndicator = NO;
    _mySegment.height = 40;
    [self.view addSubview:_mySegment];
    [_mySegment addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    
    
    checkingView = [[TDListCheckingView alloc] init];
    [_myScroll addSubview:checkingView];
    
    passView = [[TDListPassView alloc] init];
    [_myScroll addSubview:passView];
    
    unPassView = [[TDListUnPassView alloc] init];
    [_myScroll addSubview:unPassView];
    
    [MBProgressHUD showHUDAddedTo:checkingView animated:YES];
    checkingView.nextId = 0;
    [checkingView post];
    [MBProgressHUD showHUDAddedTo:passView animated:YES];
    passView.nextId = 0;
    [passView post];
    [MBProgressHUD showHUDAddedTo:unPassView animated:YES];
    unPassView.nextId = 0;
    [unPassView post];
  
    
}
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


-(void)changePage_BadgeValue:(NSNotification *)note{
    NSLog(@"改变通知");
    NSLog(@">?>>>>%@",note.userInfo);
    [self.mySegment setItems:
     @[[NSString stringWithFormat:@"审核中(%@)",[note.userInfo objectForKey:@"waitTotal"]],
       [NSString stringWithFormat:@"已通过(%@)",[note.userInfo objectForKey:@"passTotal"]],
       [NSString stringWithFormat:@"未通过(%@)",[note.userInfo objectForKey:@"refuseTotal"]]]];
}

-(void)toTaskDetail:(NSNotification *)not{
    TaskDetailViewController *vc=[[TaskDetailViewController alloc]init];
    
    TaskDetailModel *detailModel=[[TaskDetailModel alloc]init];
    detailModel=not.object[@"task"];
    vc.taskId=detailModel.taskId;
    vc.title=@"审核详情列表";
    vc.fromPCenterVC=YES;
    
    vc.contentOfSet_index=[not.object[@"index"] integerValue];
    if (detailModel.taskStatus==3||detailModel.taskStatus==4)  vc.overTime=YES;
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
