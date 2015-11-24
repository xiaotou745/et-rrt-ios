//
//  ReceivedTableViewCell.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/26.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "ReceivedTableViewCell.h"

@implementation ReceivedTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self headImageView];
        [self headLabel];
        [self moneyLab];
        [self infoLabel];
        [self topLab];
        [self buttomLab];
        [self img_top];
        [self img_buttom];
        [self line_label];
        
        
        self.img_top.image      = [UIImage imageNamed:@"icon_time"];
        self.img_buttom.image   = [UIImage imageNamed:@"icon_time"];
        
        
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(15);
            make.left.equalTo(self).with.offset(12);
            make.width.equalTo(@55);
            make.height.equalTo(@55);
        }];
        
        
        
        
        
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(15);
            make.left.mas_equalTo(_headImageView.mas_right).offset(12);
            make.right.equalTo(self).with.offset(-12);
            make.height.mas_equalTo(20);
        }];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headLabel.mas_bottom);
            make.left.mas_equalTo(_headImageView.mas_right).offset(12);
            make.right.mas_equalTo(_moneyLab.mas_left).offset(-10);
            make.height.mas_equalTo(40);
        }];
        
        //        _moneyLab.backgroundColor = [UIColor redColor];
        [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headLabel.mas_bottom);
            make.right.equalTo(self).with.offset(-10);
            make.width.mas_equalTo(100);
            //            make.left.mas_equalTo(_infoLabel.mas_right).offset(10);
            make.height.equalTo(@40);
        }];
        
        [_line_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12);
            make.right.equalTo(self).with.offset(-12);
            make.top.mas_equalTo(_headImageView.mas_bottom).offset(10);
            make.height.equalTo(@1);
        }];
        
        [_topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
            make.left.mas_equalTo(_img_top.mas_right).offset(5);
            make.height.equalTo(@15);
        }];
        [_buttomLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topLab.mas_bottom).offset(10);
            make.left.mas_equalTo(_img_buttom.mas_right).offset(5);
            make.height.equalTo(@15);
        }];
        
        [_img_top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
            make.height.equalTo(@15);
            make.left.equalTo(self).with.offset(12);
            make.width.equalTo(@15);
        }];
        [_img_buttom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topLab.mas_bottom).offset(10);
            make.left.equalTo(self).with.offset(12);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];

    }
    return self;
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        [self addSubview:_headImageView];
    }
    return _headImageView;
}
- (UILabel *)headLabel{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] init];
        _headLabel.font = [UIFont systemFontOfSize:15];
        _headLabel.numberOfLines = 1;
        [self addSubview:_headLabel];
    }
    return _headLabel;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.textColor = UIColorFromRGB(0xbbc0c7);
        _infoLabel.numberOfLines = 2;
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UILabel *)topLab{
    if (!_topLab) {
        _topLab = [[UILabel alloc] init];
        _topLab.font = [UIFont systemFontOfSize:12];
        _topLab.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_topLab];
    }
    return _topLab;
}
- (UILabel *)buttomLab{
    if (!_buttomLab) {
        _buttomLab = [[UILabel alloc] init];
        _buttomLab.font = [UIFont systemFontOfSize:12];
        _buttomLab.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_buttomLab];
    }
    return _buttomLab;
}
- (CoreLabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[CoreLabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneyLab];
    }
    return _moneyLab;
}
- (UIImageView *)img_top{
    if (!_img_top) {
        _img_top = [[UIImageView alloc] init];
        [self addSubview:_img_top];
    }
    return _img_top;
}
- (UIImageView *)img_buttom{
    if (!_img_buttom) {
        _img_buttom = [[UIImageView alloc] init];
        [self addSubview:_img_buttom];
    }
    return _img_buttom;
}
- (UILabel *)line_label{
    if (!_line_label) {
        _line_label = [[UILabel alloc] init];
        _line_label.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [self addSubview:_line_label];
    }
    return _line_label;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
