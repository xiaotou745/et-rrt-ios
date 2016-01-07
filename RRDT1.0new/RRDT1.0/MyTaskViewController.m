//
//  MyTaskViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/28.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "MyTaskViewController.h"
#import "DZNSegmentedControl.h"

#import "UIScrollView+DZNSegmentedControl.h"

#import "PassView.h"

#import "LoseView.h"

#import "CancelView.h"

#import "NewTaskContentViewController.h"

#import "CurrentTaskViewController.h"

#define kBakgroundColor     [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define kTintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define kHairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:100/255.0 alpha:1.0]
@interface MyTaskViewController ()<UIScrollViewDelegate,DZNSegmentedControlDelegate>

{
    PassView *passView;
    
    LoseView *loseView;
    
    CancelView *cancelView;
    
    
}
@property (nonatomic,strong) UIScrollView *myScroll;

@property (nonatomic,strong) DZNSegmentedControl *mySegment;

@end

@implementation MyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    
    self.title = @"已完成";

    
    // Do any additional setup after loading the view.
}
- (void)viewCreat{

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
    
    _mySegment = [[DZNSegmentedControl alloc] initWithItems:@[@"审核通过",@"过期失效",@"已取消"]];
    _mySegment.showsCount = NO;
    _mySegment.selectedSegmentIndex = 0;
    _mySegment.bouncySelectionIndicator = NO;
    _mySegment.height = 40;
    [self.view addSubview:_mySegment];
    [_mySegment addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    
    
    passView = [[PassView alloc] init];
    [_myScroll addSubview:passView];
    
    loseView = [[LoseView alloc] init];
    [_myScroll addSubview:loseView];
    
    cancelView = [[CancelView alloc] init];
    [_myScroll addSubview:cancelView];
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

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:passView animated:YES];
    passView.nextId = 0;
    [passView post];
    [MBProgressHUD showHUDAddedTo:cancelView animated:YES];
    cancelView.nextId = 0;
    [cancelView post];
    [MBProgressHUD showHUDAddedTo:loseView animated:YES];
    loseView.nextId = 0;
    [loseView post];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"myselect" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passAgain" object:nil];
    
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
