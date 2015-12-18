//
//  LoginViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/18.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "LoginViewController.h"

#import "CoreTFManagerVC.h"

#import "RegisterViewController.h"

#import "ForgetPasswordViewController.h"

#import "CoreStatusBtn.h"

#import "KLSwitch.h"
#import "ETSUUID.h"

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITextField         *txtUsername;

@property (nonatomic,strong)UITextField         *txtPsaaword;

@property (nonatomic,strong)UILabel             *labForget;

@property (nonatomic,strong)CoreStatusBtn       *loginBtn;

@property (nonatomic,strong)UIButton            *registerBtn;

@property (nonatomic,strong)UIScrollView        *myscroll;

@property (nonatomic,strong)UITableView         *mytable;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    
}
#pragma mark 键盘监听
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
        
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        
        TFModel *tfm1=[TFModel modelWithTextFiled:_txtUsername inputView:_myscroll name:nil insetBottom:0];
        TFModel *tfm2=[TFModel modelWithTextFiled:_txtPsaaword inputView:_myscroll name:nil insetBottom:0];
        
        return @[tfm1,tfm2];
        
    }];
}
#pragma mark 视图创建
- (void)viewCreat{
    self.view.backgroundColor = UIColorFromRGB(0xe8e8e8);
    
    self.title = @"登录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerBtnClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"0xffffff" alpha:0.8]];
    
    NSInteger height = HEIGHT/10;
    _mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT - 64 - 20) style:UITableViewStylePlain];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.scrollEnabled = NO;
    _mytable.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [self.view addSubview:_mytable];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/3)];
    _mytable.tableFooterView = footView;
    
    
    _loginBtn = [[CoreStatusBtn alloc] init];
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    _loginBtn.backgroundColorForNormal = UIColorFromRGB(0x00bcd5);
    _loginBtn.shutOffColorLoadingAnim = YES;
    _loginBtn.shutOffZoomAnim = YES;
    _loginBtn.status = CoreStatusBtnStatusNormal;
    _loginBtn.msg = @"正在登录";
    [footView addSubview:_loginBtn];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(30);
        make.left.equalTo(footView).with.offset(20);
        make.right.equalTo(footView).with.offset(-20);
        make.height.mas_equalTo(HEIGHT/15);
    }];
    
    
    
    _labForget = [[UILabel alloc] init];
    _labForget.text = @"忘记密码?";
    _labForget.userInteractionEnabled = YES;
    _labForget.textColor = UIColorFromRGB(0x666666);
    _labForget.textAlignment = NSTextAlignmentRight;
    [footView addSubview:_labForget];
    [_labForget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginBtn.mas_bottom).offset(10);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@15);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forGetPasswordClick)];
    [_labForget addGestureRecognizer:tap];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT/10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        _txtUsername = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/10)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT/10, HEIGHT/10)];
        UIImageView *img_user = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_phone"]];
        img_user.frame = CGRectMake(HEIGHT/40, HEIGHT/40, HEIGHT/20, HEIGHT/20);
        [view addSubview:img_user];
        _txtUsername.clearButtonMode = YES;
        _txtUsername.leftViewMode = UITextFieldViewModeAlways;
        _txtUsername.leftView = view;
        _txtUsername.placeholder = @"请输入手机号";
        [cell.contentView addSubview:_txtUsername];
    }else{
        _txtPsaaword = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 60, HEIGHT/10)];
        _txtPsaaword.clearButtonMode = YES;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT/10, HEIGHT/10)];
        UIImageView *img_user = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
        img_user.frame = CGRectMake(HEIGHT/40, HEIGHT/40, HEIGHT/20, HEIGHT/20);
        [view addSubview:img_user];
        _txtPsaaword.leftViewMode = UITextFieldViewModeAlways;
        _txtPsaaword.leftView = view;
        _txtPsaaword.secureTextEntry = YES;
        _txtPsaaword.placeholder = @"请输入密码";
        
        KLSwitch *klswitch = [[KLSwitch alloc] initWithFrame:CGRectMake(WIDTH - 60, HEIGHT/40, 50, HEIGHT/20)];
        [cell.contentView addSubview:klswitch];
        klswitch.didChangeHandler = ^(BOOL isOn) {
            if (isOn) {
                _txtPsaaword.secureTextEntry = NO;
            }else{
                _txtPsaaword.secureTextEntry = YES;
            }
        };
        [cell.contentView addSubview:_txtPsaaword];
    }
    return cell;
}
#pragma mark 忘记密码点击
- (void)forGetPasswordClick{
    ForgetPasswordViewController *forget = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
}
- (void)registerBtnClick{
    
    RegisterViewController *registerView = [[RegisterViewController alloc]init];
    
    [self.navigationController pushViewController:registerView animated:YES];
    
}
#pragma mark 登录事件
- (void)login{
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
        
    }else{
        if (_txtUsername.text.length != 11 && ![_txtUsername.text hasPrefix:@"1"]) {
            
        [self.view makeToast:@"请输入正确的手机号" duration:1.0 position:CSToastPositionTop];
            
        }else{
            _loginBtn.status = CoreStatusBtnStatusProgress;
        
            [_txtPsaaword resignFirstResponder];
            [_txtUsername resignFirstResponder];
        /**
         参数	描述	允许为空
         phoneNo	账号	否
         passWord	密码	否
         sSID	SSID标识	否
         operSystem	手机操作系统android,ios	否
         operSystemModel	手机具体型号5.0	否
         phoneType	手机类型,三星、苹果	否
         appVersion	版本号	否

         */
            NSString *sSID=[ETSUUID getUniqueDeviceIDFromKeychain];
            NSString *operSystemModel=[UIDevice currentDevice].systemVersion;
            NSString *currentVersion=[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
;
            NSDictionary *dataDic = @{@"phoneNo"    :_txtUsername.text,
                                      @"passWord"   :[MyMD5 md5:_txtPsaaword.text],
                                      @"sSID":sSID,
                                      @"operSystem":@"iOS",
                                      @"operSystemModel":operSystemModel,
                                      @"phoneType":@"iPhone",
                                      @"appVersion":appVersion};
        
            AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
            [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_UserLogin] parameters:dataDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"JSON: %@", responseObject);
            NSNumber *code = [responseObject objectForKey:@"code"];
            int code_int = [code intValue];
            if (code_int == 200) {
                
                _loginBtn.status = CoreStatusBtnStatusSuccess;
                
//                TaskViewController *task = [[TaskViewController alloc] init];
                User *user = [[User alloc] init];
                user.userId = [[responseObject objectForKey:@"data"] objectForKey:@"userId"];
                user.userPhoneNo = _txtUsername.text;
                user.isLogin = YES;
                user.userName = [[responseObject objectForKey:@"data"] objectForKey:@"userName"];
                
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
                NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
                [dd setObject:userData forKey:@"myUser"];
                [dd synchronize];
                [self dissmissLogin];
                [[NSNotificationCenter defaultCenter] postNotificationName:loginSuccess_refreshWaitVC object:nil];

            }else{
                _loginBtn.status = CoreStatusBtnStatusFalse;
                [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
            }
            

        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"error>>>>%@",error);
            NSLog(@">%@",operation.responseString);
        }];
    }
    }

}
#pragma 跳转方式  子类会重写
- (void)dissmissLogin{
     [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark 手机号的输入限制
- (void)changePhoneNumValue{
    int MaxLen = 11;
    NSString *szText = [_txtUsername text];
    if ([szText length]> MaxLen)
    {
        _txtUsername.text = [szText substringToIndex:MaxLen];
    }
}
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
