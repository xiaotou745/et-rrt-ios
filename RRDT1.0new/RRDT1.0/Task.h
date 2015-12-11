//
//  Task.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/9.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

///** 类型 签约 分享 下载   */
typedef enum : NSUInteger {
    taskType_write=1,
    taskType_share,
    taskType_download,
} taskType_ENUM;



@interface Task : NSObject

/** 任务ID */
@property (nonatomic,strong) NSString *taskId;
/** 任务Title */
@property (nonatomic,strong) NSString *taskTitle;
/** 任务描述 */
@property (nonatomic,strong) NSString *taskGeneralInfo;
/** 任务公告 */
@property (nonatomic,strong) NSString *taskNotice;
/** 任务注意事项 */
@property (nonatomic,strong) NSString *taskNote;
/** 发布人 */
@property (nonatomic,strong) NSString *pusher;
/** 任务名称 */
@property (nonatomic,strong) NSString *taskName;
/** 任务单价 */
@property (nonatomic,assign) float amount;
/** 任务剩余量 */
@property (nonatomic,strong) NSString *availableCount;
/** 开始时间 */
@property (nonatomic,strong) NSString *beginTime;
/** 结束时间 */
@property (nonatomic,strong) NSString *endTime;
/** 结算方式 */
@property (nonatomic,strong) NSString *paymentMethod;
/** logo图片地址 */
@property (nonatomic,strong) NSString *logo;
/** 任务状态 -1未领取 0已领取 1已提交 */
@property (nonatomic,strong) NSString *status;
/** 任务类型（字符串文本） */
@property (nonatomic,assign) int    taskType;
@property (nonatomic,strong) NSString *taskTypeName;

@property (nonatomic,assign) int    auditPassNum;
@property (nonatomic,assign) int    auditRefuseNum;
@property (nonatomic,assign) int    auditWaitNum;
@property (nonatomic,assign) int    complateNum;


//已经领取额外添加

/** 已领取的任务,orderId(订单号) */
@property (nonatomic,strong) NSString *myReceivedTaskId;
/** 任务生命周期 */
@property (nonatomic,strong) NSString *taskCycle;
/** 领取任务的时间 */
@property (nonatomic,strong) NSString *receivedTime;
/** 任务审核时间 */
@property (nonatomic,strong) NSString *auditTime;

/** 咨询电话 */
@property (nonatomic,strong) NSString *hotLine;
/** ishad =1 时才有 否则为0地推任务关系ID */
@property (nonatomic,strong) NSString *ctId;


//已经提交额外添加

/** 任务提交时间 */
@property (nonatomic,strong) NSString *finishTime;
/** 待审核任务数量 */
@property (nonatomic,strong) NSString *waitAuditCount;
/** 审核状态0待审核，2审核通过，3审核拒绝，默认0待审核 */
@property (nonatomic,strong) NSString *auditStatus;

/** 任务审核周期 */
@property (nonatomic,strong) NSString *auditCycle;
/** 公司简介 */
@property (nonatomic,strong) NSString *companySummary;
/** 1 已领取 0未领取 */
@property (nonatomic,strong) NSString *isHad;
/** 商家ID */
@property (nonatomic,strong) NSString *businessId;
/** 合同模板ID */
@property (nonatomic,strong) NSString *templateId;
/** 合同模板名称 */
@property (nonatomic,strong) NSString *templateName;
/** 模板控件信息(list集合) */
@property (nonatomic,strong) NSArray  *controlInfo;
/** 如果已领取任务 这是是orderId 否则0 */
@property (nonatomic,strong) NSString *orderId;


/** 是否允许再次接单 1允许 0不允许 */
@property (nonatomic,strong) NSString *isAgainPickUp;

/** 取消时间，可为null */
@property (nonatomic,strong) NSString *cancelTime;
/** 订单结束时间，可为null */
@property (nonatomic,strong) NSString *dealLineTime;


@end
