//
//  CheckingTaskTableViewCell.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/27.
//  Copyright © 2015年 RRDT002. All rights reserved.
//
//  分享任务的cell

#import "ReceivedTableViewCell.h"

#import "CoreStatusBtn.h"

typedef void(^ReceiveBtnClick)(void);
@interface CheckingTaskTableViewCell : ReceivedTableViewCell

@property (nonatomic,strong) CoreStatusBtn *receiveBtn;

@property(copy)ReceiveBtnClick recBTNClick;
@end
