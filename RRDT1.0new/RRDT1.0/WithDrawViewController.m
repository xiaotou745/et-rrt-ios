//
//  WithDrawViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/22.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "WithDrawViewController.h"

#import "CoreTFManagerVC.h"

#import "CoreStatusBtn.h"
#import "SCBandAliPayVC.h"

@interface WithDrawViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{    
    CoreStatusBtn *btn;
}

@property (nonatomic,strong) UIScrollView *myscroll;

@property (nonatomic,strong) UITableView *mytable;

@property (nonatomic,strong) UITextField *txtMoeny;

@property (nonatomic,strong) UITextField *txtAccount;

@property (nonatomic,strong) UITextField *txtUsername;

//@property (nonatomic,strong) UILabel     *nameLab;
//
@property (nonatomic,strong) UILabel     *moneyLab;

@property (nonatomic,strong) UILabel     *leijiLab;

@end

@implementation WithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMyInfo) name:notify_bandingAlipaySuccess object:nil];

}
- (void)viewCreat{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.title = @"提现";
    _user = [[User alloc] init];
    NSLog(@">?>>>>%@",_user.userName);
    _mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.showsHorizontalScrollIndicator = NO;
    _mytable.showsVerticalScrollIndicator   = NO;
    _mytable.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_mytable];
    
    

    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, 200)];
    
    
    UILabel *myTitleLabel1 = [[UILabel alloc] init];
    myTitleLabel1.text = @"友情提示";
    myTitleLabel1.font = [UIFont systemFontOfSize:12];
    myTitleLabel1.textColor = UIColorFromRGB(0x888888);
    [footView addSubview:myTitleLabel1];
    [myTitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(10);
        make.left.equalTo(footView).with.offset(15);
        make.right.equalTo(footView).with.offset(-15);
    }];
    
    UILabel *myTitleLabel2 = [[UILabel alloc] init];
    myTitleLabel2.text = @"1.为确保转账成功，请保证您的支付宝账号信息真实、有效\n2.申请提现后，我们将以最快的速度转账，请您耐心等待\n3.注意：提现金额只能为10的整数倍（例如10、100、150）\n4.单笔提现金额上限1000元，每笔提现将收取3元手续费";
    myTitleLabel2.numberOfLines = 0;
    myTitleLabel2.font = [UIFont systemFontOfSize:11];
    myTitleLabel2.textColor = UIColorFromRGB(0x888888);
    [footView addSubview:myTitleLabel2];
    [myTitleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myTitleLabel1.mas_bottom).with.offset(5);
        make.left.equalTo(footView).with.offset(15);
        make.right.equalTo(footView).with.offset(-15);
    }];
    
    btn = [[CoreStatusBtn alloc] init];
    btn.backgroundColorForNormal = UIColorFromRGB(0x00bcd5);
    btn.shutOffColorLoadingAnim = YES;
    btn.shutOffZoomAnim = YES;
    btn.status = CoreStatusBtnStatusNormal;
    btn.msg = @"正在提交";
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"确认提现" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myTitleLabel2.mas_bottom).with.offset(20);
        make.left.equalTo(footView).with.offset(10);
        make.right.equalTo(footView).with.offset(-10);
        make.height.equalTo(@45);
    }];
    _mytable.tableFooterView = footView;
    
    
    
    
    
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"请检查网络设置" offsetY:-100 failClickBlock:^{
            
            [self getMyInfo];
        }];
    }else{
        [self getMyInfo];
    }
}
- (void)getMyInfo{
    
    
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{@"userId": _user.userId};
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    parameters=[HttpHelper  security:parameters];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_MyInmoney] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
            
            _user.userName      = [[responseObject objectForKey:@"data"] objectForKey:@"clienterName"];//用户名
            _user.userPhoneNo   = [[responseObject objectForKey:@"data"] objectForKey:@"phoneNo"];
            
            _user.sex = [[[responseObject objectForKey:@"data"] objectForKey:@"sex"] integerValue];
            _user.age = [[[responseObject objectForKey:@"data"] objectForKey:@"age"] integerValue];
            _user.headImage = [[responseObject objectForKey:@"data"] objectForKey:@"headImage"];
            
            _user.balance       = [[[responseObject objectForKey:@"data"] objectForKey:@"balance"] floatValue];//余额
            _user.withdrawing   = [[[responseObject objectForKey:@"data"] objectForKey:@"withdrawing"] floatValue];//提现中
            _user.fullHeadImage = [[responseObject objectForKey:@"data"] objectForKey:@"fullHeadImage"];
            
            _user.totalAmount   = [[[responseObject objectForKey:@"data"] objectForKey:@"totalAmount"] floatValue];//累计金额
            _user.withdraw   = [[[responseObject objectForKey:@"data"] objectForKey:@"withdraw"] floatValue];//可以体现的金额
            
            _user.hadWithdraw   = [[[responseObject objectForKey:@"data"] objectForKey:@"hadWithdraw"] floatValue];//已提现金额

            _user.accountType   =[[[responseObject objectForKey:@"data"] objectForKey:@"accountType"] intValue];
            _user.accountNo =[[responseObject objectForKey:@"data"] objectForKey:@"accountNo"];
            _user.trueName =[[responseObject objectForKey:@"data"] objectForKey:@"trueName"];

            _moneyLab.text  = [NSString stringWithFormat:@"%.2f",_user.withdraw];
