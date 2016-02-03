
//
//  MyCenterViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/21.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "MyCenterViewController.h"

#import "CoreLabel.h"

#import "WithDrawViewController.h"

#import "MyInfoViewController.h"
#import "BillDetailViewController.h"
#import "PartnerViewController.h"

#import "SysemViewController.h"

#import "HelpCenterViewController.h"

#import "MyTaskViewController.h"
#import "SCMsgListVC.h"
#import "TaskDListViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface MyCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    UIView *lineView0;
    
    UILabel *phoneStr;
    UILabel *nameStr;
}
@property (nonatomic,strong)UITableView *mytable;

@property (nonatomic,strong)NSArray *imageArr;

@property (nonatomic,strong)NSArray *titleArr;

@property (nonatomic,strong)UIView *view1;

@property (nonatomic,strong)UILabel *lab_phone;
@property (nonatomic,strong)UILabel *lab_name;
@property (nonatomic,strong)UILabel *lab_toLogin;


@property (nonatomic,strong)UIImageView *headImage;

@property (nonatomic,strong)UILabel *lab_allmoney;
@property (nonatomic,strong)UILabel *lab_ketixian;
@property (nonatomic,strong)UILabel *lab_tixianzhong;

@property (nonatomic,strong)UILabel *lab_wodeyue;
@property (nonatomic,strong)UIButton *moneyBtn;

@end

