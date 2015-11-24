//
//  ContractImageTableViewCell.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "ContractImageTableViewCell.h"

#import "UIButton+WebCache.h"

@implementation ContractImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        _myLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, WIDTH/2 - 25, 70)];
//        [self addSubview:_myLab];
        
        self.textLabel.textColor = UIColorFromRGB(0x333333);
        
        _myImg_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
        self.accessoryView = _myImg_btn;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
