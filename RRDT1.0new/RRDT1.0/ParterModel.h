//
//  ParterModel.h
//  RRDT1.0
//
//  Created by riverman on 16/1/15.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParterModel : NSObject

/**地推员和任务的绑定关系id*/
@property(strong,nonatomic)NSString *ctId;

/**地推员id*/
@property(strong,nonatomic)NSString *clienterId;

/**地推员姓名*/
@property(strong,nonatomic)NSString *clienterName;

/**地推员手机号*/
@property(strong,nonatomic)NSString *phoneNo;

/**地推员头像完全地址*/
@property(strong,nonatomic)NSString *headImage;

@end