@implementation MyCenterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=nil;
    [self viewCreat];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NewMessageNotify:) name:notify_newMessage object:nil];
}
- (void)viewCreat{
    
    [self setNoMsgRightBTNItem];
    self.view.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    self.title = @"个人中心";
    
    _imageArr = @[@[@"0"],@[@"icon_mingxi",@"icon_hehuoren",@"icon_shenhe"],@[@"icon_help"],@[@"icon_more"]];
    //,@[@"icon_kefu"] ,@[@"客服支持"]
    _titleArr = @[@[@"0"],@[@"资金明细",@"我的合伙人",@"资料审核详情"],@[@"帮助中心"],@[@"更多"]];
    
    _mytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64- IOS_TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    [self.view addSubview:_mytable];
    _mytable.showsHorizontalScrollIndicator = NO;
    _mytable.showsVerticalScrollIndicator = NO;
//    _mytable.tableFooterView = [UIView new];

    UIView *footView=[[UIView  alloc ]initWithFrame:CGRectMake(0, 0, DEF_SCEEN_WIDTH, 40)];
//    footView.backgroundColor=[UIColor orangeColor];
    UILabel *linkLab=[ManFactory createLabelWithFrame:CGRectMake(50, 20,200, 18) Font:15 Text:@"联系客服  010-57173598"];
    linkLab.center=CGPointMake(DEF_SCEEN_WIDTH/2,30 );
    linkLab.textAlignment=NSTextAlignmentCenter;
//    linkLab.backgroundColor=[UIColor orangeColor];
    linkLab.textColor=[UIColor colorWithRed:0.18 green:0.81 blue:0.89 alpha:1];
    UIImageView *linkIcon=[ManFactory createImageViewWithFrame:CGRectMake(linkLab.right, linkLab.top, linkLab.height, linkLab.height) ImageName:@"icon_kefu"];
    
    UIView *tapView=[[UIView alloc]initWithFrame:CGRectMake(linkLab.left, linkLab.top, linkLab.width+linkLab.height, linkLab.height)];
    tapView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callKe)];
    [tapView addGestureRecognizer:tap];
    
    [footView addSubview:linkLab];
    [footView addSubview:linkIcon];
    [footView addSubview:tapView];

    _mytable.tableFooterView = footView;


}
- (void)msgCenter{
   
    SCMsgListVC *mytask = [[SCMsgListVC alloc] initWithNibName:@"SCMsgListVC" bundle:nil];
    [self.navigationController pushViewController:mytask animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showTabBar];
    _user = [[User alloc] init];

    [_mytable reloadData];

        if (_user.isLogin){
            [self getMyInfo];
            [self getmsgCount];
            
        }else {
        _lab_name.text = @"";
        _lab_phone.text = @"";
        _lab_allmoney.text =@"¥0.00";
        _headImage.image = [UIImage imageNamed:@"icon_usermorentu"];
        }

}
-(void)viewDidAppear:(BOOL)animated{
    
    if (!_user.isLogin){
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
        return;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130;
    }
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArr[section]count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (indexPath.section == 0) {
        if (!_headImage) {
            _headImage = [[UIImageView alloc] init];
            _headImage.layer.masksToBounds = YES;
            _headImage.layer.cornerRadius  = 3;
            _headImage.image = [UIImage imageNamed:@"icon_usermorentu"];
            [cell.contentView addSubview:_headImage];
        }
        
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(10);
            make.top.equalTo(cell.contentView).with.offset(10);
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(60);
        }];
        
        if (!phoneStr){
            phoneStr = [[UILabel alloc] init];
            phoneStr.font = [UIFont systemFontOfSize:14];
            phoneStr.textColor = UIColorFromRGB(0x888888);
            phoneStr.text = @"账号";
            [cell.contentView addSubview:phoneStr];
        }
        
        if (!nameStr) {
            nameStr = [[UILabel alloc] init];
            nameStr.font = [UIFont systemFontOfSize:14];
            nameStr.textColor = UIColorFromRGB(0x888888);
            nameStr.text = @"姓名";
            [cell.contentView addSubview:nameStr];
        }
       

        [phoneStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImage.mas_right).offset(10);
            make.top.equalTo(cell.contentView).with.offset(10);
            make.height.mas_equalTo(30);
        }];
        [nameStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImage.mas_right).offset(10);
            make.top.mas_equalTo(phoneStr.mas_bottom).offset(0);
            make.height.mas_equalTo(30);
        }];
        
        if (!_lab_name) {
            _lab_name = [[UILabel alloc] init];
            _lab_name.font = [UIFont systemFontOfSize:14];
            _lab_name.textColor = UIColorFromRGB(0x333333);
            [cell.contentView addSubview:_lab_name];
        }
        
        if (!_lab_phone) {
            _lab_phone = [[UILabel alloc] init];
            _lab_phone.font = [UIFont systemFontOfSize:14];
            _lab_phone.textColor = UIColorFromRGB(0x333333);
            [cell.contentView addSubview:_lab_phone];
        }
        
        
        [_lab_phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(phoneStr.mas_right).offset(15);
            make.top.equalTo(cell.contentView).with.offset(10);
            make.height.mas_equalTo(30);
        }];
        
        
        
        [_lab_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameStr.mas_right).offset(15);
            make.top.mas_equalTo(phoneStr.mas_bottom).offset(0);
            make.height.mas_equalTo(30);
        }];
        
        if (!_lab_toLogin) {
            _lab_toLogin = [[UILabel alloc] init];
            _lab_toLogin.text=@"去登录";
            _lab_toLogin.textAlignment=NSTextAlignmentCenter;
//            _lab_toLogin.backgroundColor=[UIColor orangeColor];
            _lab_toLogin.font = [UIFont systemFontOfSize:15];
            _lab_toLogin.textColor = UIColorFromRGB(0x333333);
            [cell.contentView addSubview:_lab_toLogin];
        }
        
        [_lab_toLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImage.mas_right).offset(10);
            make.right.equalTo(cell.contentView).with.offset(-50);
            
            make.top.equalTo(cell.contentView).with.offset(0);
            make.bottom.equalTo(cell.contentView).with.offset(-40);
        }];

        
        if(_user.isLogin){
        
            [_lab_toLogin setHidden:YES];
            [_lab_name setHidden:NO];
            [_lab_phone setHidden:NO];
            [phoneStr setHidden:NO];
            [nameStr setHidden:NO];
            
        }else{
            [_lab_toLogin setHidden:NO];
            [_lab_name setHidden:YES];
            [_lab_phone setHidden:YES];
            [phoneStr setHidden:YES];
            [nameStr setHidden:YES];
        }
        
        if (!_view1) {
            _view1 = [[UIView alloc] init];
            _view1.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
            [_view1 addGestureRecognizer:tap];
            //        view1.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
            //        view1.layer.borderWidth = 0.5;
            [cell.contentView addSubview:_view1];
        }
        
        

        
        UIView *view2 = [[UIView alloc] init];
