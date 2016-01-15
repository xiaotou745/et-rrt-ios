//
//  SCBandAliPayVC.m
//  SupermanC
//
//  Created by riverman on 15/9/29.
//  Copyright © 2015年 etaostars. All rights reserved.
//

#import "SCBandAliPayVC.h"
#import "SCAlipayCell.h"
#import "CoreLabel.h"

#define verifyCodeBtnTitle @"获取验证码"

@interface SCBandAliPayVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    int _countingNum;
    NSTimer * _timer;
    BOOL _isCounting;
}
@property (weak, nonatomic) IBOutlet UITableView *alipayTableV;

@property (nonatomic,strong)NSArray *titles;

@property(nonatomic, strong)NSString *alipayNumber;//账户号
@property(nonatomic, strong)NSString *alipayName;//账户名
@property(nonatomic, strong)NSString *checkCode;//验证码

@property(nonatomic, strong)NSString *cardid;//cardid
@property(nonatomic, assign)BOOL modify;//modify

@property(nonatomic ,strong)UIButton *codeBtn;

@end

@implementation SCBandAliPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    _user=[[User alloc]init];
    [self configNavBar];
}

-(void)configNavBar
{
    self.title=@"绑定支付宝";
    self.alipayTableV.delegate=self;
    self.alipayTableV.dataSource=self;
    self.alipayTableV.sectionFooterHeight=0;
    self.alipayTableV.keyboardDismissMode=UIScrollViewKeyboardDismissModeInteractive;
    self.alipayTableV.scrollEnabled=NO;
    self.alipayTableV.backgroundColor=self.view.backgroundColor;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0,0, WIDTH, 100)];

    UIButton *saveBtn=[ManFactory createButtonWithFrame:CGRectMake(0,30,DEF_SCEEN_WIDTH-30, 40) ImageName:@"" Target:self Action:@selector(bandingClick) Title:@"绑定"];
    saveBtn.backgroundColor=[UIColor colorWithRed:0 green:0.74 blue:0.84 alpha:1];
    saveBtn.center=CGPointMake(DEF_SCEEN_WIDTH/2, 60);
    
    saveBtn.layer.cornerRadius=3;
    saveBtn.layer.masksToBounds=YES;
    
    [footView addSubview:saveBtn];
    
    UILabel *myTitleLabel2 = [[UILabel alloc] init];
    myTitleLabel2.text = @"*绑定成功后，您的提现资金将转入此支付宝账户中";
    myTitleLabel2.numberOfLines = 0;
    myTitleLabel2.textAlignment=NSTextAlignmentCenter;
    myTitleLabel2.font = [UIFont systemFontOfSize:12];
    myTitleLabel2.textColor = UIColorFromRGB(0x888888);
    [footView addSubview:myTitleLabel2];
    [myTitleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(saveBtn.mas_bottom).with.offset(15);
        make.left.equalTo(footView).with.offset(0);
        make.right.equalTo(footView).with.offset(0);
    }];
    self.alipayTableV.tableFooterView=footView;
    
    
    _alipayNumber=@"";
    _alipayName=@"";
    _checkCode=@"";

    _cardid=@"";
//    for (int i=0; i<accouts.count; i++) {
//        
//        NSString *openBankNo=[Security AesDecrypt:accouts[i][@"AccountNo"]];
//        NSString *AccountType=accouts[i][@"AccountType"];
//        NSString *trueName=accouts[i][@"TrueName"];
//            //支付宝
//        if ([AccountType intValue] ==2) {
//            
//            _alipayNumber=openBankNo;
//            _alipayNumber2=openBankNo;
//            _alipayName=trueName;
//            _cardid=accouts[i][@"Id"];
//            _modify=YES;
//        }
//    }
    
    _titles=@[
              @[@{kSCAlipayCell_title:@"已绑定手机",
                  kSCAlipayCell_text:[_user.userPhoneNo replaceNumberWithStar],
                  kSCAlipayCell_placeholder:@""}],
              
              @[@{kSCAlipayCell_title:@"手机验证码",
                  kSCAlipayCell_text:_checkCode,
                  kSCAlipayCell_placeholder:@"请输入短信验证码"}],
              
              @[@{kSCAlipayCell_title:@"支付宝账户",
                kSCAlipayCell_text:_alipayNumber,
                kSCAlipayCell_placeholder:@"请输入支付宝账户"}],
              
              @[@{kSCAlipayCell_title:@"支付宝实名",
                kSCAlipayCell_text:_alipayName,
                kSCAlipayCell_placeholder:@"请输入支付宝账户的真实姓名"}]
              ];
    
}

