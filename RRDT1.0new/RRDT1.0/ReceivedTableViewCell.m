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
        
        [self taskTypeView];
        [self taskType];
        
        [self img_wait];
        [self waitLab];
        [self waitView];
        
        [self img_pass];
        [self passLab];
        [self  passView];
        
        [self img_refuse];
        [self refuseLab];
        [self refuseView];

        [self line_label];
        
        self.img_wait.image   = [UIImage imageNamed:@"TaskDetail_shenhe"];
        self.img_pass.image   = [UIImage imageNamed:@"TaskDetail_pass"];
        self.img_refuse.image   = [UIImage imageNamed:@"TaskDetail_refuse"];

        
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(15);
            make.left.equalTo(self).with.offset(12);
            make.width.equalTo(@55);
            make.height.equalTo(@55);
        }];
        
        
        
        
        
//        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).with.offset(15);
//            make.left.mas_equalTo(_headImageView.mas_right).offset(12);
//            make.right.equalTo(self).with.offset(-50);
//            make.height.mas_equalTo(20);
//        }];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(13);
            make.left.mas_equalTo(_headImageView.mas_right).offset(5);
            make.right.equalTo(self).with.offset(-WaitTaskTableViewCell_rowHeight-5);
//            make.height.mas_equalTo(40);
        }];
        
//        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_headLabel.mas_bottom);
//            make.left.mas_equalTo(_headImageView.mas_right).offset(12);
//            make.right.mas_equalTo(_moneyLab.mas_left).offset(-10);
//            make.height.mas_equalTo(40);
//        }];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headLabel.mas_bottom).with.offset(3);
            make.left.mas_equalTo(_headImageView.mas_right).offset(5);
            make.right.mas_equalTo(_moneyLab.mas_left).offset(-5);
//            make.height.mas_equalTo(40);
        }];
        
        //        _moneyLab.backgroundColor = [UIColor redColor];
        [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).with.offset(30);
            make.right.equalTo(self).with.offset(0);
            make.width.mas_equalTo(WaitTaskTableViewCell_rowHeight);
            //            make.left.mas_equalTo(_infoLabel.mas_right).offset(10);
            make.height.equalTo(@20);
        }];
        
        [_line_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12);
            make.right.equalTo(self).with.offset(-12);
            make.top.mas_equalTo(_headImageView.mas_bottom).offset(10);
            make.height.equalTo(@1);
        }];
        
        [_img_wait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
            make.height.equalTo(@15);
            make.left.equalTo(self).with.offset(12);
            make.width.equalTo(@15);
        }];
        
        [_waitLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
            make.left.mas_equalTo(_img_wait.mas_right).offset(5);
            make.height.equalTo(@15);
        }];
    
        [_waitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(0);
            make.left.equalTo(_img_wait.mas_left).with.offset(0);
            make.right.equalTo(_waitLab.mas_right).with.offset(0);
            make.height.equalTo(@30);
        }];

        
        
        [_img_pass mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
            make.height.equalTo(@15);
            make.right.equalTo(_passLab.mas_left).with.offset(-5);
            make.width.equalTo(@15);
        }];
        
        [_passLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self).offset(0);
            make.height.equalTo(@15);
        }];
        
        [_passView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(0);
            make.left.equalTo(_img_pass.mas_left).with.offset(0);
            make.right.equalTo(_passLab.mas_right).with.offset(0);
            make.height.equalTo(_waitView.mas_height);
        }];
        
        [_img_refuse mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
            make.height.equalTo(@15);
            make.right.equalTo(_refuseLab.mas_left).with.offset(-5);
            make.width.equalTo(@15);
        }];
        
        [_refuseLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
            make.right.mas_equalTo(self).offset(-15);
            make.height.equalTo(@15);
        }];
        
        [_refuseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_line_label.mas_bottom).offset(0);
            make.left.equalTo(_img_refuse.mas_left).with.offset(0);
            make.right.equalTo(_refuseLab.mas_right).with.offset(0);
            make.height.equalTo(_waitView.mas_height);
        }];

    }
    return self;
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.cornerRadius=8;
        _headImageView.layer.masksToBounds=YES;
        [self addSubview:_headImageView];
    }
    return _headImageView;
}
- (UILabel *)headLabel{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] init];
        _headLabel.font = [UIFont systemFontOfSize:15];
        _headLabel.numberOfLines = 2;
        _headLabel.textColor=UIColorFromRGB(0x333333);

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
        _taskType = [ManFactory  createLabelWithFrame:CGRectMake(0, 0, _taskTypeView.width-5, _taskTypeView.height) Font:14 Text:@""];
        _taskType.textAlignment=NSTextAlignmentRight;
        _taskType.textColor = [UIColor whiteColor];
        [_taskTypeView addSubview:_taskType];
    }
    return _taskType;
}
-(UIImageView *)taskTypeView{
    
    if (!_taskTypeView) {
        _taskTypeView = [ManFactory createImageViewWithFrame:CGRectMake(self.width-50, 0, 50, 20) ImageName:@""];
        [self addSubview:_taskTypeView];
    }
    return _taskTypeView;
}
- (CoreLabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[CoreLabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_moneyLab];
    }
    return _moneyLab;
}
-(UIView *)waitView{

    if (!_waitView) {
        _waitView = [[UIView alloc] init];
        [self addSubview:_waitView];
//        _waitView.backgroundColor=[UIColor redColor];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(waitClick)];
        [_waitView addGestureRecognizer:tap];
    }
    return _waitView;
}

