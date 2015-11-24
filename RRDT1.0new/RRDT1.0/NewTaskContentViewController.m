//
//  NewTaskContentViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "NewTaskContentViewController.h"

#import "CoreLabel.h"

#import "CoreStatusBtn.h"

#import "LoginViewController.h"

#import "PostContractViewController.h"

#import "CurrentTaskViewController.h"

@interface NewTaskContentViewController ()<UITableViewDataSource,UITableViewDelegate,ContractContentDele>
{
    User *user;
}
//@property (nonatomic,strong) NSString *orderID;

@property (nonatomic,strong) UITableView *mytable;

@property (nonatomic,strong) NSMutableArray *contentArr;


/**
 主照片
 */
@property (nonatomic,strong) UIImageView    *headImageView;
/**
 标题
 */
@property (nonatomic,strong) UILabel        *headLabel;
/**
 状态
 */
@property (nonatomic,strong) CoreLabel        *statusLabel;
/**
 时间
 */
@property (nonatomic,strong) CoreLabel        *timeLabel;
/**
 金额
 */
@property (nonatomic,strong) CoreLabel      *moneyLab;
/**
 lineLAB
 */
@property (nonatomic,strong) UILabel        *line_label;



@property (nonatomic,strong) UILabel    *lab1;//1-1

@property (nonatomic,strong) UILabel    *lab2;//1-2

@property (nonatomic,strong) UILabel    *lab3;//2-1

@property (nonatomic,strong) UILabel    *lab4;//2-2

@property (nonatomic,strong) UIImageView    *img1;//1-1

@property (nonatomic,strong) UIImageView    *img2;//1-2

@property (nonatomic,strong) UIImageView    *img3;//2-1

@property (nonatomic,strong) UIImageView    *img4;//2-2

/** 领取任务按钮 */
@property (nonatomic,strong) CoreStatusBtn *btn_receive;
/** 放弃任务按钮 */
@property (nonatomic,strong) CoreStatusBtn *btn_giveup;
/** 再次领取任务按钮 */
@property (nonatomic,strong) CoreStatusBtn *btn_againReceive;
/** 提交合同任务按钮 */
@property (nonatomic,strong) UIButton *btn_post;
/** 查看资料 */
@property (nonatomic,strong) UIButton *btn_lookPost;

@end

@implementation NewTaskContentViewController

