//
//  PassTableViewCell.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/29.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "PassTableViewCell.h"

@implementation PassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self againBtn];
        [_againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-10);
            make.height.equalTo(@30);
            make.width.equalTo(@60);
            make.right.mas_equalTo(self).offset(-10);
        }];
    }
    return self;
}
- (CoreStatusBtn *)againBtn{
    if (!_againBtn) {
        _againBtn = [[CoreStatusBtn alloc] init];
        _againBtn.layer.masksToBounds = YES;
        [_againBtn setTitle:@"再次领取" forState:UIControlStateNormal];
        _againBtn.fontPoint = 12.0;
        _againBtn.layer.masksToBounds = YES;
        _againBtn.layer.cornerRadius = 4;
        [_againBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _againBtn.backgroundColorForNormal = UIColorFromRGB(0x09a3b8);
        _againBtn.shutOffColorLoadingAnim = YES;
        _againBtn.shutOffZoomAnim = YES;
        _againBtn.status = CoreStatusBtnStatusNormal;
        _againBtn.msg = @" ";
        [self addSubview:_againBtn];
    }
    return _againBtn;
}


@end