//        view2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
//        view2.layer.borderWidth = 0.5;
        [cell.contentView addSubview:view2];
        
        UIView *view3 = [[UIView alloc] init];
//        view3.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
//        view3.layer.borderWidth = 0.5;
        [cell.contentView addSubview:view3];
        

        
        
        [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).with.offset(0);
            make.height.equalTo(@40);
            make.right.mas_equalTo(cell.contentView);
        }];
//        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(cell.contentView);
//            make.left.mas_equalTo(view1.mas_right);
//            make.height.equalTo(@40);
//            make.right.mas_equalTo(view3.mas_left);
//            make.width.equalTo(@[view1,view3]);
//        }];
//        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(cell.contentView);
//            make.left.mas_equalTo(view2.mas_right);
//            make.height.equalTo(@40);
//            make.right.equalTo(cell.contentView);
//            make.width.equalTo(@[view2,view1]);
//        }];
        
        
        UIView *lineViewTop = [[UIView alloc] init];
        lineViewTop.alpha = 0.5;
        lineViewTop.backgroundColor = UIColorFromRGB(0x888888);
        [cell.contentView addSubview:lineViewTop];
        
        [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.bottom.mas_equalTo(_view1.mas_top);
        }];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.alpha = 0.5;
        lineView1.backgroundColor = UIColorFromRGB(0x888888);
        [cell.contentView addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_view1.mas_top);
            make.bottom.mas_equalTo(_view1.mas_bottom);
            make.width.equalTo(@0.5);
            make.left.mas_equalTo(_view1.mas_right);
        }];
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = UIColorFromRGB(0x888888);
        lineView2.alpha = 0.5;
        [cell.contentView addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_view1.mas_top);
            make.bottom.mas_equalTo(_view1.mas_bottom);
            make.width.equalTo(@0.5);
            make.left.mas_equalTo(view2.mas_right);
        }];
        
        if (!_lab_wodeyue) {
            _lab_wodeyue = [[UILabel alloc] init];
            _lab_wodeyue.text = @"我的余额";
            //        _lab_wodeyue.textAlignment = NSTextAlignmentCenter;
            _lab_wodeyue.textColor = UIColorFromRGB(0x333333);
            _lab_wodeyue.font = [UIFont systemFontOfSize:15];
            [_view1 addSubview:_lab_wodeyue];
        }
       
        
//        UILabel *lab2 = [[UILabel alloc] init];
//        lab2.text = @"可提现";
//        lab2.textAlignment = NSTextAlignmentCenter;
//        lab2.textColor = UIColorFromRGB(0x333333);
//        lab2.font = [UIFont systemFontOfSize:14];
//        [view2 addSubview:lab2];
//        
//        UILabel *lab3 = [[UILabel alloc] init];
//        lab3.text = @"提现中";
//        lab3.textAlignment = NSTextAlignmentCenter;
//        lab3.textColor = UIColorFromRGB(0x333333);
//        lab3.font = [UIFont systemFontOfSize:14];
//        [view3 addSubview:lab3];
        
        [_lab_wodeyue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_view1);
            make.bottom.equalTo(_view1);
            make.left.equalTo(_view1).offset(10);
            make.width.equalTo(@70);
        }];