- (void)backPostContract{
    NSLog(@">>>>走了");
    _type = 1;
    [self judegMent];
    [self getTaskContent:_task.orderId];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self viewCreat];
    user = [[User alloc] init];
    
    self.title = @"任务详情";
    
    
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"请检查网络设置" offsetY:-100 failClickBlock:^{
            [self getTaskContent:_task.orderId];
        }];
    }else{
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self getTaskContent:_task.orderId];
        

    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
}
- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewCreat{
    _contentArr = [NSMutableArray array];
    _mytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.showsVerticalScrollIndicator = NO;
    _mytable.showsHorizontalScrollIndicator = NO;
    _mytable.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [self.view addSubview:_mytable];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/15 + 40)];
    
    
    [footView addSubview:[self btn_againReceive]];
    [footView addSubview:[self btn_giveup]];
    [footView addSubview:[self btn_lookPost]];
    [footView addSubview:[self btn_post]];
    [footView addSubview:[self btn_receive]];
    _mytable.tableFooterView = footView;
    
    [self judegMent];

}
#pragma mark 判断页面类型
- (void)judegMent{
    if (_type == 1) {
        _btn_receive.hidden = NO;
        
        _btn_post.hidden = YES;
        _btn_lookPost.hidden = YES;
        _btn_giveup.hidden = YES;
        _btn_againReceive.hidden = YES;
        
        _timeLabel.hidden = YES;
    }else if (_type == 2){
        _btn_giveup.hidden = NO;
        [_btn_post setTitle:@"提交审核" forState:UIControlStateNormal];
        _btn_post.tag = 111;
        _btn_post.hidden = NO;
        
        _btn_againReceive.hidden = YES;
        _btn_lookPost.hidden = YES;
        _btn_receive.hidden = YES;
        
        _timeLabel.hidden = NO;
        
    }else if (_type == 3){
        _btn_lookPost.hidden = NO;
        _btn_againReceive.hidden = NO;
        
        _btn_post.hidden = YES;
        _btn_giveup.hidden = YES;
        _btn_receive.hidden = YES;
        _timeLabel.hidden = YES;
    }else if (_type == 4){
        _btn_giveup.hidden = NO;
        [_btn_post setTitle:@"重新提交" forState:UIControlStateNormal];
        _btn_post.tag = 222;
        _btn_post.hidden = NO;
        
        _btn_lookPost.hidden = YES;
        _btn_receive.hidden = YES;
        _btn_againReceive.hidden = YES;
        _timeLabel.hidden = YES;
    }else if (_type == 5){
        _btn_lookPost.hidden = NO;
        _btn_againReceive.hidden = NO;
        
        _btn_giveup.hidden = YES;
        _btn_post.hidden = YES;
        _btn_receive.hidden = YES;
        _timeLabel.hidden = YES;
    }else{
        
        _btn_lookPost.hidden = YES;
        _btn_againReceive.hidden = YES;
        _btn_giveup.hidden = YES;
        _btn_post.hidden = YES;
        _btn_receive.hidden = YES;
        _timeLabel.hidden = YES;
    }
    
    
    
}
#pragma mark 获取任务详情
- (void)getTaskContent:(NSString *)orderIDstr{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    
    NSLog(@">?>>>>*%@",user.userId);
    NSLog(@">>>>#%@",_task.taskId);

    NSDictionary *parmeters = @{@"userId"       :user.isLogin?user.userId:@"0",
                                @"taskId"       :_task.taskId,
                                @"orderId"      :orderIDstr
                                };
    NSLog(@"%@",parmeters);
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_TaskContent] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"---->>>>>%@",responseObject);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 200) {
//            [self viewCreat];
            
            
            [self successView:[responseObject objectForKey:@"data"]];
            
            [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
//            _orderID = [[responseObject objectForKey:@"data"] objectForKey:@"orderId"];
            
        }else{
            NSLog(@">>>>>>%@",[responseObject objectForKey:@"msg"]);
            [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:[responseObject objectForKey:@"msg"] offsetY:-100 failClickBlock:^{
                [self getTaskContent:_task.orderId];
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"未知错误" offsetY:-100 failClickBlock:^{
            [self getTaskContent:_task.orderId];
        }];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark uitable代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionP{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _contentArr.count;
//    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            [cell.contentView addSubview:[self headImageView]];
            [cell.contentView addSubview:[self headLabel]];
            [cell.contentView addSubview:[self statusLabel]];
            [cell.contentView addSubview:[self moneyLab]];
            [cell.contentView addSubview:[self line_label]];
            
            [cell.contentView addSubview:[self lab1]];
            [cell.contentView addSubview:[self lab2]];
            [cell.contentView addSubview:[self lab3]];
            [cell.contentView addSubview:[self lab4]];
            
            [cell.contentView addSubview:[self img1]];
            [cell.contentView addSubview:[self img2]];
            [cell.contentView addSubview:[self img3]];
            [cell.contentView addSubview:[self img4]];
            
            
            [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(15);
                make.left.equalTo(cell.contentView).with.offset(12);
                make.width.equalTo(@60);
                make.height.equalTo(@60);
            }];
            
            [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(15);
                make.left.mas_equalTo(_headImageView.mas_right).offset(12);
                make.right.equalTo(cell.contentView).with.offset(-12);
                make.height.mas_equalTo(20);
            }];
            [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_headLabel.mas_bottom);
                make.left.mas_equalTo(_headImageView.mas_right).offset(12);
                make.right.equalTo(cell.contentView).with.offset(-12);
                make.height.mas_equalTo(20);
            }];
            [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_headLabel.mas_bottom);
                make.right.equalTo(cell.contentView).with.offset(-10);
                make.width.mas_equalTo(100);
                make.height.equalTo(@20);
            }];
            [_line_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).with.offset(12);
                make.right.equalTo(cell.contentView).with.offset(-12);
                make.top.mas_equalTo(_headImageView.mas_bottom).offset(10);
                make.height.equalTo(@1);
            }];

            
            [_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
                make.left.mas_equalTo(_img1.mas_right).offset(5);
                make.height.equalTo(@15);
            }];
            [_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
                make.left.mas_equalTo(_img2.mas_right).offset(5);
                make.height.equalTo(@15);
            }];
            
            [_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_lab1.mas_bottom).offset(5);
                make.left.mas_equalTo(_img3.mas_right).offset(5);
                make.height.equalTo(@15);
            }];
            [_lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_lab1.mas_bottom).offset(5);
                make.left.mas_equalTo(_lab2.mas_left);
                make.height.equalTo(@15);
            }];
            
            
            [_img1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
                make.left.equalTo(cell.contentView).with.offset(10);
                make.width.equalTo(@15);
                make.height.equalTo(@15);
            }];
            [_img2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
                make.left.mas_equalTo(_lab1.mas_right).offset(40);
                make.width.equalTo(@15);
                make.height.equalTo(@15);
            }];
            [_img3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_img1.mas_bottom).offset(5);
                make.left.equalTo(cell.contentView).with.offset(10);
                make.width.equalTo(@15);
                make.height.equalTo(@15);
            }];
            [_img4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_img1.mas_bottom).offset(5);
                make.left.mas_equalTo(_img2.mas_left);
                make.width.equalTo(@15);
                make.height.equalTo(@15);
            }];

            
            
        }else if (indexPath.section == 1){
            UILabel *infolab = [[UILabel alloc] init];
            infolab.font = [UIFont systemFontOfSize:12];
            infolab.textColor = UIColorFromRGB(0x333333);
            infolab.text = [_contentArr objectAtIndex:1];
            infolab.numberOfLines = 0;
            [cell.contentView addSubview:infolab];
            [infolab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(0);
                make.left.equalTo(cell.contentView).with.offset(10);
                make.right.equalTo(cell.contentView).with.offset(-10);
                make.bottom.equalTo(cell.contentView).with.offset(-0);
            }];
        }else{
            UILabel *titileLab = [[UILabel alloc] init];
            titileLab.font = [UIFont systemFontOfSize:15];
            titileLab.textColor = UIColorFromRGB(0x333333);
            if (indexPath.section == 2) {
                titileLab.text = @"任务流程";
            }else if (indexPath.section == 3){
                titileLab.text = @"注意事项";
            }else if (indexPath.section == 4){
                titileLab.text = @"公司介绍";
            }
            [cell.contentView addSubview:titileLab];
            [titileLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(10);
                make.left.equalTo(cell.contentView).with.offset(10);
                make.right.equalTo(cell.contentView).with.offset(-10);
                make.height.equalTo(@20);
            }];
            
            UILabel *infolab = [[UILabel alloc] init];
            infolab.font = [UIFont systemFontOfSize:12];
            infolab.textColor = UIColorFromRGB(0x666666);
            infolab.text = [_contentArr objectAtIndex:indexPath.section];
            infolab.numberOfLines = 0;
            [cell.contentView addSubview:infolab];
            
