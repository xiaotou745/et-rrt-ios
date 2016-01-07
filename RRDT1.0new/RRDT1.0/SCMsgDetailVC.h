//
//  SCMsgDetailVC.h
//  SupermanC
//
//  Created by riverman on 15/6/18.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

/*
    消息详情
 */

#import "BackBaseViewController.h"
#import "MsgModel.h"
#define NOTIFY_Mark_read_message @"NOTIFY_Mark_read_message"
@interface SCMsgDetailVC : BackBaseViewController

@property(strong, nonatomic)NSDictionary *titleDic;
@property(strong, nonatomic)NSDictionary *infoDic;
@property(strong, nonatomic)MsgModel *model;

// msgId
@property (copy, nonatomic) NSString * msgId;

@end
