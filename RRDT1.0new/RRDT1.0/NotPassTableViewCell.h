//
//  NotPassTableViewCell.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "ReceivedTableViewCell.h"

#import "CoreStatusBtn.h"

@interface NotPassTableViewCell : ReceivedTableViewCell

@property (nonatomic,strong) UIImageView    *img_last;

@property (nonatomic,strong) UILabel        *lab_last;

@property (nonatomic,strong) CoreStatusBtn  *btn_giveup;

@property (nonatomic,strong) UIButton       *btn_post;

@end
