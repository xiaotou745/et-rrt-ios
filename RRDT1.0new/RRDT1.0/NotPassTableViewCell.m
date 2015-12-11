//
//  NotPassTableViewCell.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "NotPassTableViewCell.h"

@implementation NotPassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self img_last];
        [self lab_last];
        [self btn_post];
        [self btn_giveup];
        
        
        _img_last.image      = [UIImage imageNamed:@"icon_cantask"];
        
        
//        [_img_last mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.img_buttom.mas_bottom).offset(10);
//            make.left.equalTo(self).with.offset(12);
//            make.height.equalTo(@15);
//            make.width.equalTo(@15);
//        }];
//        [_lab_last mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.img_buttom.mas_bottom).offset(10);
//            make.left.mas_equalTo(_img_last.mas_right).offset(5);
//            make.height.equalTo(@15);
//        }];
        
        [_btn_giveup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-5);
            make.left.equalTo(self).with.offset(40);
            make.width.mas_equalTo(_btn_post);
            make.height.equalTo(@30);
            make.right.mas_equalTo(_btn_post.mas_left).offset(-80);
        }];
        [_btn_post mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-5);
            make.right.equalTo(self).with.offset(-40);
            make.width.mas_equalTo(_btn_giveup);
            make.height.equalTo(@30);
            make.left.mas_equalTo(_btn_giveup.mas_right).offset(80);
        }];
    }
    return self;
}
- (UIImageView *)img_last{
    if (!_img_last) {
        _img_last = [[UIImageView alloc] init];
        [self addSubview:_img_last];
    }
    return _img_last;
}
- (UILabel *)lab_last{
    if (!_lab_last) {
        _lab_last = [[UILabel alloc] init];
        _lab_last.font = [UIFont systemFontOfSize:12];
        _lab_last.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_lab_last];
    }
    return _lab_last;
}
- (CoreStatusBtn *)btn_giveup{
    if (!_btn_giveup) {
        _btn_giveup = [[CoreStatusBtn alloc] init];
        _btn_giveup.layer.masksToBounds = YES;
        [_btn_giveup setTitle:@"放弃任务" forState:UIControlStateNormal];
        _btn_giveup.fontPoint = 12.0;
        _btn_giveup.layer.masksToBounds = YES;
        _btn_giveup.layer.cornerRadius = 4;
        [_btn_giveup setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _btn_giveup.backgroundColorForNormal = UIColorFromRGB(0x75d3e0);
        _btn_giveup.shutOffColorLoadingAnim = YES;
        _btn_giveup.shutOffZoomAnim = YES;
        _btn_giveup.status = CoreStatusBtnStatusNormal;
        _btn_giveup.msg = @" ";
        [self addSubview:_btn_giveup];
    }
    return _btn_giveup;
}
- (UIButton *)btn_post{
    if (!_btn_post) {
        _btn_post = [[UIButton alloc] init];
        _btn_post.layer.masksToBounds = YES;
        _btn_post.layer.cornerRadius = 4;
        _btn_post.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btn_post setTitle:@"重新提交" forState:UIControlStateNormal];
        [_btn_post setBackgroundColor:UIColorFromRGB(0x09a3b8)];
        [_btn_post setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self addSubview:_btn_post];
    }
    return _btn_post;
}
@end
