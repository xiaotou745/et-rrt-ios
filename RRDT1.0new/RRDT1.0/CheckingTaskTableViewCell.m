//
//  CheckingTaskTableViewCell.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "CheckingTaskTableViewCell.h"

@implementation CheckingTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self receiveBtn];
        
        self.img_buttom.hidden = YES;
        self.buttomLab.hidden = YES;
        
        [_receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-10);
            make.height.equalTo(@30);
            make.width.equalTo(@70);
            make.right.mas_equalTo(self).offset(-10);
        }];
    }
    return self;
}
- (CoreStatusBtn *)receiveBtn{
    if (!_receiveBtn) {
        _receiveBtn = [[CoreStatusBtn alloc] init];
        _receiveBtn.layer.masksToBounds = YES;
        [_receiveBtn setTitle:@"再次领取" forState:UIControlStateNormal];
        _receiveBtn.fontPoint = 12.0;
        _receiveBtn.layer.masksToBounds = YES;
        _receiveBtn.layer.cornerRadius = 4;
        [_receiveBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _receiveBtn.backgroundColorForNormal = UIColorFromRGB(0x09a3b8);
        _receiveBtn.shutOffColorLoadingAnim = YES;
        _receiveBtn.shutOffZoomAnim = YES;
        _receiveBtn.status = CoreStatusBtnStatusNormal;
        _receiveBtn.msg = @" ";
        [self addSubview:_receiveBtn];
    }
    return _receiveBtn;
}
@end
