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
#import "WXApi.h"
@interface AppDelegate ()<CoreStatusProtocol,WXApiDelegate,WeiboSDKDelegate>
{
    MyVersion *myVersion;
    User *_user;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [ETSUUID storeUniqueDeviceIDToKeychain];

    [UMSocialData setAppKey:kUMSocialAppKey];
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    [UMSocialWechatHandler setWXAppId:@"wx372230899f9b558e" appSecret:@"06b4552fd896c6616d41d2c2d1cd168f" url:nil];
    
    [UMSocialQQHandler setQQWithAppId:@"1105050369" appKey:@"9TPZNZpzwOKkf6aY" url:@"http://www.umeng.com/social"];
    //[UMSocialQQHandler setSupportWebView:YES];

    //微博原生第三方登陆
//    
//    [WeiboSDK enableDebugMode:YES];
//    
//    [WeiboSDK registerApp:@"2925603791"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2925603791" secret:@"dbbda94f1cc82d52ec10c597209af946" RedirectURL:@"http://www.umeng.com/social"];
    
    //本地 缓存地理位置为 北京
    if (DEF_PERSISTENT_GET_OBJECT(kAppFirstDriving)==nil) {
        DEF_PERSISTENT_SET_OBJECT(@"kAppFirstDriving", kAppFirstDriving);
        DEF_PERSISTENT_SET_OBJECT((@{@"name":@"北京市",@"code":@(110100)}), kLocationCityInfo);
//        DEF_PERSISTENT_SET_OBJECT((@{@"name":@"上海市",@"code":@(310100)}), kLocationCityInfo);
//        DEF_PERSISTENT_SET_OBJECT((@{@"name":@"天津市",@"code":@(120100)}), kLocationCityInfo);


    }
    
    
    NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [dd objectForKey:@"myUser"];
    
    if (data.length!=0) {
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
        [self.window makeKeyAndVisible];
    [self setRootVC_TabBarVC];
    [self getmsgCount];
    [CoreStatus beginNotiNetwork:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backWaitVC) name:notify_loginBackVC object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoGetMyInfo) name:loginSuccess_getUserInfo object:nil];
    
    return YES;
}

-(void)setRootVC_supplementVC{
    
    SupplementViewController *supp=[[SupplementViewController alloc]initWithNibName:@"SupplementViewController" bundle:nil];
    self.window.rootViewController = supp;
    
}

-(void)setRootVC_loginVC{
    
        _loginVC=[[LoginViewController alloc]init];
        self.window.rootViewController = self.loginVC;

}
-(void)goto_MyCenterVC{

    [self setRootVC_TabBarVC];
    UIButton *item=(UIButton *)[_customTabBar viewWithTag:DEF_TAB_ICON_TAG+2];
    [_customTabBar itemClick:item];
    [[NSNotificationCenter defaultCenter]postNotificationName:setInfoSuccess_gotoPersonInfoVC object:nil];
}
#pragma  mark 设置 TabBarVC
-(void)setRootVC_TabBarVC
{
    if (!self.tabBarController) {
        self.tabBarController = [[TabBarController  alloc] init];
    }
    self.window.rootViewController = self.tabBarController;

    // 底部导航栏
    if (!_customTabBar) {
        _customTabBar = [[TabBarView alloc] initWithFrame:CGRectMake(0, DEF_SCEEN_HEIGHT-IOS_TAB_BAR_HEIGHT, DEF_SCEEN_WIDTH, IOS_TAB_BAR_HEIGHT)];
     
    }
    _customTabBar.tag = 888;
    //_customTabBar.backgroundColor=[UIColor orangeColor];
    _customTabBar.delegate=self;
    [self.window addSubview:_customTabBar];

}
-(void)tabBarView:(TabBarView *)tabBarView didSelectAtIndex:(int)index
{
    self.tabBarController.selectedIndex=index;
}

-(void)backWaitVC{

    [self setRootVC_TabBarVC];
    UIButton *item=(UIButton *)[_customTabBar viewWithTag:DEF_TAB_ICON_TAG];
    [_customTabBar itemClick:item];

}

-(void)getmsgCount{
    
    _user=[[User alloc]init];
    if (!_user.isLogin) {
        return;
    }

    
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{@"userId": _user.userId};
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    parameters=[parameters security];
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
#pragma mark 获得用户信息
- (void)gotoGetMyInfo{
    
    _user=[[User alloc]init];
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{@"userId": _user.userId};
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    parameters=[parameters security];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_MyInmoney] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@">>>>>%@",operation);
        NSLog(@"JSON: %@", responseObject);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            
            _user.userName = [[responseObject objectForKey:@"data"] objectForKey:@"clienterName"];
            _user.userPhoneNo = [[responseObject objectForKey:@"data"] objectForKey:@"phoneNo"] ;
            
            _user.sex = [[[responseObject objectForKey:@"data"] objectForKey:@"sex"] integerValue];
            _user.age = [[[responseObject objectForKey:@"data"] objectForKey:@"age"] integerValue];
            _user.fullHeadImage = [[responseObject objectForKey:@"data"] objectForKey:@"fullHeadImage"];
            _user.headImage = [[responseObject objectForKey:@"data"] objectForKey:@"headImage"];
            _user.birthDay = [[responseObject objectForKey:@"data"] objectForKey:@"birthDay"];

            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:_user];
            NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
            [dd setObject:userData forKey:@"myUser"];
            [dd synchronize];
            
            if (_user.userName.length==0||_user.userName==nil||_user.birthDay.length==0||_user.birthDay==nil) {
                [self setRootVC_supplementVC];
            }
        }else{

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
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url

{
    
    //    return  [UMSocialSnsService handleOpenURL:url];
    
    NSLog(@"url host:%@", url.host);
    
    if ([[url scheme]caseInsensitiveCompare:@"wx372230899f9b558e"]==NSOrderedSame ) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([[url scheme]caseInsensitiveCompare:@"tencent1105050369"]==NSOrderedSame){
    
        return [TencentOAuth HandleOpenURL:url];
    }else if ([[url scheme]caseInsensitiveCompare:@"QQ41DDBB01"]==NSOrderedSame){
        
        return [TencentOAuth HandleOpenURL:url];
    }
    return [WeiboSDK handleOpenURL:url delegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
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
