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
#import "SupplementViewController.h"
#import "MyCenterViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,TabBarViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabBarController *tabBarController;
@property (strong, nonatomic) TabBarView *customTabBar;
@property (strong, nonatomic) LoginViewController *loginVC;

@property(strong,nonatomic)NSNumber *currentCityCode;

#pragma  mark 设置 TabBarVC
-(void)setRootVC_TabBarVC;
-(void)setRootVC_loginVC;
-(void)goto_MyCenterVC;


-(void)getmsgCount;
@end

