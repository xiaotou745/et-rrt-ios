//
//  ContractTextTableViewCell.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "ContractTextTableViewCell.h"

@implementation ContractTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _myTxt = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, self.frame.size.width - 25, self.frame.size.height)];
        [self addSubview:_myTxt];
//
//        NSLog(@">>>text>%@",_myTxt.superview);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
