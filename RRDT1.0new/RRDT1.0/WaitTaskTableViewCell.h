//
//  WaitTaskTableViewCell.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/23.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreLabel.h"

@interface WaitTaskTableViewCell : UITableViewCell
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
@property (nonatomic,strong) CoreLabel        *infoLabel;
/**
 金额
 */
@property (nonatomic,strong) CoreLabel      *moneyLab;

/**
 任务类型
 */
@property (nonatomic,strong) UILabel      *taskType;
/**
 左lab
 */
//@property (nonatomic,strong) UILabel        *leftLab;
///**
// 右lab
// */
//@property (nonatomic,strong) UILabel        *rightLab;
///**
// 左img
// */
//@property (nonatomic,strong) UIImageView    *img_left;
///**
// 右img
// */
//@property (nonatomic,strong) UIImageView    *img_right;
///**
// lineLAB
// */
//@property (nonatomic,strong) UILabel        *line_label;
@end
