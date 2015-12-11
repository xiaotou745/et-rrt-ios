//
//  EditInfoImgCell.m
//  RRDT1.0
//
//  Created by riverman on 15/12/7.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "EditInfoImgCell.h"

@implementation EditInfoImgCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)Tap0:(id)sender {
    _editInfoBlock(0);
}
- (IBAction)Tap1:(id)sender {
    _editInfoBlock(1);
}
- (IBAction)Tap2:(id)sender {
    _editInfoBlock(2);
}
- (IBAction)Tap3:(id)sender {
    _editInfoBlock(3);
}
- (IBAction)Tap4:(id)sender {
    _editInfoBlock(4);
}
-(void)layoutViewsss:(NSInteger)count{
    if (count<5) {
        [_img4 setHidden:YES];
    }
    if (count<4) {
        [_img3 setHidden:YES];
    }
    if (count<3) {
        [_img2 setHidden:YES];
    }
    if (count<2) {
        [_img1 setHidden:YES];
    }
    if (count<1) {
        [_img0 setHidden:YES];
    }

}
@end
