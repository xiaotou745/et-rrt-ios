//
//  MsgModel.h
//  RRDT1.0
//
//  Created by riverman on 15/12/9.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgModel : NSObject

@property(strong,nonatomic)NSString *msgId;//消息Id
@property(strong,nonatomic)NSString *createDate;//消息Id
@property(strong,nonatomic)NSString *title;//消息内容
@property(strong,nonatomic)NSString *msg;//消息标题
@property(assign,nonatomic)int hasRead;//消息是否已读
@property(strong,nonatomic)NSString *taskId;//任务id

@end
