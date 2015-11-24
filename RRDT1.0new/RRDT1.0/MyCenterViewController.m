
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

#import "SysemViewController.h"

#import "HelpCenterViewController.h"

#import "MyTaskViewController.h"

@interface MyCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    User *_user;
    
    UIView *lineView0;
    
}
@property (nonatomic,strong)UITableView *mytable;

@property (nonatomic,strong)NSArray *imageArr;

@property (nonatomic,strong)NSArray *titleArr;

@property (nonatomic,strong)UILabel *lab_phone;
@property (nonatomic,strong)UILabel *lab_name;

@property (nonatomic,strong)UIImageView *headImage;

@property (nonatomic,strong)UILabel *lab_allmoney;
@property (nonatomic,strong)UILabel *lab_ketixian;
@property (nonatomic,strong)UILabel *lab_tixianzhong;

@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
}
- (void)viewCreat{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"0xffffff" alpha:0.8]];
    
    
    self.view.backgroundColor = UIColorFromRGB(0xf9f9f9);
    
    _user = [[User alloc] init];
    
    self.title = @"个人中心";
    
    _imageArr = @[@"0",@"icon_tixian",@"icon_wancheng",@"icon_helpcenter",@"icon_kefu"];
    _titleArr = @[@"0",@"提现",@"已完成任务",@"帮助中心",@"客服支持"];
    
    _mytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    [self.view addSubview:_mytable];
    _mytable.showsHorizontalScrollIndicator = NO;
    _mytable.showsVerticalScrollIndicator = NO;
    _mytable.tableFooterView = [UIView new];

}
- (void)more{
    SysemViewController *sys = [[SysemViewController alloc] init];
    [self.navigationController pushViewController:sys animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"请检查网络设置" offsetY:-100 failClickBlock:^{
            NSLog(@"?>?>>>>>??>?>");
            [self getMyInfo];
        }];
    }else{
        [self getMyInfo];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130;
    }
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (indexPath.section == 0) {
        _headImage = [[UIImageView alloc] init];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius  = 3;
        [cell.contentView addSubview:_headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(10);
            make.top.equalTo(cell.contentView).with.offset(10);
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(60);
        }];
        
        UILabel *phoneStr = [[UILabel alloc] init];
        phoneStr.font = [UIFont systemFontOfSize:14];
        phoneStr.textColor = UIColorFromRGB(0x888888);
        phoneStr.text = @"账号";
        [cell.contentView addSubview:phoneStr];
        
        UILabel *nameStr = [[UILabel alloc] init];
        nameStr.font = [UIFont systemFontOfSize:14];
        nameStr.textColor = UIColorFromRGB(0x888888);
        nameStr.text = @"姓名";
        [cell.contentView addSubview:nameStr];

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
        _lab_name = [[UILabel alloc] init];
        _lab_name.font = [UIFont systemFontOfSize:14];
        _lab_name.textColor = UIColorFromRGB(0x333333);
        [cell.contentView addSubview:_lab_name];
        _lab_phone = [[UILabel alloc] init];
        _lab_phone.font = [UIFont systemFontOfSize:14];
        _lab_phone.textColor = UIColorFromRGB(0x333333);
        [cell.contentView addSubview:_lab_phone];
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
        
        UIView *view1 = [[UIView alloc] init];
//        view1.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
//        view1.layer.borderWidth = 0.5;
        [cell.contentView addSubview:view1];
        
        UIView *view2 = [[UIView alloc] init];
//        view2.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
//        view2.layer.borderWidth = 0.5;
        [cell.contentView addSubview:view2];
        
        UIView *view3 = [[UIView alloc] init];