#pragma mark tableView  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"indexPath  %ld  %ld",indexPath.section,indexPath.row);
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuserID=@"SCAlipayCellID";
    SCAlipayCell *cell=[tableView dequeueReusableCellWithIdentifier:reuserID];
    if (nil == cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SCAlipayCell" owner:nil options:nil]firstObject];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    cell.contentTF.tag=1000+indexPath.section;
    cell.contentTF.delegate=self;
    NSDictionary *infoDic=self.titles[indexPath.section][indexPath.row];
    cell.dic=infoDic;
    
    if(indexPath.section==0){
        [cell.contentTF setEnabled:NO];
        _codeBtn=[[UIButton alloc]initWithFrame:CGRectMake(DEF_SCEEN_WIDTH-110, 5, 100, 30)];
        _codeBtn.layer.cornerRadius=3;
        _codeBtn.layer.borderWidth=0.5;
        _codeBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_codeBtn setTitle:verifyCodeBtnTitle forState:UIControlStateNormal];
        [_codeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_codeBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.81 blue:0.89 alpha:1]  forState:UIControlStateNormal];
        
        [_codeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_codeBtn];
    
    }
    
    return cell;
}

#pragma mark 获取验证码
- (void)sendCode{
    
    [self verificationCodeBtnCountDown];
    
    //sType类型 1注册 2修改密码 3忘记密码 4绑定支付宝
    NSDictionary *dataDic = @{@"phoneNo":_user.userPhoneNo,
                              @"sType"  :@"4"};
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_VerifyCode] parameters:dataDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSInteger code = [[responseObject objectForKey:@"code"]  intValue];
        if (code == 200) {
            NSLog(@"验证码已经发送");

        }else{
            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error>>>>%@",error);
        NSLog(@">%@",operation.responseString);
    }];
    
}
#pragma mark -  请求验证码倒计时
/// 请求验证码倒计时
- (void)verificationCodeBtnCountDown{
    //开始计时
    self.codeBtn.enabled = NO;
    [_codeBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateNormal];

    _countingNum = 60;
    if (_isCounting == YES) {
    }else{
        [NSThread detachNewThreadSelector:@selector(fireTimer) toTarget:self withObject:nil];
    }
}

- (void)fireTimer{
    _isCounting = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countingnumber:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

- (void)countingnumber:(NSTimer *)timer{
    _countingNum--;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%@(%d)",@"重新发送",_countingNum] forState:UIControlStateDisabled];
    if (_countingNum == 0) {
        [self invalidateTimer];
    }
}

- (void)invalidateTimer{
    _isCounting = NO;
    [_timer invalidate];
    _timer = nil;
    self.codeBtn.enabled = YES;
    self.codeBtn.userInteractionEnabled = YES;
    [self.codeBtn setTitle:verifyCodeBtnTitle forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.81 blue:0.89 alpha:1]  forState:UIControlStateNormal];

}

