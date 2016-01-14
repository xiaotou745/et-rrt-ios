//
//  SCBillDetailVC.m
//  SupermanC
//
//  Created by riverman on 15/8/26.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "SCBillDetailVC.h"


@interface SCBillDetailVC ()


@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UILabel *payAmout;


@property (weak, nonatomic) IBOutlet UILabel *relationType;
@property (weak, nonatomic) IBOutlet UILabel *RelationNo;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (weak, nonatomic) IBOutlet UILabel *payReason;
@property (weak, nonatomic) IBOutlet UILabel *payDetail;
@property (weak, nonatomic) IBOutlet UILabel *payTime;

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
    
    
//    _RelationNo.text =[_payInfo[@"RelationNo"]description];
//    _RelationNo.textColor=[UIColor colorWithHexString:SCColorBlueNormal];
    
//    NSString *relationNoText=[_payInfo[@"relationNo"]description];
    NSString *relationNoText=@"--";
    _RelationNo.text=relationNoText;

    /*
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:relationNoText];
    
    NSInteger isOrder=[_payInfo[@"isOrder"]intValue];
    
    
    //存在流水号 且关联了订单
    if (relationNoText&&isOrder==1){
        [AttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:SCColorBlueNormal] range:NSMakeRange(0,relationNoText.length)];
        [AttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,relationNoText.length)];
       //只存在流水号  未关联订单
    }else if (relationNoText){
    
        [AttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,relationNoText.length)];
        [_rightArrow setHidden:YES];
//        [AttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,relationNoText.length)];
       
        //不存在流水号 且 未关联订单
    }else
    {
        AttributedString=[[NSMutableAttributedString alloc] initWithString:@"--"];
        [AttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,2)];
        [_rightArrow setHidden:YES];
    }

    
    
//    NSDictionary *attributeDict = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:SCColorBlueNormal],NSUnderlineStyleAttributeName:[UIColor colorWithHexString:SCColorBlueNormal]};
    
//    [AttributedString addAttributes:attributeDict range:NSMakeRange(0,relationNoText.length)];

    [_RelationNo setAttributedText:AttributedString];
    */
    
    _relationType.text =_model.recordTypeName;
    _payAmout.text  =    [NSString stringWithFormat:@"%.2f",_model.amount];
//    _payReason.text =   _payInfo[@"recordType"];
    _payDetail.text =   _model.remark;
    _payTime.text   =   [MyTools timeString:_model.operateTime];


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
