//
//  ReceivedTableViewCell.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/26.
//  Copyright © 2015年 RRDT002. All rights reserved.
//
//  签约任务的cell
#import <UIKit/UIKit.h>

#import "CoreLabel.h"

typedef void(^WaitViewBlock)(void);
typedef void(^PassViewBlock)(void);
typedef void(^RefuseViewBlock)(void);

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
 任务类型视图
 */
@property (nonatomic,strong) UIImageView      *taskTypeView;


@property (nonatomic,strong) UIImageView    *img_wait;
@property (nonatomic,strong) UILabel        *waitLab;
@property (nonatomic,strong) UIView         *waitView;

@property (nonatomic,strong) UIImageView    *img_pass;
@property (nonatomic,strong) UILabel        *passLab;
@property (nonatomic,strong) UIView         *passView;

@property (nonatomic,strong) UIImageView    *img_refuse;
@property (nonatomic,strong) UILabel        *refuseLab;
@property (nonatomic,strong) UIView         *refuseView;

@property(copy)WaitViewBlock waitBlock;
@property(copy)PassViewBlock passBlock;
@property(copy)RefuseViewBlock refuseBlock;

/**
 lineLAB
 */
@property (nonatomic,strong) UILabel        *line_label;


@end