-(void)bandingClick{

    [MyTools closeKeyboard];
    
    if (![_alipayNumber isRightPhoneNumberFormat]&&![_alipayNumber isValidateEmail]) {
        [self postAlertWithMsg:@"支付宝账号格式错误"];
        return;
    }
    
//    if (_checkCode.length!=6) {
//        [self postAlertWithMsg:@"验证码错误"];
//        return;
//    }
    
    if (_alipayName.length>30) {
              [self postAlertWithMsg:@"姓名过长，请重新输入"];
            return;
    }

    if (_alipayName.length<1) {
        [self postAlertWithMsg:@"请输入支付宝真实姓名"];
        return;
    }
    
    
    CustomIOSAlertView *alert = [self tishiAlert];
    [alert show];
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            [self gotoBandingALipay];
        }
    }];
}
-(void)gotoBandingALipay{
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{
                                 @"userId": _user.userId,
                                 @"phoneNo":_user.userPhoneNo,
                                 @"verifyCode":_checkCode,
                                 @"aliAccount":_alipayNumber,
                                 @"aliName":_alipayName};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_bindalipay] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
            [self postAlertWithMsg:@"绑定成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:notify_bandingAlipaySuccess object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [self postAlertWithMsg:[responseObject objectForKey:@"msg"]];
//[CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:[responseObject objectForKey:@"msg"] offsetY:-100 failClickBlock:^{
//                        }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self postAlertWithMsg:@"加载失败,请检查网络设置"];

//        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"请检查网络设置" offsetY:-100 failClickBlock:^{
//        }];
    }];


}
//第一次绑定 插入本地账户
-(void)saveAlipay:(NSString *)cardid AccountNo:(NSString *)AccountNo TrueName:(NSString *)TrueName{

//    {
//        AccountNo = "X8kZKmA3+qOalPD1crEMXsyon701Rh6k0l4V5AaXvgg=";
//        AccountType = 2;
//        BelongType = 0;
//        ClienterId = 3179;
//        CreateBy = "\U6ee1\U5b5d\U6cb3";
//        CreateTime = "2015-10-29T16:28:56";
//        IDCard = "";
//        Id = 123;
//        IsEnable = 1;
//        OpenBank = "";
//        OpenCity = "";
//        OpenCityCode = 0;
//        OpenProvince = "";
//        OpenProvinceCode = 0;
//        OpenSubBank = "";
//        PhoneNo = "";
//        TrueName = "\U6211\U4eec\U7684";
//        UpdateBy = "\U6211\U4eec\U7684";
//        UpdateTime = "2015-10-29T16:57:48";
//        YeepayKey = "";
//        YeepayStatus = 0;
//    }
    
    NSMutableDictionary *alipayModel=[NSMutableDictionary dictionary];
    
    [alipayModel setObject:AccountNo forKey:@"AccountNo"];
    [alipayModel setObject:cardid forKey:@"Id"];
    [alipayModel setObject:TrueName forKey:@"TrueName"];

    [alipayModel setObject:@"" forKey:@"IDCard"];
    [alipayModel setObject:@"2" forKey:@"AccountType"];
    [alipayModel setObject:@"0" forKey:@"BelongType"];
    [alipayModel setObject:@"" forKey:@"ClienterId"];
    [alipayModel setObject:@"" forKey:@"CreateBy"];
    [alipayModel setObject:@"" forKey:@"CreateTime"];
    [alipayModel setObject:@"" forKey:@"IsEnable"];
    [alipayModel setObject:@"" forKey:@"OpenBank"];
    [alipayModel setObject:@"" forKey:@"OpenCity"];
    [alipayModel setObject:@"" forKey:@"OpenCityCode"];
    [alipayModel setObject:@"" forKey:@"OpenProvince"];
    [alipayModel setObject:@"" forKey:@"OpenProvinceCode"];
    [alipayModel setObject:@"" forKey:@"OpenSubBank"];
    [alipayModel setObject:@"" forKey:@"PhoneNo"];
    [alipayModel setObject:@"" forKey:@"UpdateBy"];
    [alipayModel setObject:@"" forKey:@"UpdateTime"];
    [alipayModel setObject:@"" forKey:@"YeepayKey"];
    [alipayModel setObject:@"" forKey:@"YeepayStatus"];


//    NSMutableArray *accouts=[NSMutableArray arrayWithArray:DEF_PERSISTENT_GET_OBJECT(SHInvokerUserInfoListcFAcount)];
//    [accouts addObject:alipayModel];
//    
//    DEF_PERSISTENT_SET_OBJECT(accouts, SHInvokerUserInfoListcFAcount);

}

-(void)modifyAlipayAccout_payAccountNo:(NSString *)AccountNo TrueName:(NSString *)TrueName{

//    NSMutableArray *accouts=[NSMutableArray arrayWithArray:DEF_PERSISTENT_GET_OBJECT(SHInvokerUserInfoListcFAcount)];
//    
//    for (int i=0; i<accouts.count; i++) {
//
//        NSString *AccountType=accouts[i][@"AccountType"];
//        
//        if ([AccountType intValue] ==2) {
//            
//            AccountNo=[Security AesEncrypt:AccountNo];
//            
//            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:accouts[i]];
//            [dic setObject:TrueName forKey:@"TrueName"];
//            [dic setObject:AccountNo forKey:@"AccountNo"];
//            [accouts replaceObjectAtIndex:i withObject:dic];
//        }
//    }
//
//    DEF_PERSISTENT_SET_OBJECT(accouts, SHInvokerUserInfoListcFAcount);
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //
    if (textField.tag == 1002 ) {
        textField.keyboardType=UIKeyboardTypeEmailAddress;
    }  //
    else  textField.keyboardType=UIKeyboardTypeDefault;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag== 1001) {
        _checkCode=textField.text;
        
    }else if (textField.tag ==1002){
        _alipayNumber=textField.text;
        
    }else if (textField.tag ==1003){
        _alipayName=textField.text;
    }

}
- (void)backBarButtonPressed {
    
    [UIAlertView showAlertViewWithTitle:nil message:@"绑定尚未完成，确定退出吗" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex){
    
        [self.navigationController popViewControllerAnimated:YES];

    } onCancel:^(){}];
    
}

