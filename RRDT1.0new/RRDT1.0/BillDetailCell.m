//
//  BillDetailCell.m
//  RRDT1.0
//
//  Created by riverman on 16/1/11.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "BillDetailCell.h"

@implementation BillDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BillDetailModel *)model{

    if (model.recordType==1)//任务奖励的recordType 为1
        _titleLab.text=[NSString stringWithFormat:@"%@-%@",model.recordTypeName,model.remark];
    else    _titleLab.text=model.recordTypeName;

    _timeLab.text=[MyTools timeString:model.operateTime];
    
    
    if (_isInComeCell) {
        _amoutLab.textColor= UIColorFromRGB(0xf7585d);
        _amoutLab.text=[NSString stringWithFormat:@"+%.2f",model.amount];

    }else{
        _amoutLab.textColor=UIColorFromRGB(0x00bc87);
        _amoutLab.text=[NSString stringWithFormat:@"%.2f",model.amount];
    }
//    [_amoutLab addAttr:CoreLabelAttrColor value:[UIColor darkGrayColor] range:NSMakeRange(_amoutLab.text.length - 1,1)];

}
@end
