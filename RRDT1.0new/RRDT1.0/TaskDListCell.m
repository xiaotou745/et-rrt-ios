//
//  TaskDListCell.m
//  RRDT1.0
//
//  Created by riverman on 16/1/19.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "TaskDListCell.h"

@implementation TaskDListCell

- (void)awakeFromNib {
    // Initialization code
    
    _taskAmount.textAlignment=NSTextAlignmentRight;

    _taskTypeName.textAlignment=NSTextAlignmentRight;
    _taskTypeName.font=[UIFont systemFontOfSize:14];
    _taskName.textColor=UIColorFromRGB(0x333333);

    [self.contentView bringSubviewToFront:_taskTypeName];
    
    _rightView.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    _logo.layer.cornerRadius=8;
    _logo.layer.masksToBounds=YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TaskDetailModel *)model{

    if (model.logo.length) {
        [self.logo sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"icon_morentu"]];

    }
    _taskName.text=model.taskName;
    _taskAmount.text=[NSString stringWithFormat:@"%.2f元/次",model.amount];
    
    [_taskAmount addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0,_taskAmount.text.length - 3)];
    [_taskAmount addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(_taskAmount.text.length - 3,3)];
    [_taskAmount addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(0,_taskAmount.text.length - 3)];
    [_taskAmount addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x666666) range:NSMakeRange(_taskAmount.text.length - 3,3)];
    [_taskAmount updateLabelStyle];
    
    
    _taskTypeImgView.image=[UIImage imageNamed:[MyTools getTasktypeImageName:model.taskType]];
    _taskTypeName.text=[MyTools getTasktype:model.taskType];
    
    _taskDatumCount.text=[NSString stringWithFormat:@"%ld条",model.taskDatumCount];
    
    
}
@end
