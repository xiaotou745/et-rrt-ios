//
//  TabBarController.m
//  RRDT1.0
//
//  Created by riverman on 16/1/4.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "TabBarController.h"

#import "WaitTaskViewController.h"
#import "CurrentTaskViewController.h"
#import "MyCenterViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self controllers];
}

-(void)controllers{
    
    WaitTaskViewController *waitVC=[[WaitTaskViewController alloc]init];
    UINavigationController *waitNav=[[UINavigationController alloc]initWithRootViewController:waitVC];
    
    [waitNav.navigationBar setBarTintColor:UIColorFromRGB(0x1F2226)];
    [waitNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    waitNav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];//修改标题颜色
    waitNav.navigationBar.translucent = NO;
    
    CurrentTaskViewController *currentVC=[[CurrentTaskViewController alloc]init];
    UINavigationController *currentNav=[[UINavigationController alloc]initWithRootViewController:currentVC];
    [currentNav.navigationBar setBarTintColor:UIColorFromRGB(0x1F2226)];
    [currentNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    currentNav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];//修改标题颜色
    currentNav.navigationBar.translucent = NO;
    
    MyCenterViewController *centerVC=[[MyCenterViewController alloc]init];
    UINavigationController *centerNav=[[UINavigationController alloc]initWithRootViewController:centerVC];
    [centerNav.navigationBar setBarTintColor:UIColorFromRGB(0x1F2226)];
    [centerNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    centerNav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];//修改标题颜色
    centerNav.navigationBar.translucent = NO;
    
    self.viewControllers = [NSArray arrayWithObjects:waitNav,currentNav,centerNav,nil];
    self.tabBar.hidden=YES;
    self.selectedIndex = 0;
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
