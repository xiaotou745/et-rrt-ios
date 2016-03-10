//
//  PartnerListCell.h
//  RRDT1.0
//
//  Created by riverman on 16/3/1.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParterModel.h"
@interface PartnerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *parterName;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property(nonatomic,strong)ParterModel *model;

@end
