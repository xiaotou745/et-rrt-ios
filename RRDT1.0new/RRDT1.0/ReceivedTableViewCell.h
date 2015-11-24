//
//  ReceivedTableViewCell.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/26.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreLabel.h"

@interface ReceivedTableViewCell : UITableViewCell

/**
 主照片
 */
@property (nonatomic,strong) UIImageView    *headImageView;
/**
 标题
 */
@property (nonatomic,strong) UILabel        *headLabel;
/**
 公告
 */
@property (nonatomic,strong) UILabel        *infoLabel;
/**
 金额
 */
@property (nonatomic,strong) CoreLabel      *moneyLab;
/**
 上lab
 */
@property (nonatomic,strong) UILabel        *topLab;
/**
 下lab
 */
@property (nonatomic,strong) UILabel        *buttomLab;
/**
 上img
 */
@property (nonatomic,strong) UIImageView    *img_top;
/**
 下img
 */
@property (nonatomic,strong) UIImageView    *img_buttom;
/**
 lineLAB
 */
@property (nonatomic,strong) UILabel        *line_label;


@end