//            _nameLab.text   = [NSString stringWithFormat:@"%@的财富",_user.userName];
            _leijiLab.text  = [NSString stringWithFormat:@"已提现: ¥%.2f",_user.hadWithdraw];
            [_mytable reloadData];
            
        }else{
            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)btnClick{
    
//    CustomIOSAlertView *alert = [self tishiAlert];
//    [alert show];
    if (_user.accountType == -1) {
        [UIAlertView showAlertViewWithTitle:nil message:@"绑定支付宝帐户后才能申请提现哦" cancelButtonTitle:@"取消" otherButtonTitles:@[@"绑定支付宝"] onDismiss:^(NSInteger buttonIndex){
            [self gotoBandingAlipayVC];
        } onCancel:^(
         
         ){}];
        return;
    }
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]){
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
        return;
    }
        
    float myMoney = [[_txtMoeny text] floatValue];
        
    if (myMoney < 10.0) {
        [self.view makeToast:@"提现金额不能小于10元" duration:1.0 position:CSToastPositionTop];
        return;
    }
    
    if (myMoney > 1000.0) {
        [self.view makeToast:@"单笔提现金额不能超过1000元" duration:1.0 position:CSToastPositionTop];
        return;
    }
    int moneyAmout=[[_txtMoeny text] intValue];

    if (moneyAmout%10!=0) {
        [self.view makeToast:@"提现金额必须为10的整数倍" duration:1.0 position:CSToastPositionTop];
        return;
    }
    
    if (_txtMoeny.text.length == 0 ) {
        [self.view makeToast:@"请输入正确的金额" duration:1.0 position:CSToastPositionTop];
        return;
    }
    
            CustomIOSAlertView *alert = [self tishiAlert];
            [alert show];
            [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                if (buttonIndex == 1) {
                        [self wantGeyMonry];
                }
            }];

}
- (void)wantGeyMonry{
    
    
    
    btn.status = CoreStatusBtnStatusProgress;
    
    
    NSDictionary *parameters = @{@"userId": _user.userId,
                                 @"amount":@([self moneyTextIntValue]),
                                 @"accountInfo":_user.accountNo,
                                 @"trueName":_user.trueName};
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    parameters=[HttpHelper  security:parameters];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_WithDraw] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@">>>>%@",parameters);
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"msg: %@", [responseObject objectForKey:@"msg"]);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            btn.status = CoreStatusBtnStatusSuccess;

            [UIAlertView showAlertViewWithTitle:nil message:@"提现申请已提交，款项会尽快打到您的账户，请耐心等待" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(NSInteger buttonIndex){} onCancel:^(){
            
                [self.navigationController popViewControllerAnimated:YES];

            }];
            