//            CGSize size = [[_contentArr objectAtIndex:indexPath.section] boundingRectWithSize:CGSizeMake(WIDTH-20, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
//            int height = size.height;
//            NSLog(@"height >>>%@>>> %zi",[_contentArr objectAtIndex:indexPath.section],height);
//            infolab.backgroundColor = [UIColor redColor];
            [infolab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(titileLab.mas_bottom);
                make.left.equalTo(cell.contentView).with.offset(10);
                make.right.equalTo(cell.contentView).with.offset(-10);
            }];
        }
    }
    
    if(indexPath.section == 0){
        
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_task.logo]] placeholderImage:[UIImage imageNamed:@"icon_morentu"] options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        _headLabel.text = _task.taskTitle;
        
        _moneyLab.textColor = [UIColor clearColor];
        _moneyLab.text = [NSString stringWithFormat:@"￥%.2f/次",_task.amount];
        [_moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(0,1)];
        [_moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(1,_moneyLab.text.length - 3)];
        [_moneyLab addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:10] range:NSMakeRange(_moneyLab.text.length - 2,2)];
        [_moneyLab addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(0,_moneyLab.text.length - 2)];
        [_moneyLab addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(_moneyLab.text.length - 2,2)];
        
        
        NSString *status ;
        if (_type == 1) {
            status = @"待领取";
        }else if (_type == 2){
            status = @"已领取";
        }else if (_type == 3){
            status = @"审核中";
        }else if (_type == 4){
            status = @"未通过";
        }else if (_type == 5){
            status = @"审核通过";
        }else if (_type == 6){
            status = @"已失效";
        }else if (_type == 7){
            status = @"已取消";
        }
        _statusLabel.text = [NSString stringWithFormat:@"状态：%@",status];
        [_statusLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xbbc0c7) range:NSMakeRange(0, 3)];
        [_statusLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x333333) range:NSMakeRange(3, 3)];

        if (_type == 1) {
            _lab1.text = [NSString stringWithFormat:@"可领 %@次",_task.availableCount];
            _lab2.text = [NSString stringWithFormat:@"完成时间 %@小时",_task.taskCycle];
            _lab3.text = [NSString stringWithFormat:@"审核 %@天",_task.auditCycle];
            _lab4.text = [NSString stringWithFormat:@"结束时间 %@",[_task.endTime substringWithRange:NSMakeRange(0, 16)]];
        }else if (_type == 2){
            _lab1.text = [NSString stringWithFormat:@"可领 %@次",_task.availableCount];
            _lab2.text = [NSString stringWithFormat:@"%@",[self timeFinsh:[_task.receivedTime substringToIndex:19] andCycle:_task.taskCycle]];
            _lab3.text = [NSString stringWithFormat:@"审核 %@天",_task.auditCycle];
            _lab4.text = [NSString stringWithFormat:@"结束时间 %@",[_task.endTime substringWithRange:NSMakeRange(0, 16)]];
        }else if (_type == 3){
            _lab1.text = [NSString stringWithFormat:@"可领 %@次",_task.availableCount];
            _lab2.text = [NSString stringWithFormat:@"%@",[self timeHelper:[_task.endTime substringWithRange:NSMakeRange(0, 19)]]];
            _lab3.text = [NSString stringWithFormat:@"审核 %@天",_task.auditCycle];
            _img4.hidden = YES;
        }else if (_type == 4){
            _lab1.text = [NSString stringWithFormat:@"可领 %@次",_task.availableCount];
            _lab2.text = [NSString stringWithFormat:@"%@",[self timeHelper:[_task.endTime substringWithRange:NSMakeRange(0, 19)]]];
            _lab3.text = [NSString stringWithFormat:@"审核 %@天",_task.auditCycle];
            _lab4.text = [NSString stringWithFormat:@"提交时间 %@",_task.finishTime==nil?@"未知":[_task.finishTime substringWithRange:NSMakeRange(0, 16)]];
        }else if (_type == 5 || _type == 6 || _type == 7){
            _lab1.text = [NSString stringWithFormat:@"可领 %@次",_task.availableCount];
            _lab2.text = [NSString stringWithFormat:@"%@",[self timeHelper:[_task.endTime substringWithRange:NSMakeRange(0, 19)]]];
            _lab3.text = [NSString stringWithFormat:@"审核 %@天",_task.auditCycle];
            _img4.hidden = YES;
        }
        if (_type!=1) {
            [cell.contentView addSubview:[self timeLabel]];
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_statusLabel.mas_bottom);
                make.left.mas_equalTo(_headImageView.mas_right).offset(12);
                make.right.equalTo(cell.contentView).with.offset(-12);
                make.height.mas_equalTo(20);
            }];
            if (_type == 2) {
                
                _timeLabel.text = [NSString stringWithFormat:@"领取时间：%@",_task.receivedTime == nil ? @"未知":[_task.receivedTime substringWithRange:NSMakeRange(0, 16)]];
                [_timeLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xbbc0c7) range:NSMakeRange(0, 5)];
                [_timeLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x333333) range:NSMakeRange(5, _timeLabel.text.length - 5)];
            }
            
