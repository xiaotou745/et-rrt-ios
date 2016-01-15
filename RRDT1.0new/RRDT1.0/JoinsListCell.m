//
//  JoinsListCell.m
//  RRDT1.0
//
//  Created by riverman on 16/1/15.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "JoinsListCell.h"

@implementation JoinsListCell

- (void)awakeFromNib {
    // Initialization code
    _parterName.textColor=UIColorFromRGB(0x666666);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ParterModel *)model{
    [_headImageVIew sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:[UIImage imageNamed:@"icon_usermorentu"]];
    _parterName.text=model.clienterName;

}
@end
