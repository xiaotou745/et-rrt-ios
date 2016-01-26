//
//  AppDelegate.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/18.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
#import "TabBarView.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,TabBarViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabBarController *tabBarController;
@property (strong, nonatomic) TabBarView *customTabBar;
@property (strong, nonatomic) LoginViewController *loginVC;

#pragma  mark 设置 TabBarVC
-(void)setRootVC_TabBarVC;
-(void)setRootVC_loginVC;

-(void)getmsgCount;
@end

