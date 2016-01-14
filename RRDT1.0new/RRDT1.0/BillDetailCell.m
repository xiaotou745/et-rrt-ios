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

    _titleLab.text=model.recordTypeName;
    _timeLab.text=[MyTools timeString:model.operateTime];
    _amoutLab.text=[NSString stringWithFormat:@"%.2f元",model.amount];
    
    if (_isInComeCell) {
        _amoutLab.textColor= UIColorFromRGB(0xf7585d);
    }else{
        _amoutLab.textColor=UIColorFromRGB(0x00bc87);
    }

}
@end