//            else{
//                _timeLabel.text = [NSString stringWithFormat:@"审核时间：%@",[_task.auditTime substringWithRange:NSMakeRange(0, 16)]];
//                [_timeLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xbbc0c7) range:NSMakeRange(0, 5)];
//                [_timeLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x333333) range:NSMakeRange(5, _timeLabel.text.length - 5)];
//            }
            
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 140;
    }else if (indexPath.section == 1){
        CGSize size = [[_contentArr objectAtIndex:indexPath.section] boundingRectWithSize:CGSizeMake(WIDTH-20, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        return size.height + 10;
    }
    CGSize size = [[_contentArr objectAtIndex:indexPath.section] boundingRectWithSize:CGSizeMake(WIDTH-20, 20000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return size.height + 40;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 2) {
        return 1;
    }else{
        return 5;
    }
}
#pragma mark 成功获取任务详情之后 任务赋值
- (void)successView:(NSDictionary*)dic{
    
    _task.taskId            = [dic objectForKeyedSubscript:@"id"];
    _task.taskTitle         = [dic objectForKey:@"taskTitle"];
    _task.taskNotice        = [dic objectForKey:@"taskNotice"];
    _task.amount            = [[dic objectForKey:@"amount"] floatValue];
    _task.endTime           = [dic objectForKey:@"endTime"];
    _task.availableCount    = [dic objectForKey:@"availableCount"];
    _task.paymentMethod     = [dic objectForKey:@"paymentMethod"];
    _task.taskGeneralInfo   = [dic objectForKey:@"taskGeneralInfo"];
    _task.taskNote          = [dic objectForKey:@"taskNote"];
    _task.businessId        = [dic objectForKey:@"businessId"];
    _task.templateId        = [dic objectForKey:@"templateId"];
    _task.pusher            = [dic objectForKey:@"pusher"];
    _task.templateName      = [dic objectForKey:@"templateName"];
    _task.isHad             = [dic objectForKey:@"isHad"];
    _task.orderId           = [dic objectForKey:@"orderId"];
    NSLog(@"order>>>>>%@",_task.orderId);
    _task.logo              = [dic objectForKey:@"logo"];
    _task.companySummary    = [dic objectForKey:@"companySummary"];
    _task.auditCycle        = [dic objectForKey:@"auditCycle"];
    _task.controlInfo       = [dic objectForKey:@"controlInfo"];
    _task.taskCycle         = [dic objectForKey:@"taskCycle"];
    _task.finishTime        = [dic objectForKey:@"finishTime"];
    _task.receivedTime      = [dic objectForKey:@"receivedTime"];
    _task.isAgainPickUp     = [dic objectForKey:@"isAgainPickUp"];
    
    
    
    if (_type == 2) {
        _timeLabel.text = [NSString stringWithFormat:@"领取时间：%@",_task.receivedTime == nil ? @"未知":[_task.receivedTime substringWithRange:NSMakeRange(0, 16)]];
    }
    
    if ([_task.isAgainPickUp integerValue] == 0) {
        _btn_againReceive.enabled = NO;
        [_btn_againReceive setBackgroundColorForNormal:[UIColor grayColor]];
    }else{
        _btn_againReceive.enabled = YES;
        [_btn_againReceive setBackgroundColorForNormal:UIColorFromRGB(0x9a3b8)];
    }
    
    [_contentArr removeAllObjects];
    [_contentArr addObject:@"1"];
    [_contentArr addObject:_task.taskNotice];
    [_contentArr addObject:_task.taskGeneralInfo];
    [_contentArr addObject:_task.taskNote];
    [_contentArr addObject:_task.companySummary];
    [_mytable reloadData];
    
    NSLog(@">>>>>>%@",_contentArr);
    
    _headLabel.text = _task.taskTitle;
    _moneyLab.text = [NSString stringWithFormat:@"¥%.2f",_task.amount];

}
#pragma mark 懒加载
- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
    }
    return _headImageView;
}
- (UILabel *)headLabel{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] init];
        _headLabel.font = [UIFont systemFontOfSize:15];
        _headLabel.numberOfLines = 1;
    }
    return _headLabel;
}
- (CoreLabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[CoreLabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12];
    }
    return _statusLabel;
}
- (CoreLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel =[[CoreLabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
- (CoreLabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[CoreLabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLab;
}
- (UILabel *)line_label{
    if (!_line_label) {
        _line_label = [[UILabel alloc] init];
        _line_label.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _line_label;
}
- (UILabel *)lab1{
    if (!_lab1) {
        _lab1 = [[UILabel alloc] init];
        _lab1.font = [UIFont systemFontOfSize:12];
        _lab1.textColor = UIColorFromRGB(0x333333);
    }
    return _lab1;
}
- (UILabel *)lab2{
    if (!_lab2) {
        _lab2 = [[UILabel alloc] init];
        _lab2.font = [UIFont systemFontOfSize:12];
        _lab2.textColor = UIColorFromRGB(0x333333);
    }
    return _lab2;
}
- (UILabel *)lab3{
    if (!_lab3) {
        _lab3 = [[UILabel alloc] init];
        _lab3.font = [UIFont systemFontOfSize:12];
        _lab3.textColor = UIColorFromRGB(0x333333);
    }
    return _lab3;
}
- (UILabel *)lab4{
    if (!_lab4) {
        _lab4 = [[UILabel alloc] init];
        _lab4.font = [UIFont systemFontOfSize:12];
        _lab4.textColor = UIColorFromRGB(0x333333);
    }
    return _lab4;
}
- (UIImageView *)img1{
    if (!_img1) {
        _img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cantask"]];
    }
    return _img1;
}
- (UIImageView *)img2{
    if (!_img2) {
        _img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time"]];
    }
    return _img2;
}
- (UIImageView *)img3{
    if (!_img3) {
        _img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time"]];
    }
    return _img3;
}
- (UIImageView *)img4{
    if (!_img4) {
        _img4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time"]];
    }
    return _img4;
}


- (CoreStatusBtn *)btn_receive{
    if (!_btn_receive) {
        _btn_receive = [[CoreStatusBtn alloc] initWithFrame:CGRectMake(60, 20, WIDTH - 120, HEIGHT/15)];
        _btn_receive.tag = 1;
        _btn_receive.layer.masksToBounds = YES;
        _btn_receive.layer.cornerRadius = 4;
        _btn_receive.backgroundColorForNormal = UIColorFromRGB(0x9a3b8);
        _btn_receive.shutOffColorLoadingAnim = YES;
        _btn_receive.shutOffZoomAnim = YES;
        _btn_receive.status = CoreStatusBtnStatusNormal;
        _btn_receive.msg = @"";
        [_btn_receive setTitle:@"领取任务" forState:UIControlStateNormal];
        [_btn_receive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_receive.hidden = YES;
        [_btn_receive addTarget:self action:@selector(receivedTask:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_receive;
}
- (CoreStatusBtn *)btn_giveup{
    if (!_btn_giveup) {
        _btn_giveup = [[CoreStatusBtn alloc] initWithFrame:CGRectMake(20, 20, WIDTH/2 - 40, HEIGHT/15)];
        _btn_giveup.layer.masksToBounds = YES;
        _btn_giveup.layer.cornerRadius = 4;
        _btn_giveup.backgroundColorForNormal = UIColorFromRGB(0x75d3e0);
        _btn_giveup.shutOffColorLoadingAnim = YES;
        _btn_giveup.shutOffZoomAnim = YES;
        _btn_giveup.status = CoreStatusBtnStatusNormal;
        _btn_giveup.msg = @"";
        [_btn_giveup setTitle:@"放弃任务" forState:UIControlStateNormal];
        [_btn_giveup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_giveup.hidden = YES;
        [_btn_giveup addTarget:self action:@selector(giveupTask) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_giveup;
}
- (CoreStatusBtn *)btn_againReceive{
    if (!_btn_againReceive) {
        _btn_againReceive = [[CoreStatusBtn alloc] initWithFrame:CGRectMake(WIDTH/2+20, 20, WIDTH/2 - 40, HEIGHT/15)];
        _btn_againReceive.layer.masksToBounds = YES;
        _btn_againReceive.layer.cornerRadius = 4;
//        _btn_againReceive.backgroundColorForNormal = UIColorFromRGB(0x9a3b8);
//        _btn_againReceive.backgroundColorForNormal = [UIColor grayColor];
//        [_btn_againReceive setBackgroundColorForNormal:UIColorFromRGB(0x9a3b8)];
        _btn_againReceive.shutOffColorLoadingAnim = YES;
        _btn_againReceive.shutOffZoomAnim = YES;
        _btn_againReceive.status = CoreStatusBtnStatusNormal;
        _btn_againReceive.msg = @"";
        [_btn_againReceive setTitle:@"再次领取" forState:UIControlStateNormal];
        [_btn_againReceive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_againReceive.hidden = YES;
        [_btn_againReceive addTarget:self action:@selector(receivedTask:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_againReceive;
}
- (UIButton *)btn_post{
    if (!_btn_post) {
        _btn_post = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_post.frame = CGRectMake(WIDTH/2 + 20, 20, WIDTH/2 - 40, HEIGHT/15);
        _btn_post.layer.masksToBounds = YES;
        _btn_post.layer.cornerRadius = 4;
        _btn_post.backgroundColor = UIColorFromRGB(0x9a3b8);
        _btn_post.hidden = YES;
        _btn_post.tag = 111;
        [_btn_post addTarget:self action:@selector(postcont:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_post;
}
- (UIButton *)btn_lookPost{
    if (!_btn_lookPost) {
        _btn_lookPost = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_lookPost.frame = CGRectMake(20, 20, WIDTH/2 - 40, HEIGHT/15);
        _btn_lookPost.layer.masksToBounds = YES;
        _btn_lookPost.layer.cornerRadius = 4;
        [_btn_lookPost setTitle:@"查看资料" forState:UIControlStateNormal];
        _btn_lookPost.backgroundColor = UIColorFromRGB(0x9a3b8);
        _btn_lookPost.hidden = YES;
        _btn_lookPost.tag = 333;
        [_btn_lookPost addTarget:self action:@selector(postcont:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_lookPost;
}
#pragma mark 领取任务
- (void)receivedTask:(CoreStatusBtn *)btn{
    
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]){
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        if (user.isLogin == NO) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];

        }else{
            btn.status = CoreStatusBtnStatusProgress;
            AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
            NSDictionary *parameters = @{@"userId":user.userId,
                                         @"taskId":_task.taskId};
            NSLog(@"aaaaa%@",parameters);
            [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_ReceiverTask] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@">>>>>reservetask ----%@",responseObject);
                NSNumber *code = [responseObject objectForKey:@"code"];
                int code_int = [code intValue];
                if (code_int == 200) {
                    
                    _type = 2;
                    [self getTaskContent:[responseObject objectForKey:@"data"]];
                    [self judegMent];
                    
                    
//                    _orderID = [[responseObject objectForKey:@"data"] objectForKey:@"orderId"];
                    
                    btn.status = CoreStatusBtnStatusSuccess;
                    
                    NSString *timeStr = [NSString stringWithFormat:@"请在%@小时内完成任务。\n 提示:完成之后不要忘记提交审核哦",_task.taskCycle];
                    
                    CustomIOSAlertView *alert = [self successAlert:@"icon_success" andtitle:@"领取成功" andmsg:timeStr andButtonItem:[NSMutableArray arrayWithObjects:@"确定",@"当前任务", nil]];
                    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                    
                        
                        
                        [alertView close];
                        
                        
                        
                        
                        
                        if (buttonIndex==1) {
                            if (_onlyType == 999) {
//                                UIViewController *target = nil;
//                                for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
//                                    if ([controller isKindOfClass:[CurrentTaskViewController class]]) { //这里判断是否为你想要跳转的页面
//                                        target = controller;
//                                    }
//                                }
//                                if (target) {
//                                    [self.navigationController popToViewController:target animated:YES]; //跳转
//                                }
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"CurrentNotification" object:nil userInfo:nil];
                            }else{
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                            
                        }
                    }];
                    [alert show];
                    
                }else{
                    btn.status = CoreStatusBtnStatusFalse;
                    [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                btn.status = CoreStatusBtnStatusFalse;
            }];
        }
        
    }
}
#pragma mark 自定义弹框
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
#pragma mark 放弃任务
- (void)giveupTask{
    
    
    CustomIOSAlertView *alert = [self successAlert:@"icon_tishi" andtitle:@"提示" andmsg:@"任务还未完成，确认要放弃吗？" andButtonItem:[NSMutableArray arrayWithObjects:@"确定",@"取消", nil]];
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
        if (buttonIndex == 0) {
            if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]){
                [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
            }else{
                _btn_giveup.status = CoreStatusBtnStatusProgress;
                NSLog(@">>>>>%@",_task.orderId);
                AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
                NSDictionary *parameters = @{@"userId":user.userId,
                                             @"orderId":_task.orderId,
                                             @"remark":@""};
                NSLog(@">>>>>%@",parameters);
                [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_GiveUpTask] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    NSNumber *code = [responseObject objectForKey:@"code"];
                    int code_int = [code intValue];
                    if (code_int == 200) {
                        
                        _btn_giveup.status = CoreStatusBtnStatusSuccess;
                        
                        [self.view makeToast:@"放弃成功" duration:1.0 position:CSToastPositionTop];
                        _type = 1;
                        [self judegMent];
                        [self getTaskContent:_task.orderId];
                        
                    }else{
                        _btn_giveup.status = CoreStatusBtnStatusFalse;
                        NSLog(@"code : %zi    %@",code,[responseObject objectForKey:@"msg"]);
                        [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }
        }
        
    }];
    [alert show];
    
    
    
}
- (void)postcont:(UIButton *)btn{
    PostContractViewController *postVC = [[PostContractViewController alloc] init];
    postVC.delegate = self;
    postVC.tag = btn.tag;
    postVC.task = _task;
    [postVC postGetMyTask];
    [self.navigationController pushViewController:postVC animated:YES];
}
#pragma mark 时间处理
- (NSString *)timeHelper:(NSString *)timeStr{
    NSLog(@"time   str ing  》》》》%@",timeStr);
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mydata = [dateformatter dateFromString:timeStr];
    //返回给定时间距离现在经过的秒数
    NSTimeInterval mytimenow = [mydata timeIntervalSinceNow];
    
    NSString *myStr;
    if (mytimenow < 60) {
        if (mytimenow <= 0) {
            myStr = [NSString stringWithFormat:@"已结束"];
        }else{
            myStr = [NSString stringWithFormat:@"%.f秒",mytimenow];
        }
    }else if (mytimenow < 60*60){
        myStr = [NSString stringWithFormat:@"领取截止时间  %.f分",mytimenow/60];
    }else if (mytimenow < 60*60*24){
        myStr = [NSString stringWithFormat:@"领取截止时间  %.f小时",mytimenow/60/60];
    }else{
        myStr = [NSString stringWithFormat:@"领取截止时间  %.f天",mytimenow/60/60/24];
    }
    
    return myStr;
}


- (NSString *)timeFinsh:(NSString *)timeStr andCycle:(NSString *)cycle{
    
    
    
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mydata = [dateformatter dateFromString:timeStr];
    //返回给定时间距离现在经过的秒数
    NSTimeInterval mytimenow = [mydata timeIntervalSinceNow] + [cycle intValue] * 60 * 60;
    
    NSLog(@"time str::::>>>>>>>>>%.f",mytimenow);
    
    
    NSString *returnStr ;
    if (mytimenow < 60) {
        if (mytimenow <= 0 ) {
            returnStr = [NSString stringWithFormat:@"已结束"];
        }else{
            returnStr = [NSString stringWithFormat:@"%.f秒",mytimenow];
        }
        
    }else if (mytimenow < 60*60){
        returnStr = [NSString stringWithFormat:@"剩余完成时间  %.f分",mytimenow/60];
    }else if (mytimenow < 60*60*24){
        returnStr = [NSString stringWithFormat:@"剩余完成时间  %.f小时",mytimenow/60/60];
    }else{
        returnStr = [NSString stringWithFormat:@"剩余完成时间  %.f天",mytimenow/60/60/24];
    }
    return returnStr;
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