//        view3.layer.borderColor = UIColorFromRGB(0x888888).CGColor;
//        view3.layer.borderWidth = 0.5;
        [cell.contentView addSubview:view3];
        

        
        
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).with.offset(0);
            make.height.equalTo(@40);
            make.right.mas_equalTo(view2.mas_left);
            make.width.equalTo(@[view2,view3]);
        }];
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(view1.mas_right);
            make.height.equalTo(@40);
            make.right.mas_equalTo(view3.mas_left);
            make.width.equalTo(@[view1,view3]);
        }];
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(view2.mas_right);
            make.height.equalTo(@40);
            make.right.equalTo(cell.contentView);
            make.width.equalTo(@[view2,view1]);
        }];
        
        
        UIView *lineViewTop = [[UIView alloc] init];
        lineViewTop.alpha = 0.5;
        lineViewTop.backgroundColor = UIColorFromRGB(0x888888);
        [cell.contentView addSubview:lineViewTop];
        
        [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.bottom.mas_equalTo(view1.mas_top);
        }];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.alpha = 0.5;
        lineView1.backgroundColor = UIColorFromRGB(0x888888);
        [cell.contentView addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view1.mas_top);
            make.bottom.mas_equalTo(view1.mas_bottom);
            make.width.equalTo(@0.5);
            make.left.mas_equalTo(view1.mas_right);
        }];
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = UIColorFromRGB(0x888888);
        lineView2.alpha = 0.5;
        [cell.contentView addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view1.mas_top);
            make.bottom.mas_equalTo(view1.mas_bottom);
            make.width.equalTo(@0.5);
            make.left.mas_equalTo(view2.mas_right);
        }];
        
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.text = @"我的余额";
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.textColor = UIColorFromRGB(0x333333);
        lab1.font = [UIFont systemFontOfSize:14];
        [view1 addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc] init];
        lab2.text = @"可提现";
        lab2.textAlignment = NSTextAlignmentCenter;
        lab2.textColor = UIColorFromRGB(0x333333);
        lab2.font = [UIFont systemFontOfSize:14];
        [view2 addSubview:lab2];
        
        UILabel *lab3 = [[UILabel alloc] init];
        lab3.text = @"提现中";
        lab3.textAlignment = NSTextAlignmentCenter;
        lab3.textColor = UIColorFromRGB(0x333333);
        lab3.font = [UIFont systemFontOfSize:14];
        [view3 addSubview:lab3];
        
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.bottom.equalTo(view1);
            make.left.equalTo(view1);
            make.right.equalTo(view1);
        }];
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.bottom.equalTo(view2);
            make.left.equalTo(view2);
            make.right.equalTo(view2);
        }];
        [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.bottom.equalTo(view3);
            make.left.equalTo(view3);
            make.right.equalTo(view3);
        }];
        
        _lab_allmoney = [[UILabel alloc] init];
        _lab_allmoney.textAlignment = NSTextAlignmentCenter;
        _lab_allmoney.textColor = UIColorFromRGB(0xf7585d);
        _lab_allmoney.font = [UIFont systemFontOfSize:14];
        [view1 addSubview:_lab_allmoney];
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
            make.height.equalTo(@20);
            make.top.equalTo(view1);
            make.left.equalTo(view1);
            make.right.equalTo(view1);
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
        cell.textLabel.text  = [_titleArr objectAtIndex:indexPath.section];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        UIImageView *img_right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right"]];
        cell.imageView.image = [UIImage imageNamed:[_imageArr objectAtIndex:indexPath.section]];
        img_right.frame = CGRectMake(0, 0, 10, 10);
        cell.accessoryView = img_right;
        if (indexPath.section == 4) {
            cell.detailTextLabel.text = @"4006-380-177";
        }
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        MyInfoViewController *myinfo = [[MyInfoViewController alloc] init];
        [self.navigationController pushViewController:myinfo animated:YES];
    }else if (indexPath.section == 1){
        WithDrawViewController *withDraw = [[WithDrawViewController alloc] init];
        [self.navigationController pushViewController:withDraw animated:YES];
    }else if (indexPath.section == 2){
        MyTaskViewController *mytask = [[MyTaskViewController alloc] init];
        [self.navigationController pushViewController:mytask animated:YES];
    }else if (indexPath.section == 3){
        HelpCenterViewController *help = [[HelpCenterViewController alloc] init];
        [self.navigationController pushViewController:help animated:YES];

    }else if (indexPath.section == 4){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"4006-380-177" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
//        [alert show];
        [self callKe];
    }
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getMyInfo{
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{@"userId": _user.userId};
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_MyInmoney] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
            
            _user.userName      = [[responseObject objectForKey:@"data"] objectForKey:@"userName"];//用户名
            _user.userPhoneNo   = [[responseObject objectForKey:@"data"] objectForKey:@"phoneNo"];
            _user.balance       = [[[responseObject objectForKey:@"data"] objectForKey:@"balance"] floatValue];//余额
            _user.withdrawing   = [[[responseObject objectForKey:@"data"] objectForKey:@"withdrawing"] floatValue];//提现中
            _user.fullHeadImage = [[responseObject objectForKey:@"data"] objectForKey:@"fullHeadImage"];
            _user.withdraw      = [[[responseObject objectForKey:@"data"] objectForKey:@"withdraw"] floatValue];

            
            
            _lab_name.text = _user.userName;
            _lab_phone.text = _user.userPhoneNo;
            _lab_allmoney.text = [NSString stringWithFormat:@"¥%.2f",_user.balance];
            _lab_ketixian.text = [NSString stringWithFormat:@"¥%.2f",_user.withdraw];
            _lab_tixianzhong.text = [NSString stringWithFormat:@"¥%.2f",_user.withdrawing];

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
                [self getMyInfo];
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"请检查网络设置" offsetY:-100 failClickBlock:^{
            [self getMyInfo];
        }];
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self callKe];
    }
}
- (void)callKe{
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://4006380177"];
    
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
