//
//  BillDetailCell.h
//  RRDT1.0
//
//  Created by riverman on 16/1/11.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLabel.h"
#import "BillDetailModel.h"
@interface BillDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet CoreLabel *amoutLab;


@property(assign,nonatomic)BOOL isInComeCell;
@property(strong,nonatomic)BillDetailModel *model;

@end
