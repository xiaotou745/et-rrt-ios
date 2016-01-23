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
        
        [self.passLab setHidden:YES];
        [self.img_pass setHidden:YES];
        [self.refuseLab setHidden:YES];
        [self.img_refuse setHidden:YES];
        //关闭交互 不触发跳转到 审核详情
//        [self.waitView setUserInteractionEnabled:NO];
            [self.refuseView setHidden:YES];
            [self.passView setHidden:YES];
        //    checkCell.waitView.backgroundColor=[UIColor orangeColor];
        self.passView.backgroundColor=[UIColor redColor];
        self.refuseView.backgroundColor=[UIColor orangeColor];
        
        [self receiveBtn];
        
        UILabel *verticalLine=[ManFactory createLabelWithFrame:CGRectMake(DEF_SCEEN_WIDTH-WaitTaskTableViewCell_rowHeight, 0,1, WaitTaskTableViewCell_rowHeight-5) Font:16 Text:@""];
        verticalLine.backgroundColor=UIColorFromRGB(0xe5e5e5);
        [self addSubview:verticalLine];
        
        UILabel *moneyLLLLLLab=[ManFactory createLabelWithFrame:CGRectMake(verticalLine.right, 50, WaitTaskTableViewCell_rowHeight-10, 20) Font:12 Text:@"元/次"];
        moneyLLLLLLab.textAlignment=NSTextAlignmentCenter;
        moneyLLLLLLab.textColor=[UIColor grayColor];
        [self addSubview:moneyLLLLLLab];
        
        
        [_receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-8);
            make.height.equalTo(@25);
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
        [_receiveBtn setTitle:@"继续分享" forState:UIControlStateNormal];
        _receiveBtn.fontPoint = 12.0;
        _receiveBtn.layer.masksToBounds = YES;
        _receiveBtn.layer.cornerRadius = 4;
        _receiveBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _receiveBtn.layer.borderWidth=1.0f;
        [_receiveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _receiveBtn.backgroundColorForNormal = UIColorFromRGB(0x09a3b8);
        _receiveBtn.shutOffColorLoadingAnim = YES;
        _receiveBtn.shutOffZoomAnim = YES;
        _receiveBtn.status = CoreStatusBtnStatusNormal;
        _receiveBtn.msg = @" ";
        [self addSubview:_receiveBtn];
        [self.receiveBtn addTarget:self action:@selector(againReceived) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveBtn;
}

-(void)againReceived{
    _recBTNClick();
}
@end
