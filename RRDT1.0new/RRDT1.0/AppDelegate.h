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
@interface AppDelegate : UIResponder <UIApplicationDelegate,TabBarViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabBarController *tabBarController;
@property (strong, nonatomic) TabBarView *customTabBar;

-(void)getmsgCount;
@end

