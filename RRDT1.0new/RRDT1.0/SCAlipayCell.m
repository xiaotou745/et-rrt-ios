//
//  SCAlipayCell.m
//  SupermanC
//
//  Created by riverman on 15/9/29.
//  Copyright © 2015年 etaostars. All rights reserved.
//

#import "SCAlipayCell.h"

@implementation SCAlipayCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor whiteColor];
    _titleText.textColor=UIColorFromRGB(0x333333);
    _contentTF.textColor=UIColorFromRGB(0x333333);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setDic:(NSDictionary *)dic{

    _titleText.text=dic[kSCAlipayCell_title];
    _contentTF.text=dic[kSCAlipayCell_text];
    _contentTF.placeholder=dic[kSCAlipayCell_placeholder];
    
}
@end
