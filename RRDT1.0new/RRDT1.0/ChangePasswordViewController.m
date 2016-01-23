//
//  ChangePasswordViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/23.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "CoreTFManagerVC.h"

#import "CoreStatusBtn.h"

#import "AppDelegate.h"

#import "LoginViewController.h"

#import "AgainLoginViewController.h"

@interface ChangePasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


@property (nonatomic,strong)UITableView  *mytable;
@property (nonatomic,strong)UIScrollView *myscroll;
@property (nonatomic,strong)UITextField  *txtoldpw;
@property (nonatomic,strong)UITextField  *txtnewpw;
@property (nonatomic,strong)UITextField  *txtnewpwen;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    
    self.title = @"修改密码";
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:_txtoldpw     inputView:_myscroll name:@"旧密码" insetBottom:0];
        TFModel *tfm2=[TFModel modelWithTextFiled:_txtnewpw     inputView:_myscroll name:@"新密码" insetBottom:0];
        TFModel *tfm3=[TFModel modelWithTextFiled:_txtnewpwen   inputView:_myscroll name:@"确认新密码" insetBottom:0];
        return @[tfm1,tfm2,tfm3];
        
    }];
    

}
-(void)viewCreat{
    self.view.backgroundColor = UIColorFromRGB(0xe8e8e8);
    
    _user = [[User alloc] init];
    
    _mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mytable.scrollEnabled = NO;
    _mytable.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [self.view addSubview:_mytable];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    
    CoreStatusBtn *btn = [[CoreStatusBtn alloc] initWithFrame:CGRectMake(20 , 20, WIDTH - 40, HEIGHT/15)];
    btn.backgroundColorForNormal = UIColorFromRGB(0x00bcd5);
    btn.shutOffColorLoadingAnim = YES;
    btn.shutOffZoomAnim = YES;
    btn.status = CoreStatusBtnStatusNormal;
    btn.msg = @"正在提交";
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    _mytable.tableFooterView = footView;
//    [self.view addSubview:btn];
}
-(void)clickBtn:(CoreStatusBtn *)btn{
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]){
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        
        if (_txtoldpw.text.length < 6) {
            [self.view makeToast:@"旧密码至少6位" duration:1.0 position:CSToastPositionTop];
        }else{
            if (_txtnewpw.text.length < 6) {
                [self.view makeToast:@"密码至少6位" duration:1.0 position:CSToastPositionTop];
            }else{
                if (![_txtnewpw.text isEqualToString:_txtnewpwen.text]) {
                    [self.view makeToast:@"两次密码不一致" duration:1.0 position:CSToastPositionTop];
                }else{
                    
                    btn.status = CoreStatusBtnStatusProgress;
                    
                    NSDictionary *parameters = @{@"userId":_user.userId,
                                                 @"oldPwd":[MyMD5 md5:_txtoldpw.text],
                                                 @"newPwd":[MyMD5 md5:_txtnewpw.text]};
                    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
                    parameters=[HttpHelper  security:parameters];
                    
                    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_ChangePassword] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"JSON: %@", responseObject);
                        NSNumber *code = [responseObject objectForKey:@"code"];
                        int code_int = [code intValue];
                        if (code_int == 200) {
                            btn.status = CoreStatusBtnStatusSuccess;
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功,请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            [alert show];
                        }else {
                            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
                            btn.status = CoreStatusBtnStatusFalse;
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        btn.status = CoreStatusBtnStatusFalse;
                    }];
                    
                }
            }
        }
        
        
        
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [self backTo];
    NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
    [dd setObject:@"" forKey:@"myUser"];
    [dd synchronize];
    _user.isLogin = NO;
    
    
    AgainLoginViewController *againVC = [[AgainLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:againVC];
    [nav.navigationBar setBarTintColor:UIColorFromRGB(0x1F2226)];
    
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT/10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        _txtoldpw = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, WIDTH-40, HEIGHT/10)];
        _txtoldpw.textAlignment = NSTextAlignmentLeft;
        _txtoldpw.returnKeyType = UIReturnKeyDone;
        _txtoldpw.clearButtonMode = YES;
        _txtoldpw.secureTextEntry = YES;
        cell.accessoryView = _txtoldpw;
    }else if (indexPath.section == 1){
        _txtnewpw = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, WIDTH-40, HEIGHT/10)];
        _txtnewpw.textAlignment = NSTextAlignmentLeft;
        _txtnewpw.returnKeyType = UIReturnKeyDone;
        _txtnewpw.secureTextEntry = YES;
        _txtnewpw.clearButtonMode = YES;
        _txtnewpw.tag = 888888;
        cell.accessoryView = _txtnewpw;
    }else{
        _txtnewpwen = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, WIDTH-40, HEIGHT/10)];
        _txtnewpwen.textAlignment = NSTextAlignmentLeft;
        _txtnewpwen.returnKeyType = UIReturnKeyDone;
        _txtnewpwen.clearButtonMode = YES;
        _txtnewpwen.secureTextEntry = YES;
        cell.accessoryView = _txtnewpwen;
    }
    return cell;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击空白处 消失键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"1111");
    
    [self hideKeyBoard];
}
- (void)hideKeyBoard{
    [self resignKeyBoardInView:self.view];
}
- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
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
