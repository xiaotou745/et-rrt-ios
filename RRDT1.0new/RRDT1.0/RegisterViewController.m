//
//  RegisterViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/18.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "RegisterViewController.h"

#import "CoreTFManagerVC.h"

#import "CoreStatusBtn.h"

#import "CoreCountBtn.h"

#import "AppDelegate.h"

#import "AboutViewController.h"

#import "KLSwitch.h"

@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CoreCountBtn *countBtn;
}

@property (nonatomic,strong)UIScrollView *myscroll;

@property (nonatomic,strong)UITextField *txtphone;

@property (nonatomic,strong)UITextField *txtVerifyCode;

@property (nonatomic,strong)UITextField *txtPassword;

@property (nonatomic,strong)UITextField *linkPhone;


@property (nonatomic,strong)CoreStatusBtn *joinBtn;

@property (nonatomic,strong)UITableView *mytable;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    
}
#pragma mark 注册键盘
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:_txtphone inputView:_myscroll name:nil insetBottom:0];
        
        TFModel *tfm2=[TFModel modelWithTextFiled:_txtVerifyCode inputView:_myscroll name:nil insetBottom:0];
        
        TFModel *tfm3=[TFModel modelWithTextFiled:_txtPassword inputView:_myscroll name:nil insetBottom:30];
        
        TFModel *tfm4=[TFModel modelWithTextFiled:_linkPhone inputView:_myscroll name:nil insetBottom:0];
        
        
        return @[tfm1,tfm2,tfm3,tfm4];
        
    }];
}
#pragma mark 视图创建
- (void)viewCreat{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";

    _mytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.backgroundColor = UIColorFromRGB(0xe8e8e8);
    _mytable.scrollEnabled = NO;
    [self.view addSubview:_mytable];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"0xffffff" alpha:0.8]];
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/3)];
    _mytable.tableFooterView = footview;
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = @"注册即视为同意";
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.textAlignment = NSTextAlignmentRight;
    lab1.textColor = [UIColor grayColor];
    [footview addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.text = @"《人人推用户协议》";
    lab2.font = [UIFont systemFontOfSize:14];
    lab2.textAlignment = NSTextAlignmentLeft;
    lab2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labClick:)];
    lab2.textColor = UIColorFromRGB(0x00bcd5);
    [lab2 addGestureRecognizer:tap];
    [footview addSubview:lab2];
    
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footview).offset(20);
        make.height.equalTo(@20);
        make.right.mas_equalTo(lab2.mas_left);
    }];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footview).offset(20);
        make.height.equalTo(@20);
        make.left.mas_equalTo(lab1.mas_right);
        make.right.equalTo(self.view).with.offset(-40);
    }];
    
    
    
    
    
    _joinBtn = [CoreStatusBtn buttonWithType:UIButtonTypeCustom];
    _joinBtn.layer.cornerRadius = 4;
    _joinBtn.layer.masksToBounds = YES;
    _joinBtn.backgroundColorForNormal = UIColorFromRGB(0x00bcd5);
    _joinBtn.shutOffColorLoadingAnim = YES;
    _joinBtn.shutOffZoomAnim = YES;
    _joinBtn.status = CoreStatusBtnStatusNormal;
    _joinBtn.msg = @"正在注册";
    [_joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_joinBtn setTitle:@"确认" forState:UIControlStateNormal];
    [footview addSubview:_joinBtn];
    [_joinBtn addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
    [_joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(10);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(HEIGHT/15);
    }];
}
#pragma mark 用户协议跳转
- (void)labClick:(UITapGestureRecognizer *)tap{
    AboutViewController *about = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:about animated:YES];
}
- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 对输入长度限制
- (void)changeVerifyCodeValue{
    int MaxLen = 6;
    NSString *szText = [_txtVerifyCode text];
    if ([szText length]> MaxLen)
    {
        _txtVerifyCode.text = [szText substringToIndex:MaxLen];
    }
}
- (void)changePhoneNumValue{
    int MaxLen = 11;
    NSString *szText = [_txtphone text];
    if ([szText length]> MaxLen)
    {
        _txtphone.text = [szText substringToIndex:MaxLen];
    }
}
#pragma mark table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT/12;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        _txtphone = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 110, HEIGHT/12)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT/12, HEIGHT/12)];
        UIImageView *img_user = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_phone"]];
        img_user.frame = CGRectMake(HEIGHT/48, HEIGHT/48, HEIGHT/24, HEIGHT/24);
        [view addSubview:img_user];
        _txtphone.clearButtonMode = YES;
        _txtphone.leftViewMode = UITextFieldViewModeAlways;
        _txtphone.leftView = view;
        _txtphone.placeholder = @"请输入手机号";
        
        
        countBtn = [[CoreCountBtn alloc]initWithFrame:CGRectMake(WIDTH - 110, 5, 100, HEIGHT/12 - 10)];
        countBtn.layer.masksToBounds = YES;
        countBtn.layer.cornerRadius = 2;
        countBtn.layer.borderWidth = 1;
        countBtn.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
        countBtn.fontPoint = 15;
        countBtn.status=CoreCountBtnStatusNormal;
        [countBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [countBtn setTitleColor:UIColorFromRGB(0x00bcd5) forState:UIControlStateNormal];
        countBtn.backgroundColorForNormal=UIColorFromRGB(0xfafafa);
        countBtn.countNum=60;
        
        
        [countBtn addTarget:self action:@selector(getVerify) forControlEvents:UIControlEventTouchUpInside];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            countBtn.status=CoreCountBtnStatusNormal;
        });
        [cell addSubview:countBtn];

        [cell.contentView addSubview:_txtphone];
    }else if (indexPath.row == 1){
        _txtVerifyCode = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/12)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT/12, HEIGHT/12)];
        UIImageView *img_user = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_verifycode"]];
        img_user.frame = CGRectMake(HEIGHT/48, HEIGHT/48, HEIGHT/24, HEIGHT/24);
        [view addSubview:img_user];
        _txtVerifyCode.clearButtonMode = YES;
        _txtVerifyCode.leftViewMode = UITextFieldViewModeAlways;
        _txtVerifyCode.leftView = view;
        _txtVerifyCode.placeholder = @"请输入验证码";
        [cell.contentView addSubview:_txtVerifyCode];
    }else if (indexPath.row == 2){
        _txtPassword = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 60, HEIGHT/12)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT/12, HEIGHT/12)];
        UIImageView *img_user = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
        img_user.frame = CGRectMake(HEIGHT/48, HEIGHT/48, HEIGHT/24, HEIGHT/24);
        [view addSubview:img_user];
        _txtPassword.clearButtonMode = YES;
        _txtPassword.secureTextEntry = YES;
        _txtPassword.leftViewMode = UITextFieldViewModeAlways;
        _txtPassword.leftView = view;
        _txtPassword.placeholder = @"请输入密码";
        _txtPassword.rightViewMode = UITextFieldViewModeAlways;
        
        KLSwitch *klswitch = [[KLSwitch alloc] initWithFrame:CGRectMake(WIDTH - 60, HEIGHT/48, 50, HEIGHT/24)];
        [cell.contentView addSubview:klswitch];
        klswitch.didChangeHandler = ^(BOOL isOn) {
            if (isOn) {
                _txtPassword.secureTextEntry = NO;
            }else{
                _txtPassword.secureTextEntry = YES;
            }
        };
        [cell.contentView addSubview:_txtPassword];
    }else{
        _linkPhone = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/12)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT/12, HEIGHT/12)];
        UIImageView *img_user = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_phone"]];
        img_user.frame = CGRectMake(HEIGHT/48, HEIGHT/48, HEIGHT/24, HEIGHT/24);
        [view addSubview:img_user];
        _linkPhone.clearButtonMode = YES;
        _linkPhone.leftViewMode = UITextFieldViewModeAlways;
        _linkPhone.leftView = view;
        _linkPhone.placeholder = @"请输入推荐人手机号（非必填）";
        [cell.contentView addSubview:_linkPhone];
    }
    return cell;
}
#pragma mark 注册
- (void)joinClick{

    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        if (_txtVerifyCode.text.length != 6) {
            [self.view makeToast:@"请输入正确的验证码" duration:1.0 position:CSToastPositionTop];
        }else{
            if (_txtPassword.text.length < 6) {
                [self.view makeToast:@"密码至少6位" duration:1.0 position:CSToastPositionTop];
            }else{
                    _joinBtn.status = CoreStatusBtnStatusProgress;
                
                
                    NSDictionary *parameters = @{@"phoneNo": _txtphone.text,
                                                 @"passWord":[MyMD5 md5:_txtPassword.text],
                                                 @"verifyCode":_txtVerifyCode.text,
                                                 @"recommendPhone":_linkPhone.text=nil?@"":_linkPhone.text,
                                                 @"operSystem":@"ios"
                                                 };
                AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
                parameters=[parameters security];
                
                    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_UserRegister] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"JSON: %@", responseObject);
                        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
                        if (code == 200) {
                            NSLog(@"success");
                            
                            _joinBtn.status = CoreStatusBtnStatusSuccess;
                            
//                            TaskViewController *task = [[TaskViewController alloc] init];
                            User *user = [[User alloc] init];
                            user.userId = [[responseObject objectForKey:@"data"] objectForKey:@"userId"];
                            user.userPhoneNo = _txtphone.text;
                            user.isLogin = YES;
                            
                            
                            user.userName = [[responseObject objectForKey:@"data"] objectForKey:@"clienterName"];
                            
                            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                            NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
                            [dd setObject:userData forKey:@"myUser"];
                            [dd synchronize];
                            
                            //注册成功 发出通知 请求个人信息
                            [[NSNotificationCenter defaultCenter] postNotificationName:loginSuccess_getUserInfo object:nil];
                            if (_againType == 999) {
                                [self dismissViewControllerAnimated:YES completion:^{
                                    
                                }];
                            }else{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                            
                        }else{
                            _joinBtn.status = CoreStatusBtnStatusFalse;
                            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                        _joinBtn.status = CoreStatusBtnStatusFalse;
                    }];
                    
                    }
                }
            }
    
}

#pragma mark 获取验证码
- (void)getVerifyCode{
    
    NSDictionary *dataDic = @{@"phoneNo":_txtphone.text,
                              @"sType"  :@"1"};

    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
            dataDic=[dataDic security];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_VerifyCode] parameters:dataDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"]  intValue];
        if (code == 200) {
            NSLog(@"验证码已经发送");
            countBtn.status=CoreCountBtnStatusCounting;
        }else{
            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error>>>>%@",error);
        NSLog(@">%@",operation.responseString);
    }];
    
}
- (void)getVerify{
    
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        if (_txtphone.text.length != 11 && ![_txtphone.text hasPrefix:@"1"]) {
        
        [self.view makeToast:@"请输入正确的手机号" duration:1.0 position:CSToastPositionTop];
        
        }else{
        
            [self getVerifyCode];

        countBtn.status=CoreCountBtnStatusCounting;
        }
    }
    
}
#pragma mark 移除键盘
- (void)viewDidDisappear:(BOOL)animated{
    
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

@end
