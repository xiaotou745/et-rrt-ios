//
//  TaskStep.h
//  RRDT1.0
//
//  Created by riverman on 15/11/30.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

///** 类型 1 步骤 2 补充说明 3 细则(URL链接) */
typedef enum : NSUInteger {
    setpType_step=1,
    setpType_content,
    setpType_urlLink,
} setpType_ENUM;

@interface TaskStep : NSObject

/** 具体内容 setpType为 1 或者2 时,是文本内容 为3 时 是链接地址Url */
@property (nonatomic,strong) NSString *content;
/** 任务ID */
@property (nonatomic,strong) NSString *id;
/** 链接文本(SetpType=3才有用) */
@property (nonatomic,strong) NSString *linkTitle;
/** 类型 1 步骤 2 补充说明 3 细则(URL链接) */
@property (nonatomic,strong) NSString *setpType;
/** 排序 */
@property (nonatomic,strong) NSString *sortNo;
/** 任务ID */
@property (nonatomic,strong) NSString *taskId;

@end