- (CustomIOSAlertView *)tishiAlert{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 20, HEIGHT/4 + 10)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tishi"]];
    [img setHidden:YES];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font=[UIFont systemFontOfSize:17];
    titleLab.text=@"请核实您的帐户信息";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *lab_titile1 = [[UILabel alloc] init];
    lab_titile1.font=[UIFont systemFontOfSize:15];
    lab_titile1.textColor = UIColorFromRGB(0x666666);
    lab_titile1.textAlignment = NSTextAlignmentRight;
    
    UILabel*lab_msg1 = [[UILabel alloc] init];
    lab_msg1.font=lab_titile1.font;
    lab_msg1.textColor = UIColorFromRGB(0x00bcd5);
    lab_msg1.textAlignment = NSTextAlignmentLeft;
    
    UILabel *lab_titile2 = [[UILabel alloc] init];
    lab_titile2.font=lab_titile1.font;
    lab_titile2.textColor = UIColorFromRGB(0x666666);
    lab_titile2.textAlignment = NSTextAlignmentRight;
    
    UILabel*lab_msg2 = [[UILabel alloc] init];
    lab_msg2.font=lab_titile1.font;
    lab_msg2.textColor = UIColorFromRGB(0x00bcd5);
    lab_msg2.textAlignment = NSTextAlignmentLeft;
    
//    UILabel *lab_titile3 = [[UILabel alloc] init];
//    lab_titile3.font=lab_titile1.font;
//    lab_titile3.textColor = UIColorFromRGB(0x666666);
//    lab_titile3.textAlignment = NSTextAlignmentRight;
    
    CoreLabel*lab_msg3 = [[CoreLabel alloc] init];
    lab_msg3.font=lab_titile1.font;
    lab_msg3.textColor = [UIColor grayColor];
    lab_msg3.textAlignment = NSTextAlignmentLeft;
    lab_msg3.numberOfLines=0;
    
    
    [view addSubview:img];
    [view addSubview:titleLab];
    [view addSubview:lab_titile1];
    [view addSubview:lab_titile2];
//    [view addSubview:lab_titile3];
    [view addSubview:lab_msg1];
    [view addSubview:lab_msg2];
    [view addSubview:lab_msg3];
    
    lab_titile1.text = @"支付宝帐户:";
    lab_titile2.text = @"支付宝实名:";
//    lab_titile3.text = @"提现人名:";
    lab_msg1.text = _alipayNumber;
    lab_msg2.text = _alipayName;
    lab_msg3.text = @"*为保证您顺利提现，请确保上述支付宝帐户和实名信息准确无误";
    
//    [lab_msg3 addAttr:CoreLabelAttrColor value:[UIColor whiteColor] range:NSMakeRange(0,4)];
    
    [lab_msg3 addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(15,5)];
    [lab_msg3 addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(21,4)];

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
        make.top.mas_equalTo(img.mas_bottom).offset(5);
        make.left.equalTo(view).with.offset(0);
        make.right.mas_equalTo(lab_msg1.mas_left);
        //        make.width.mas_equalTo(lab_msg1.mas_width);
        make.width.mas_equalTo(90);
        
    }];
    [lab_msg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).offset(5);
        make.left.mas_equalTo(lab_titile1.mas_right);
        make.right.equalTo(view).with.offset(-0);
        //        make.width.mas_equalTo(lab_titile1.mas_width);
    }];
    
    [lab_titile2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile1.mas_bottom).offset(8);
        make.left.equalTo(view).with.offset(0);
        make.right.mas_equalTo(lab_msg2.mas_left);
        make.width.mas_equalTo(lab_titile1.mas_width);
    }];
    [lab_msg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile1.mas_bottom).offset(8);
        make.left.mas_equalTo(lab_titile2.mas_right);
        make.right.equalTo(view).with.offset(-0);
        //        make.width.mas_equalTo(lab_titile2.mas_width);
    }];
    
//    [lab_titile3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(lab_titile2.mas_bottom).offset(10);
//        make.left.equalTo(view).with.offset(0);
//        make.right.mas_equalTo(lab_msg3.mas_left);
//        make.width.mas_equalTo(lab_titile1.mas_width);
//    }];
    [lab_msg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile2.mas_bottom).offset(8);
        make.left.equalTo(view).with.offset(10);
        make.right.equalTo(view).with.offset(-10);
        //        make.width.mas_equalTo(lab_titile3.mas_width);
    }];
    
    
    // Add some custom content to the alert view
    [alertView setContainerView:view];
    
    // Modify the parameters
    [alertView setButtonTitles:@[@"取消",@"确认绑定"]];
    
    // You may use a Block, rather than a delegate.
    
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    
    
    return alertView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [MyTools closeKeyboard];
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
