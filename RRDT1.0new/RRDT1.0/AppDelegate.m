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
//#import "User.h"
//
//#import "TaskViewController.h"

#import "WaitTaskViewController.h"

#import "MyVersion.h"
#import "ETSUUID.h"
@interface AppDelegate ()<CoreStatusProtocol,UIAlertViewDelegate>
{
    MyVersion *myVersion;
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
    
        WaitTaskViewController *task = [[WaitTaskViewController alloc] init];
    
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
        [self.window makeKeyAndVisible];
    
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:task];
    
        [nav.navigationBar setBarTintColor:UIColorFromRGB(0x1F2226)];
    
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//        nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];//修改标题颜色
    

    
        nav.navigationBar.translucent = NO;
    
        self.window.rootViewController = nav;
    

    
    [CoreStatus beginNotiNetwork:self];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:myVersion.version]];
        }
    }else if (alertView.tag == 222){
        [self exitApplication];
    }
    
}
- (void)exitApplication {
    UIWindow *window = self.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
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
