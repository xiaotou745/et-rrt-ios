//
//  WaitTaskTableViewCell.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/23.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "WaitTaskTableViewCell.h"

@implementation WaitTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self headImageView];
        [self headLabel];
        [self moneyLab];
        [self infoLabel];
//        [self taskType];
//        [self leftLab];
//        [self rightLab];
//        [self imag_left];
//        [self img_right];
//        [self line_label];
        
        
//        self.img_left.image = [UIImage imageNamed:@"icon_cantask"];
//        self.img_right.image = [UIImage imageNamed:@"icon_time"];
        
        
        
        
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
        
        [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headLabel.mas_bottom);
            make.right.equalTo(self).with.offset(-10);
            make.width.mas_equalTo(100);
            make.height.equalTo(@40);
        }];
        
        [_taskType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImageView.mas_top);
            make.right.equalTo(self).with.offset(-10);
            make.width.mas_equalTo(60);
            make.height.equalTo(@20);
        }];
        
//        [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).with.offset(-15);
//            make.height.equalTo(@15);
//            make.left.mas_equalTo(_img_left.mas_right).offset(3);
//        }];
//        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).with.offset(-15);
//            make.height.equalTo(@15);
//            make.right.equalTo(self).offset(-30);
//        }];
//        
//        [_img_left mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).with.offset(-15);
//            make.height.equalTo(@15);
//            make.left.equalTo(self).with.offset(12);
//            make.width.equalTo(@15);
//        }];
//        [_img_right mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).with.offset(-15);
//            make.height.equalTo(@15);
//            make.right.mas_equalTo(_rightLab.mas_left).offset(-3);
//            make.width.equalTo(@15);
//        }];
//        [_line_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).with.offset(12);
//            make.right.equalTo(self).with.offset(-12);
//            make.top.mas_equalTo(_headImageView.mas_bottom).offset(10);
//            make.height.equalTo(@1);
//        }];
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
- (CoreLabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[CoreLabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.textColor = UIColorFromRGB(0xbbc0c7);
        _infoLabel.numberOfLines = 2;
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}
- (UILabel *)taskType{
    if (!_taskType) {
        _taskType = [[UILabel alloc] init];
        _taskType.font = [UIFont systemFontOfSize:12];
        _taskType.textAlignment=NSTextAlignmentCenter;
        _taskType.textColor = [UIColor whiteColor];
        _taskType.backgroundColor=UIColorFromRGB(0x32bcf6);
        _taskType.layer.cornerRadius=3;
        _taskType.layer.masksToBounds=YES;
        _taskType.numberOfLines = 1;
        [self addSubview:_taskType];
    }
    return _taskType;
}
//- (UILabel *)leftLab{
//    if (!_leftLab) {
//        _leftLab = [[UILabel alloc] init];
//        _leftLab.font = [UIFont systemFontOfSize:12];
//        [self addSubview:_leftLab];
//    }
//    return _leftLab;
//}
//- (UILabel *)rightLab{
//    if (!_rightLab) {
//        _rightLab = [[UILabel alloc] init];
//        _rightLab.font = [UIFont systemFontOfSize:12];
//        [self addSubview:_rightLab];
//    }
//    return _rightLab;
//}
- (CoreLabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[CoreLabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_moneyLab];
    }
    return _moneyLab;
}
//- (UIImageView *)imag_left{
//    if (!_img_left) {
//        _img_left = [[UIImageView alloc] init];
//        [self addSubview:_img_left];
//    }
//    return _img_left;
//}
//- (UIImageView *)img_right{
//    if (!_img_right) {
//        _img_right = [[UIImageView alloc] init];
//        [self addSubview:_img_right];
//    }
//    return _img_right;
//}
//- (UILabel *)line_label{
//    if (!_line_label) {
//        _line_label = [[UILabel alloc] init];
//        _line_label.backgroundColor = UIColorFromRGB(0xe5e5e5);
//        [self addSubview:_line_label];
//    }
//    return _line_label;
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