//            CustomIOSAlertView *alert = [self successAlert:@"icon_tishi" andtitle:@"提示" andmsg:@"提现申请已提交，款项会尽快打到您的账户，请耐心等待" andButtonItem:[NSMutableArray arrayWithObjects:@"确定", nil]];
//            [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
//                NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
//                
//                [alertView close];
//
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            }];
//            [alert show];
            
        }else{
            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
            btn.status = CoreStatusBtnStatusFalse;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.view makeToast:@"未知错误" duration:1.0 position:CSToastPositionTop];
        btn.status = CoreStatusBtnStatusFalse;
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex == 1) {
            [self wantGeyMonry];
        }
    }else if (alertView.tag == 222){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }else{
        return 44;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.text = @"我的余额";
        myLabel.font = [UIFont systemFontOfSize:12];
        myLabel.textColor = UIColorFromRGB(0x888888);
        [cell.contentView addSubview:myLabel];
        [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).with.offset(15);
            make.left.equalTo(cell.contentView).with.offset(12);
        }];
        
        
        UILabel *mLabel = [[UILabel alloc] init];
        mLabel.textColor = UIColorFromRGB(0xf7585d);
        mLabel.text = @"¥";
        mLabel.font = [UIFont systemFontOfSize:28];
        [cell.contentView addSubview:mLabel];
        [mLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(12);
            make.bottom.equalTo(cell.contentView).with.offset(-60);
        }];
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textColor = UIColorFromRGB(0xf7585d);
        _moneyLab.font = [UIFont systemFontOfSize:38];
        [cell.contentView addSubview:_moneyLab];
        [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(mLabel.mas_right).offset(5);
            make.bottom.equalTo(cell.contentView).with.offset(-55);
        }];
        

        
        _leijiLab = [[UILabel alloc] init];
        _leijiLab.font = [UIFont systemFontOfSize:14];
        _leijiLab.textColor = UIColorFromRGB(0x333333);
        [cell.contentView addSubview:_leijiLab];
        [_leijiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView).with.offset(0);
            make.height.equalTo(@40);
            make.left.equalTo(cell.contentView).with.offset(12);
        }];
        
        
        UIView *lineLabel = [[UIView alloc] init];
        lineLabel.backgroundColor = UIColorFromRGB(0xdfdfdf);
        [cell.contentView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(12);
            make.right.equalTo(cell.contentView).with.offset(-0);
            make.bottom.mas_equalTo(_leijiLab.mas_top).with.offset(0);
            make.height.equalTo(@1);
        }];
        
        
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"提现账户";
            
            UIButton *alipayBtn=[[UIButton alloc]initWithFrame:CGRectMake(90, 12, 60, 25)];
            alipayBtn.layer.cornerRadius=3;
            alipayBtn.layer.borderWidth=0.5;
            alipayBtn.layer.borderColor=[UIColor colorWithRed:0.18 green:0.81 blue:0.89 alpha:1].CGColor;
            [alipayBtn setTitle:@"支付宝" forState:UIControlStateNormal];
            [alipayBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [alipayBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.81 blue:0.89 alpha:1]  forState:UIControlStateNormal];
            alipayBtn.userInteractionEnabled=NO;
            
            [cell.contentView addSubview:alipayBtn];
            
            UIImageView *arrowRight=[ManFactory createImageViewWithFrame:CGRectMake(DEF_SCEEN_WIDTH-20, 15, 15, 20) ImageName:@"icon_right"];
            [cell.contentView addSubview:arrowRight];
            
            _txtAccount = [[UITextField alloc]initWithFrame:CGRectMake(alipayBtn.right,alipayBtn.top, WIDTH-alipayBtn.right-30, alipayBtn.height)];
            _txtAccount.font=[UIFont systemFontOfSize:14];
            _txtAccount.textColor=UIColorFromRGB(0x666666);
            _txtAccount.enabled=NO;
//            _txtAccount.backgroundColor=[UIColor orangeColor];
            _txtAccount.textAlignment = NSTextAlignmentRight;
            _txtAccount.returnKeyType = UIReturnKeyDone;
            _txtAccount.clearButtonMode = YES;