//        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@20);
//            make.bottom.equalTo(view2);
//            make.left.equalTo(view2);
//            make.right.equalTo(view2);
//        }];
//        [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@20);
//            make.bottom.equalTo(view3);
//            make.left.equalTo(view3);
//            make.right.equalTo(view3);
//        }];
        
        if (!_lab_allmoney) {
            _lab_allmoney = [[UILabel alloc] init];
            //        _lab_allmoney.textAlignment = NSTextAlignmentCenter;
            _lab_allmoney.textColor = UIColorFromRGB(0xf7585d);
            _lab_allmoney.font = [UIFont systemFontOfSize:18];
            [_view1 addSubview:_lab_allmoney];
        }
       
        
        if (!_moneyBtn) {
            _moneyBtn=[[UIButton alloc]init];
            _moneyBtn.layer.cornerRadius=3;
            _moneyBtn.layer.borderWidth=0.5;
            _moneyBtn.layer.borderColor=[UIColor colorWithRed:0.18 green:0.81 blue:0.89 alpha:1].CGColor;
            [_moneyBtn setTitle:@"提现" forState:UIControlStateNormal];
            [_moneyBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [_moneyBtn setTitleColor:[UIColor colorWithRed:0.18 green:0.81 blue:0.89 alpha:1]  forState:UIControlStateNormal];
            [_moneyBtn addTarget:self action:@selector(getMoney) forControlEvents:UIControlEventTouchUpInside];
            [_view1 addSubview:_moneyBtn];
        }
        
        _lab_ketixian = [[UILabel alloc] init];
        _lab_ketixian.textAlignment = NSTextAlignmentCenter;
        _lab_ketixian.textColor = UIColorFromRGB(0xf7585d);
        _lab_ketixian.font = [UIFont systemFontOfSize:14];
        [view2 addSubview:_lab_ketixian];
        _lab_tixianzhong = [[UILabel alloc] init];
        _lab_tixianzhong.textAlignment = NSTextAlignmentCenter;
        _lab_tixianzhong.textColor = UIColorFromRGB(0xf7585d);
        _lab_tixianzhong.font = [UIFont systemFontOfSize:14];
        [view3 addSubview:_lab_tixianzhong];
        
        [_lab_allmoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_view1);
            make.top.equalTo(_view1);
            make.left.equalTo(_lab_wodeyue.mas_right);
            make.right.equalTo(_view1);
        }];
        
        [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@28);
            make.centerY.equalTo(_view1);
            make.width.equalTo(@70);
            make.right.equalTo(_view1).with.offset(-15);
        }];
        
        [_lab_ketixian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.top.equalTo(view2);
            make.left.equalTo(view2);
            make.right.equalTo(view2);
        }];
        [_lab_tixianzhong mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.top.equalTo(view3);
            make.left.equalTo(view3);
            make.right.equalTo(view3);
        }];
        
        UIImageView *img_right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right"]];
        [cell.contentView addSubview:img_right];
        [img_right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_headImage);
            make.right.equalTo(cell.contentView).with.offset(-10);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
        
    }else{
        cell.textLabel.text  = [_titleArr objectAtIndex:indexPath.section][indexPath.row];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        UIImageView *img_right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right"]];
        cell.imageView.image = [UIImage imageNamed:[_imageArr objectAtIndex:indexPath.section][indexPath.row]];
        img_right.frame = CGRectMake(0, 0, 10, 10);
        cell.accessoryView = img_right;
        if (indexPath.section == 5) {
            cell.detailTextLabel.text = @"010-57173598";
        }
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if(_user.isLogin){
            MyInfoViewController *myinfo = [[MyInfoViewController alloc] init];
            [self.navigationController pushViewController:myinfo animated:YES];
        }else{
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row==0) {
            BillDetailViewController *billVC=[[BillDetailViewController alloc]init];
            [self.navigationController pushViewController:billVC animated:YES];
        }else if(indexPath.row==1){
            
            [self getPartnerInfo];
            
            
        }else{
            TaskDListViewController *TaskDetailV = [[TaskDListViewController alloc] init];
            [self.navigationController pushViewController:TaskDetailV animated:YES];
        }
 
    }else if (indexPath.section == 2){
        HelpCenterViewController *help = [[HelpCenterViewController alloc] init];
        [self.navigationController pushViewController:help animated:YES];

    }else if (indexPath.section == 3){
        SysemViewController *sys = [[SysemViewController alloc] init];
        [self.navigationController pushViewController:sys animated:YES];

    }else if (indexPath.section == 4){

        [self callKe];
    }
}

