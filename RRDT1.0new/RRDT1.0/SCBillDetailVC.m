//
//  SCBillDetailVC.m
//  SupermanC
//
//  Created by riverman on 15/8/26.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "SCBillDetailVC.h"
#import "CoreLabel.h"

@interface SCBillDetailVC ()


@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet CoreLabel *payAmout;


@property (weak, nonatomic) IBOutlet UILabel *relationType;
@property (weak, nonatomic) IBOutlet UILabel *RelationNo;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (weak, nonatomic) IBOutlet UILabel *payReason;
@property (weak, nonatomic) IBOutlet UILabel *payDetail;
@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *relationNo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payDetailHeight;


@end

@implementation SCBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"账单详情";
    [self configPayInfo];
}
-(void)configPayInfo
{
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    _payDetail.numberOfLines=0;
    [_payDetail sizeToFit];
    

    NSString *relationNoText=@"--";
    _RelationNo.text=relationNoText;


    if (_isInCome) {
        _payAmout.textColor= UIColorFromRGB(0xf7585d);
        _payAmout.text  =    [NSString stringWithFormat:@"+%.2f",_model.amount];


    }else{
        _payAmout.textColor= UIColorFromRGB(0x00bc87);
        _payAmout.text  =    [NSString stringWithFormat:@"%.2f",_model.amount];


    }
//    [_payAmout addAttr:CoreLabelAttrColor value:[UIColor darkGrayColor] range:NSMakeRange(_payAmout.text.length - 1,1)];

    
    _payReason.text =   _model.recordTypeName;
    _payTime.text   =   [MyTools timeString:_model.operateTime];
    _RelationNo.text=_model.relationNo;
    _payDetail.text =   _model.remark;
    
    if (_isInCome&&_model.recordType==1) {
        _payDetail.text =[NSString stringWithFormat:@"成功完成-%@",_model.remark];

    }

}
//-(void)configNavBar
//{
//    [self addNavLeftButtonWithImagePath:@"leftNavBack" target:self  action:@selector(popToBack)];
//    [self addNavMiddleLabelWithText:@"账单详情"];
//    
//}
- (IBAction)toTaskDetail:(id)sender {
//    SCNewDESTaskVC *vc=[[SCNewDESTaskVC alloc]initWithNibName:@"SCNewDESTaskVC" bundle:nil];
//   
//    //RecordType: 交易类型(1：订单佣金 2：取消订单 3：提现申请 4：提现拒绝 5：打款失败 6：系统奖励 7：系统赔偿 8:余额调整)
//    NSInteger isOrder=[_payInfo[@"isOrder"]intValue];
//    if (isOrder==1)     vc.orderGrabId=_payInfo[@"withwardId"];
//    else {
//        //[self postAlertWithMsg:@"此条流水无订单信息"];
//        return;
//    }
//    
//    [self.navigationController pushViewController:vc animated:YES];
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