//            [_txtAccount setValue:UIColorFromRGB(0x888888) forKeyPath:@"_placeholderLabel.textColor"];
            [_txtAccount setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
            [cell.contentView addSubview: _txtAccount];
            
            if(_user.accountType==-1){
                _txtAccount.text=@"未设置";
            }else if(_user.accountType==2){
                _txtAccount.text=[_user.accountNo replaceNumberWithStar];

            }
            
        }else if (indexPath.row == 1){
            
            cell.textLabel.text = @"提现金额";
            _txtMoeny = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, WIDTH-120, 40)];
            _txtMoeny.tag = 999999;
            _txtMoeny.textAlignment = NSTextAlignmentLeft;
            _txtMoeny.returnKeyType = UIReturnKeyDone;
            _txtMoeny.clearButtonMode = YES;
            _txtMoeny.keyboardType = UIKeyboardTypeDecimalPad;
            _txtMoeny.placeholder = @"请输入提现金额,最低10元";
            [_txtMoeny setValue:UIColorFromRGB(0x888888) forKeyPath:@"_placeholderLabel.textColor"];
            [_txtMoeny setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
            [cell.contentView addSubview: _txtMoeny];
           
        }else{
            cell.textLabel.text = @"支付宝姓名";
            _txtUsername = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, WIDTH-120, 40)];
            _txtUsername.textAlignment = NSTextAlignmentLeft;
            _txtUsername.returnKeyType = UIReturnKeyDone;
            _txtUsername.clearButtonMode = YES;
            _txtUsername.placeholder = @"请输入支付宝姓名";
            cell.accessoryView = _txtUsername;
            [_txtUsername setValue:UIColorFromRGB(0x888888) forKeyPath:@"_placeholderLabel.textColor"];
            [_txtUsername setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==1&&indexPath.row==0) {
        [self gotoBandingAlipayVC];
    }
}
-(void)gotoBandingAlipayVC{
    SCBandAliPayVC *alipayVC=[[SCBandAliPayVC alloc]initWithNibName:@"SCBandAliPayVC" bundle:nil];
    [self.navigationController pushViewController:alipayVC animated:YES];
}
#pragma mark 注册键盘
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:_txtMoeny inputView:nil name:nil insetBottom:0];
        
        TFModel *tfm2=[TFModel modelWithTextFiled:_txtAccount inputView:nil name:nil insetBottom:0];
        
        TFModel *tfm3=[TFModel modelWithTextFiled:_txtUsername inputView:nil name:nil insetBottom:0];
        
        return @[tfm1,tfm2,tfm3];
    
    }];
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

