//
//  TaskDetailViewController.m
//  RRDT1.0
//
//  Created by riverman on 15/12/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "TaskDetailViewController.h"

#import "DZNSegmentedControl.h"

#import "UIScrollView+DZNSegmentedControl.h"
#import "CoreStatusBtn.h"

#import "WaitingView.h"
#import "PassingView.h"
#import "RefuseView.h"
#import "CheckProgressViewController.h"

#import "NewTaskContentViewController.h"

#import "CurrentTaskViewController.h"
#import "PostContractViewController.h"


#define kBakgroundColor     [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define kTintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define kHairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:100/255.0 alpha:1.0]
@interface TaskDetailViewController ()<UIScrollViewDelegate,DZNSegmentedControlDelegate>

{
    
    WaitingView *waitView;
    PassingView *passingView;
    RefuseView *refuseView;
    
}
@property (nonatomic,strong) UIScrollView *myScroll;

@property (nonatomic,strong) DZNSegmentedControl *mySegment;
@property (nonatomic,strong) CoreStatusBtn      *postBtn;

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
  
    if(_fromPCenterVC)    self.title = @"资料审核详情";
    [_myScroll setContentOffset:CGPointMake(WIDTH * _contentOfSet_index, 0) animated:NO];//设置scrollView滚动到某个位置，是否有动画效果
    _mySegment.selectedSegmentIndex = _contentOfSet_index;

    
    // Do any additional setup after loading the view.
}
- (void)viewCreat{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change_BadgeValue:) name:TaskDetailVC_BadgeValue object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toCheckProVC:) name:gotoCheckProgressVC object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:@"myselect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passAgain:) name:@"passAgain" object:nil];
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
    
    
    waitView = [[WaitingView alloc] init];
    waitView.taskId=_task.taskId;
    if (_fromPCenterVC)waitView.taskId=@"0";
    [_myScroll addSubview:waitView];
    
    passingView = [[PassingView alloc] init];
    passingView.taskId=_task.taskId;
    if (_fromPCenterVC)passingView.taskId=@"0";
    [_myScroll addSubview:passingView];
    
    refuseView = [[RefuseView alloc] init];
    refuseView.taskId=_task.taskId;
    if (_fromPCenterVC)refuseView.taskId=@"0";
    [_myScroll addSubview:refuseView];
    
    
    // 个人中心进来 或 过期任务  不显示提交资料按钮
    if (!_fromPCenterVC&&!_overTime) {
        _myScroll.frame= CGRectMake(0, 40, WIDTH, HEIGHT - 64 - 40-HEIGHT/15 - 20);

        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 64 - (HEIGHT/15 + 20), WIDTH, HEIGHT/15 + 20)];
        footView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        _postBtn = [[CoreStatusBtn alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, HEIGHT/15)];
        _postBtn.layer.cornerRadius = 4;
        _postBtn.layer.masksToBounds = YES;
        [_postBtn setTitle:@"提交资料" forState:UIControlStateNormal];
        [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _postBtn.backgroundColorForNormal = UIColorFromRGB(0x00bcd5);
        _postBtn.shutOffColorLoadingAnim = YES;
        _postBtn.shutOffZoomAnim = YES;
        _postBtn.status = CoreStatusBtnStatusNormal;
        //    _postBtn.msg = @"正在提交";
        [footView addSubview:_postBtn];
        [self.view addSubview:footView];
        [_postBtn addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)receive:(NSNotification *)note{
    NSLog(@"收到通知");
    
    NewTaskContentViewController *newVC =[[NewTaskContentViewController alloc] init];
    newVC.task = note.object;
    newVC.type = [[note.userInfo objectForKey:@"type"] integerValue];
    [self.navigationController pushViewController:newVC animated:YES];
    NSLog(@"%@",note.object);
}
- (void)passAgain:(NSNotification *)note{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CurrentNotification" object:nil userInfo:nil];
    //    CurrentTaskViewController *current = [[CurrentTaskViewController alloc] init];
    //    [self.navigationController pushViewController:current animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:waitView animated:YES];
    waitView.nextId = 0;
    [waitView post];
    [MBProgressHUD showHUDAddedTo:passingView animated:YES];
    passingView.nextId = 0;
    [passingView post];
    [MBProgressHUD showHUDAddedTo:refuseView animated:YES];
    refuseView.nextId = 0;
    [refuseView post];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"myselect" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passAgain" object:nil];
    
}

-(void)toCheckProVC:(NSNotification *)not{

    CheckProgressViewController *vc=[[CheckProgressViewController alloc]initWithNibName:@"CheckProgressViewController" bundle:nil];
    vc.model=not.object;
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)postBtnClick{
    
    PostContractViewController *post = [[PostContractViewController alloc] init];
    post.taskId = _task.taskId;
    post.taskDatumId=@"";
    post.tag = 111;
    post.onlyType = 999;
    [post postGetMyTask];
    [self.navigationController pushViewController:post animated:YES];
    
}
-(void)change_BadgeValue:(NSNotification *)note{
    NSLog(@"改变通知");
    NSLog(@">?>>>>%@",note.userInfo);
    [self.mySegment setItems:
     @[[NSString stringWithFormat:@"审核中(%@)",[note.userInfo objectForKey:@"waitTotal"]],
       [NSString stringWithFormat:@"已通过(%@)",[note.userInfo objectForKey:@"passTotal"]],
       [NSString stringWithFormat:@"未通过(%@)",[note.userInfo objectForKey:@"refuseTotal"]]]];
}

- (void)backBarButtonPressed{
    if (_navBackToHomeVC)    [self.navigationController popToRootViewControllerAnimated:YES];
    else [self.navigationController popViewControllerAnimated:YES];
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
