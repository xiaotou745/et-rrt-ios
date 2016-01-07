//
//  SysemViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/23.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "SysemViewController.h"

#import "ChangePasswordViewController.h"

//#import "ForgetPasswordViewController.h"

//#import "AppDelegate.h"

#import "WaitTaskViewController.h"
//#import "LoginViewController.h"

@interface SysemViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *mytable;

@property (nonatomic,strong)UIButton    *btn;

@property (nonatomic,strong)NSArray     *titileArr;

@property (nonatomic,strong)MBProgressHUD *HUD;

@end

@implementation SysemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
}

- (void)viewCreat{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.title = @"更多";
    
//    _titileArr = @[@"修改密码",@"当前版本",@"清除缓存"];
    _titileArr = @[@"修改密码",@"当前版本"];

    _mytable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.backgroundColor = UIColorFromRGB(0xe8e8e8);
    
    [self.view addSubview:_mytable];
    
    
    [_mytable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(-0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(-0);
    }];
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(20, 20, WIDTH-40, 40);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn setBackgroundColor:UIColorFromRGB(0x00bcd5)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [footView addSubview:btn];
    
    _mytable.tableFooterView = footView;
}
- (void)btnClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@">>>>>%zi",buttonIndex);
    if (buttonIndex == 1) {
        
        _user = [[User alloc] init];
        _user.isLogin = NO;
        _user.userId=@"";
        _user.userPhoneNo=@"";
        _user.fullHeadImage=@"";
        _user.userName=@"";
        _user.headImage=@"";
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:_user];
        NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
        [dd setObject:userData forKey:@"myUser"];
        [dd synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titileArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT/10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenifier];
        cell.backgroundColor = UIColorFromRGB(0xf9f9f9);
    }

    cell.textLabel.text = [_titileArr objectAtIndex:indexPath.section];
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    if (indexPath.section == 1) {
        NSString *currentVersion=[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text =[NSString stringWithFormat:@"V%@",currentVersion];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ChangePasswordViewController *change = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:change animated:YES];
    }else if (indexPath.section == 2){
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        [_HUD show:YES];
        
        [self.view addSubview:_HUD];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            
            NSLog(@"files :%lu",(unsigned long)[files count]);
            
            for (NSString *p in files) {
                
                NSError *error;
                
                NSString *path = [cachPath stringByAppendingPathComponent:p];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    
                }
                
            }
            [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
        });

    }
}
-(void)clearCacheSuccess

{
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    
    _HUD.mode = MBProgressHUDModeCustomView;
    
    _HUD.labelText = @"清理成功";
    
    [_HUD hide:YES afterDelay:1.0f];
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"清理成功");
    
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
