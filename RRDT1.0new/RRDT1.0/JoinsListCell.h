//
//  JoinsListCell.h
//  RRDT1.0
//
//  Created by riverman on 16/1/15.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParterModel.h"
@interface JoinsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *parterName;

@property(nonatomic,strong)ParterModel *model;
@end
