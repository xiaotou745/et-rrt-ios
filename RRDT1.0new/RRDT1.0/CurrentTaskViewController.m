//
//  CurrentTaskViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/26.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "CurrentTaskViewController.h"

#import "DZNSegmentedControl.h"

#import "UIScrollView+DZNSegmentedControl.h"

#import "ReceivedView.h"

#import "CheckingTaskView.h"


#import "NewTaskContentViewController.h"

#import "PostContractViewController.h"

#import "RRDTBarViewController.h"
#import "TaskDetailViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#define kBakgroundColor     [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define kTintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define kHairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:100/255.0 alpha:1.0]

@interface CurrentTaskViewController ()<UIScrollViewDelegate,DZNSegmentedControlDelegate>

{
    ReceivedView *receivedView;
    
    CheckingTaskView *checkingView;
    
}
@property (nonatomic,strong) UIScrollView *myScroll;

@property (nonatomic,strong) DZNSegmentedControl *mySegment;

@end

@implementation CurrentTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    self.navigationItem.leftBarButtonItem=nil;
    self.title = @"我的任务";
    
    _user = [[User alloc] init];
    if (_user.isLogin)  [self getTaskList];
}
- (void)viewCreat{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProgressHUD) name:ReceivedView_showProgressHUD object:nil];//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideProgressHUD) name:ReceivedView_hideProgressHUD object:nil];//

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(todoShare:) name:ReceivedView_doShare object:nil];//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toTaskDetail:) name:ReceivedView_toTaskDetail object:nil];//

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:@"select" object:nil];//点击列表通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changeSelcct" object:nil];//数量改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againpost:) name:@"againPost" object:nil];//未通过再次提交通知
    
    
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor whiteColor]];
    [[DZNSegmentedControl appearance] setTintColor:UIColorFromRGB(0x09a3b8)];
    [[DZNSegmentedControl appearance] setHairlineColor:[UIColor clearColor]];
    
    [[DZNSegmentedControl appearance] setFont:[UIFont systemFontOfSize:15]];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:1.0];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.25];
    
    
    _myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, HEIGHT - 64 - 40)];
    _myScroll.delegate = self;
    _myScroll.pagingEnabled = YES;
    _myScroll.contentSize = CGSizeMake(WIDTH*2, 0);
    _myScroll.backgroundColor = UIColorFromRGB(0xf9f9f9);
    _myScroll.showsHorizontalScrollIndicator = NO;
    _myScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myScroll];
    
    _mySegment = [[DZNSegmentedControl alloc] initWithItems:@[@"进行中(0)",@"已过期(0)"]];
    _mySegment.showsCount = NO;
    _mySegment.selectedSegmentIndex = 0;
    _mySegment.bouncySelectionIndicator = NO;
    _mySegment.height = 40;
    [self.view addSubview:_mySegment];
    [_mySegment addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];

    
    
    receivedView = [[ReceivedView alloc] init];
    [_myScroll addSubview:receivedView];
    
    checkingView = [[CheckingTaskView alloc] init];
    [_myScroll addSubview:checkingView];
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)receive:(NSNotification *)note{
    NSLog(@"收到通知");
    
    NewTaskContentViewController *newVC =[[NewTaskContentViewController alloc] init];
    newVC.task = note.object;
//    newVC.type = [[note.userInfo objectForKey:@"type"] integerValue];
    newVC.type = 2;

    [self.navigationController pushViewController:newVC animated:YES];
    
    NSLog(@"%@",note.object);
}
- (void)change:(NSNotification *)note{
    NSLog(@"改变通知");
    NSLog(@">?>>>>%@",note.userInfo);
    [self.mySegment setItems:
  @[[NSString stringWithFormat:@"进行中(%@)",[note.userInfo objectForKey:@"passTotal"]],
    [NSString stringWithFormat:@"已过期(%@)",[note.userInfo objectForKey:@"refuseTotal"]]]];

}
- (void)againpost:(NSNotification *)note{
    NSLog(@"改变通知");
//    PostContractViewController *post = [[PostContractViewController alloc] init];
//    post.task = note.object;
//    post.taskId=post.task.taskId;
//    post.taskDatumId=@"";
//    post.tag = 111;
//    post.onlyType = 999;
//    [post postGetMyTask];
//
//    [self.navigationController pushViewController:post animated:YES];
    TaskDetailViewController *vc=[[TaskDetailViewController alloc]init];
    vc.task=note.object;
    vc.taskId=vc.task.taskId;
    vc.title=vc.task.taskName;
    vc.contentOfSet_index=0;
    if (vc.task.status==3||vc.task.status==4)  vc.overTime=YES;
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)todoShare:(NSNotification *)not{

    RRDTBarViewController *barVC=[[RRDTBarViewController alloc]initWithNibName:@"RRDTBarViewController" bundle:nil];
    
    Task *task=(Task *)not.object;
    barVC.downUrl=task.downUrl;
    barVC.scanTip=task.scanTip;
    barVC.reminder=task.reminder;
    
    [self.navigationController pushViewController:barVC animated:YES];
}
-(void)toTaskDetail:(NSNotification *)not{
    TaskDetailViewController *vc=[[TaskDetailViewController alloc]init];
    vc.task=not.object[@"task"];
    vc.taskId=vc.task.taskId;
    vc.title=vc.task.taskName;
    vc.contentOfSet_index=[not.object[@"index"] integerValue];
    if (vc.task.status==3||vc.task.status==4)  vc.overTime=YES;

    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"select" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeSelcct" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"againPost" object:nil];
}
- (void)backBarButtonPressed{
    NSLog(@"back to my selef");
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark 出现重新加载
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showTabBar];

}
-(void)viewDidAppear:(BOOL)animated{
    if (!_user.isLogin){
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
//        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
//        [app setRootVC_loginVC];
        return;
    }
}
- (void)getTaskList{
    receivedView.nextId = 0;
    [receivedView post];
    checkingView.nextId = 0;
    [checkingView post];
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
