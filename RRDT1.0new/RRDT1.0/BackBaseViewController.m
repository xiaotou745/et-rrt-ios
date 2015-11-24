//
//  BackBaseViewController.m
//  2015-01-10-UINavigation封装Demo
//
//  Created by TangJR on 15/1/10.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import "BackBaseViewController.h"

@interface BackBaseViewController ()

@end

@implementation BackBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化一个返回按钮
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    // 为返回按钮设置图片样式
//    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    // 设置返回按钮触发的事件
//    [button addTarget:self action:@selector(backBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // 初始化一个BarButtonItem，并将其设置为返回的按钮的样式
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed)];
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    // 将BarButtonItem添加到LeftBarButtonItem上
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

#pragma mark - BarButton Pressed

/**
 *  返回按钮触发的事件
 *
 *  @param sender 返回按钮
 */
- (void)backBarButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
