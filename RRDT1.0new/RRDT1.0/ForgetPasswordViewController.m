//
//  ForgetPasswordViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/24.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "ForgetPasswordViewController.h"

#import "CoreTFManagerVC.h"

#import "CoreCountBtn.h"

#import "CoreStatusBtn.h"

@interface ForgetPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


@property (nonatomic,strong) UITableView  *mytable;
@property (nonatomic,strong) UIScrollView *myscroll;
@property (nonatomic,strong) UITextField  *txtphoneno;
@property (nonatomic,strong) UITextField  *txtsmsid;
@property (nonatomic,strong) UITextField  *txtpassworden;
@property (nonatomic,strong) UITextField  *txtpassword;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    [self viewCreat];
}
-(void)viewCreat{
    self.view.backgroundColor = UIColorFromRGB(0xe8e8e8);
    
    _mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mytable.scrollEnabled = NO;
    _mytable.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [self.view addSubview:_mytable];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    CoreStatusBtn *btn = [[CoreStatusBtn alloc] initWithFrame:CGRectMake(20, 20, WIDTH-40, HEIGHT/15)];
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
//    [self.view addSubview:btn];
    [footView addSubview:btn];
    _mytable.tableFooterView = footView;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
}
- (void)back{
//    if (_tag == 1) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }else if (_tag == 2){
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickBtn:(CoreStatusBtn *)btn{
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]){
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        if (_txtphoneno.text.length != 11 && ![_txtphoneno.text hasPrefix:@"1"]) {
            [self.view makeToast:@"请输入正确的手机号" duration:1.0 position:CSToastPositionTop];
        }else{
            if (_txtsmsid.text.length != 6) {
                [self.view makeToast:@"请输入正确的验证码" duration:1.0 position:CSToastPositionTop];
            }else{
                if (_txtpassword.text.length < 6) {
                    [self.view makeToast:@"密码至少6位" duration:1.0 position:CSToastPositionTop];
                }else{
                    if (![_txtpassword.text isEqualToString:_txtpassworden.text]) {
                        [self.view makeToast:@"两次密码不一致" duration:1.0 position:CSToastPositionTop];
                    }else{
                        btn.status = CoreStatusBtnStatusProgress;
                        
                        NSDictionary *parameters = @{@"phoneNo":_txtphoneno.text,
                                                     @"passWord":[MyMD5 md5:_txtpassword.text],
                                                     @"verifyCode":_txtsmsid.text};
                        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
                        parameters=[parameters security];
                        
                        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_ForgetPassword] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"JSON: %@", responseObject);
                            NSNumber *code = [responseObject objectForKey:@"code"];
                            int code_int = [code intValue];
                            if (code_int == 200) {
                                btn.status = CoreStatusBtnStatusSuccess;
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
        
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        TFModel *tfm0=[TFModel modelWithTextFiled:_txtphoneno    inputView:_myscroll name:@"手机号码" insetBottom:0];
        TFModel *tfm1=[TFModel modelWithTextFiled:_txtsmsid      inputView:_myscroll name:@"输入验证码" insetBottom:0];
        TFModel *tfm2=[TFModel modelWithTextFiled:_txtpassword   inputView:_myscroll name:@"新密码" insetBottom:0];
        TFModel *tfm3=[TFModel modelWithTextFiled:_txtpassworden inputView:_myscroll name:@"确认新密码" insetBottom:0];
        return @[tfm0,tfm1,tfm2,tfm3];
        
    }];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT/10;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        _txtphoneno = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, WIDTH-40, HEIGHT/10)];
        _txtphoneno.clearButtonMode = YES;
        [cell.contentView addSubview:_txtphoneno];
        
        _txtphoneno.keyboardType = UIKeyboardTypeNumberPad;
        CoreCountBtn *countBtn = [[CoreCountBtn alloc]initWithFrame:CGRectMake(0, 5, 100, HEIGHT/10 - 10)];
        countBtn.layer.masksToBounds = YES;
        countBtn.layer.cornerRadius = 2;
        countBtn.status=CoreCountBtnStatusNormal;
        [countBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [countBtn setTitleColor:UIColorFromRGB(0x00bcd5) forState:UIControlStateNormal];
        countBtn.backgroundColorForNormal=[UIColor whiteColor];
        
        countBtn.countNum=60;
        
        [countBtn addTarget:self action:@selector(getVerify:) forControlEvents:UIControlEventTouchUpInside];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            countBtn.status=CoreCountBtnStatusNormal;
        });
        
        cell.accessoryView = countBtn;
    }else if (indexPath.section == 1) {
        _txtsmsid = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, WIDTH-40, HEIGHT/10)];
        _txtsmsid.clearButtonMode = YES;
        _txtsmsid.keyboardType = UIKeyboardTypeNumberPad;

        [cell.contentView addSubview:_txtsmsid];
    }else if (indexPath.section == 2){
        _txtpassword = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, WIDTH-40, HEIGHT/10)];
        _txtpassword.clearButtonMode = YES;
        _txtpassword.secureTextEntry = YES;
        _txtpassword.tag = 888888;
        [cell.contentView addSubview:_txtpassword];
    }else if (indexPath.section == 3){
        _txtpassworden = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, WIDTH-40, HEIGHT/10)];
        _txtpassworden.clearButtonMode = YES;
        _txtpassworden.secureTextEntry = YES;
        [cell.contentView addSubview:_txtpassworden];
    }
    return cell;
}
#pragma mark 获取验证码
- (void)getVerifyCode{
    
        NSDictionary *parameters = @{@"phoneNo":_txtphoneno.text,
                                     @"sType"  :@"3"};
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    parameters=[parameters security];
    
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_VerifyCode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSInteger code = [[responseObject objectForKey:@"code"]  intValue];
            if (code == 200) {
                NSLog(@"验证码已发送");
            }else{
                [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    
    
}
- (void)getVerify:(CoreCountBtn *)countBtn{
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]){
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        if (_txtphoneno.text.length != 11 && ![_txtphoneno.text hasPrefix:@"1"]) {
            [self.view makeToast:@"请输入正确的手机号" duration:1.0 position:CSToastPositionTop];
        }else{
            
    [self getVerifyCode];
    
    countBtn.status=CoreCountBtnStatusCounting;
        }
    }
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