-(void)waitClick{
    _waitBlock();
}
-(UIView *)passView{
    
    if (!_passView) {
        _passView = [[UIView alloc] init];
        [self addSubview:_passView];
//        _passView.backgroundColor=[UIColor orangeColor];
        UITapGestureRecognizer *tapp=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(passClick)];
        [_passView addGestureRecognizer:tapp];
    }
    return _passView;
}
-(void)passClick{
    _passBlock();
}
-(UIView *)refuseView{
    
    if (!_refuseView) {
        _refuseView = [[UIView alloc] init];
        [self addSubview:_refuseView];
//        _refuseView.backgroundColor=[UIColor yellowColor];
        UITapGestureRecognizer *tapr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refuseClick)];
        [_refuseView addGestureRecognizer:tapr];
    }
    return _refuseView;
}
-(void)refuseClick{
    _refuseBlock();
}
- (UIImageView *)img_wait{
    if (!_img_wait) {
        _img_wait = [[UIImageView alloc] init];
        [self addSubview:_img_wait];
    }
    return _img_wait;
}
- (UIImageView *)img_pass{
    if (!_img_pass) {
        _img_pass = [[UIImageView alloc] init];
        [self addSubview:_img_pass];
    }
    return _img_pass;
}
- (UIImageView *)img_refuse{
    if (!_img_refuse) {
        _img_refuse = [[UIImageView alloc] init];
        [self addSubview:_img_refuse];
    }
    return _img_refuse;
}
- (UILabel *)waitLab{
    if (!_waitLab) {
        _waitLab = [[UILabel alloc] init];
        _waitLab.font = [UIFont systemFontOfSize:12];
        _waitLab.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_waitLab];
    }
    return _waitLab;
}- (UILabel *)passLab{
    if (!_passLab) {
        _passLab = [[UILabel alloc] init];
        _passLab.font = [UIFont systemFontOfSize:12];
        _passLab.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_passLab];
    }
    return _passLab;
}
- (UILabel *)refuseLab{
    if (!_refuseLab) {
        _refuseLab = [[UILabel alloc] init];
        _refuseLab.font = [UIFont systemFontOfSize:12];
        _refuseLab.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_refuseLab];
    }
    return _refuseLab;
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