- (CustomIOSAlertView *)successAlert:(NSString *)imgStr andtitle:(NSString *)title andmsg:(NSString *)msg andButtonItem:(NSMutableArray *)item{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 40, HEIGHT/4)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
    UILabel *lab_titile = [[UILabel alloc] init];
    lab_titile.font = [UIFont systemFontOfSize:16];
    lab_titile.textColor = UIColorFromRGB(0x666666);
    lab_titile.textAlignment = NSTextAlignmentCenter;
    UILabel*lab_msg = [[UILabel alloc] init];
    lab_msg.font = [UIFont systemFontOfSize:14];
    lab_msg.textColor = UIColorFromRGB(0x888888);
    lab_msg.numberOfLines = 0;
    lab_msg.textAlignment = NSTextAlignmentCenter;
    [view addSubview:img];
    [view addSubview:lab_titile];
    [view addSubview:lab_msg];
    lab_titile.text = title;
    lab_msg.text = msg;
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.mas_equalTo(HEIGHT/15);
        make.width.mas_equalTo(HEIGHT/15);
    }];
    [lab_titile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.left.equalTo(view).with.offset(20);
        make.right.equalTo(view).with.offset(-20);
    }];
    [lab_msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile.mas_bottom);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.left.equalTo(view).with.offset(20);
        make.right.equalTo(view).with.offset(-20);
    }];
    
    // Add some custom content to the alert view
    [alertView setContainerView:view];
    
    // Modify the parameters
    [alertView setButtonTitles:item];
    
    // You may use a Block, rather than a delegate.
    
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    
    
    return alertView;
}
- (CustomIOSAlertView *)tishiAlert{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 20, HEIGHT/4 + 10)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tishi"]];
    [img setHidden:YES];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font=[UIFont systemFontOfSize:17];
    titleLab.text=@"请核实您的提现信息";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;

    
    UILabel *lab_titile1 = [[UILabel alloc] init];
    lab_titile1.font=[UIFont systemFontOfSize:15];
    lab_titile1.textColor = UIColorFromRGB(0x666666);
    lab_titile1.textAlignment = NSTextAlignmentRight;
    
    UILabel*lab_msg1 = [[UILabel alloc] init];
    lab_msg1.font=lab_titile1.font;
    lab_msg1.textColor = UIColorFromRGB(0x666666);
    lab_msg1.textAlignment = NSTextAlignmentLeft;
    
    UILabel *lab_titile2 = [[UILabel alloc] init];
    lab_titile2.font=lab_titile1.font;
    lab_titile2.textColor = UIColorFromRGB(0x666666);
    lab_titile2.textAlignment = NSTextAlignmentRight;
    
    UILabel*lab_msg2 = [[UILabel alloc] init];
    lab_msg2.font=lab_titile1.font;
    lab_msg2.textColor = UIColorFromRGB(0x666666);
    lab_msg2.textAlignment = NSTextAlignmentLeft;
    
    UILabel *lab_titile3 = [[UILabel alloc] init];
    lab_titile3.font=lab_titile1.font;
    lab_titile3.textColor = UIColorFromRGB(0x666666);
    lab_titile3.textAlignment = NSTextAlignmentRight;
    
    UILabel*lab_msg3 = [[UILabel alloc] init];
    lab_msg3.font=lab_titile1.font;
    lab_msg3.textColor = UIColorFromRGB(0x666666);
    lab_msg3.textAlignment = NSTextAlignmentLeft;
    
    
    
    [view addSubview:img];
    [view addSubview:titleLab];
    [view addSubview:lab_titile1];
    [view addSubview:lab_titile2];
    [view addSubview:lab_titile3];
    [view addSubview:lab_msg1];
    [view addSubview:lab_msg2];
    [view addSubview:lab_msg3];
    
    lab_titile1.text = @"提现金额:";
    lab_titile2.text = @"提现账户:";
    lab_titile3.text = @"提现人名:";
    lab_msg1.text = [NSString stringWithFormat:@"%d元",[self moneyTextIntValue]];
    lab_msg2.text = _user.accountNo;
    lab_msg3.text = _user.trueName;
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.mas_equalTo(HEIGHT/16);
        make.width.mas_equalTo(HEIGHT/16);
    }];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.mas_equalTo(HEIGHT/16);
        make.width.mas_equalTo(DEF_SCEEN_WIDTH);
    }];
    
    [lab_titile1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).offset(10);
        make.left.equalTo(view).with.offset(0);
        make.right.mas_equalTo(lab_msg1.mas_left);
//        make.width.mas_equalTo(lab_msg1.mas_width);
        make.width.mas_equalTo(90);

    }];
    [lab_msg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).offset(10);
        make.left.mas_equalTo(lab_titile1.mas_right);
        make.right.equalTo(view).with.offset(-0);
//        make.width.mas_equalTo(lab_titile1.mas_width);
    }];
    
    [lab_titile2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile1.mas_bottom).offset(10);
        make.left.equalTo(view).with.offset(0);
        make.right.mas_equalTo(lab_msg2.mas_left);
        make.width.mas_equalTo(lab_titile1.mas_width);
    }];
    [lab_msg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile1.mas_bottom).offset(10);
        make.left.mas_equalTo(lab_titile2.mas_right);
        make.right.equalTo(view).with.offset(-0);
//        make.width.mas_equalTo(lab_titile2.mas_width);
    }];
    
    [lab_titile3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile2.mas_bottom).offset(10);
        make.left.equalTo(view).with.offset(0);
        make.right.mas_equalTo(lab_msg3.mas_left);
        make.width.mas_equalTo(lab_titile1.mas_width);
    }];
    [lab_msg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile2.mas_bottom).offset(10);
        make.left.mas_equalTo(lab_titile3.mas_right);
        make.right.equalTo(view).with.offset(-0);
//        make.width.mas_equalTo(lab_titile3.mas_width);
    }];
    
    
    // Add some custom content to the alert view
    [alertView setContainerView:view];
    
    // Modify the parameters
    [alertView setButtonTitles:@[@"取消",@"确定"]];
    
    // You may use a Block, rather than a delegate.
    
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    
    
    return alertView;
}

-(int)moneyTextIntValue{
    return [_txtMoeny.text intValue];
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