-(void)getPartnerInfo{
    
    
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{@"userId": _user.userId};
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    parameters=[parameters security];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_getpartnerinfo] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
            
            PartnerViewController *partner=[[PartnerViewController alloc]initWithNibName:@"PartnerViewController" bundle:nil];
            
            partner.partnerNum__=[[[responseObject objectForKey:@"data"] objectForKey:@"partnerNum"]description];
            partner.recommendPhone__=[[responseObject objectForKey:@"data"] objectForKey:@"recommendPhone"];
            partner.bonusTotal__=[[[responseObject objectForKey:@"data"] objectForKey:@"bonusTotal"]description];

            
            [self.navigationController pushViewController:partner animated:YES];
            
        }else{
//            
//            [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:[responseObject objectForKey:@"msg"] offsetY:-100 failClickBlock:^{
//            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"请检查网络设置" offsetY:-100 failClickBlock:^{
//        }];
    }];


}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getMyInfo{
    
    
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{@"userId": _user.userId};
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    parameters=[parameters security];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

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
//            NSString *fullHeadImage=[[responseObject objectForKey:@"data"] objectForKey:@"fullHeadImage"];
//            if([fullHeadImage isKindOfClass:[NSNull class]]||fullHeadImage==nil){
//                fullHeadImage=@"";
//                };
            
            _user.fullHeadImage =[[responseObject objectForKey:@"data"] objectForKey:@"fullHeadImage"];
            
            _user.totalAmount   = [[[responseObject objectForKey:@"data"] objectForKey:@"totalAmount"] floatValue];//累计金额
            _user.withdraw   = [[[responseObject objectForKey:@"data"] objectForKey:@"withdraw"] floatValue];//可以体现的金额
            
            _user.accountType   =[[[responseObject objectForKey:@"data"] objectForKey:@"accountType"] intValue];
            _user.accountNo =[[responseObject objectForKey:@"data"] objectForKey:@"accountNo"];
            _user.trueName =[[responseObject objectForKey:@"data"] objectForKey:@"trueName"];

            
            _lab_name.text = _user.userName;
            _lab_phone.text = _user.userPhoneNo;
            _lab_allmoney.text = [NSString stringWithFormat:@"¥%.2f",_user.balance];
//            _lab_ketixian.text = [NSString stringWithFormat:@"¥%.2f",_user.withdraw];
//            _lab_tixianzhong.text = [NSString stringWithFormat:@"¥%.2f",_user.withdrawing];

            NSURL *myUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_user.fullHeadImage]];
            if (_user.fullHeadImage.length != 0) {
                NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
                NSData *myData = [dd objectForKey:@"userimage"];
                if (myData.length == 0) {
                    [_headImage sd_setImageWithURL:myUrl placeholderImage:nil options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            _headImage.image = [UIImage imageNamed:@"icon_usermorentu"];
                        }else{
                            [dd setValue:UIImagePNGRepresentation(image) forKey:@"userimage"];
                        }
                    }];
                }else{
                    [_headImage sd_setImageWithURL:myUrl placeholderImage:[UIImage imageWithData:myData] options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            _headImage.image = [UIImage imageWithData:myData];
                        }else{
                            [dd setValue:UIImagePNGRepresentation(image) forKey:@"userimage"];
                        }
                    }];
                }
            }else{
                _headImage.image = [UIImage imageNamed:@"icon_usermorentu"];
            }


            
        }else{
            
            [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:[responseObject objectForKey:@"msg"] offsetY:-100 failClickBlock:^{
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"请检查网络设置" offsetY:-100 failClickBlock:^{
        }];
    }];
}

-(void)getmsgCount{

    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app getmsgCount];

}

-(void)NewMessageNotify:(NSNotification *)notif{

    if ([notif.object boolValue]) [self setMsgRightBTNItem];
    else [self setNoMsgRightBTNItem];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

}
-(void)setNoMsgRightBTNItem{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NoMsgRightBTNItem"] style:UIBarButtonItemStylePlain target:self action:@selector(msgCenter)];

}
-(void)setMsgRightBTNItem{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"MsgRightBTNItem"] style:UIBarButtonItemStylePlain target:self action:@selector(msgCenter)];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self callKe];
    }
}

-(void)viewTap{


}
-(void)getMoney{
    
    if (_user.balance <10.0f) {
        [self postAlertWithMsg:@"余额不足10元，暂时不能提现"];
        return;
    }
    WithDrawViewController *withDraw = [[WithDrawViewController alloc] init];
    [self.navigationController pushViewController:withDraw animated:YES];
}
- (void)callKe{
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://010-57173598"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
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
