//
//  AppDelegate.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/18.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "AppDelegate.h"

//#import "LoginViewController.h"
//
#import "User.h"
//
//#import "TaskViewController.h"

#import "WaitTaskViewController.h"

#import "MyVersion.h"
#import "ETSUUID.h"
@interface AppDelegate ()<CoreStatusProtocol>
{
    MyVersion *myVersion;
    User *_user;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [ETSUUID storeUniqueDeviceIDToKeychain];

    NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [dd objectForKey:@"myUser"];
    
    if (data.length!=0) {
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
        [self.window makeKeyAndVisible];
    [self setRootViewControllerWithChildVC];
    [self getmsgCount];
    [CoreStatus beginNotiNetwork:self];
    
    return YES;
}
#pragma  mark 设置 childTabBarVC
-(void)setRootViewControllerWithChildVC
{
    self.tabBarController = [[TabBarController  alloc] init];
    self.window.rootViewController = self.tabBarController;

    // 底部导航栏
    _customTabBar = [[TabBarView alloc] initWithFrame:CGRectMake(0, DEF_SCEEN_HEIGHT-IOS_TAB_BAR_HEIGHT, DEF_SCEEN_WIDTH, IOS_TAB_BAR_HEIGHT)];
    _customTabBar.tag = 888;
    //_customTabBar.backgroundColor=[UIColor orangeColor];
    _customTabBar.delegate=self;
    [self.window addSubview:_customTabBar];
    
}
-(void)tabBarView:(TabBarView *)tabBarView didSelectAtIndex:(int)index
{
    self.tabBarController.selectedIndex=index;
}

-(void)getmsgCount{
    
    _user=[[User alloc]init];
    if (!_user.isLogin) {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{@"userId": _user.userId};
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_getmymsgcount] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
//            [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
           int  dataCount=[responseObject[@"data"]intValue];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:notify_newMessage object:@(dataCount)];
            
            if (dataCount) [_customTabBar showMessageIcon];
            else [_customTabBar hiddenMessageIcon];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
  
    }];
    
}

- (void)coreNetworkChangeNoti:(NSNotification *)noti{
    
    NSString * statusString = [CoreStatus currentNetWorkStatusString];
    
    NSLog(@"%@\n\n\n\n=========================\n\n\n\n%@",noti,statusString);
    
    if ([statusString isEqualToString:@"无网络"]) {
        [self.window makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }
}
- (void)dealloc{
    
    [CoreStatus endNotiNetwork:self];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
