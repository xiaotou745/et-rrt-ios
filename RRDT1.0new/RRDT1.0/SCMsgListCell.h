//
//  SCMsgListCell.h
//  SupermanC
//
//  Created by riverman on 15/6/18.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

@interface SCMsgListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


@property (strong, nonatomic)MsgModel *model;

@end
