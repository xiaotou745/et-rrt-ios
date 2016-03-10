//
//  TaskDetailModel.h
//  RRDT1.0
//
//  Created by riverman on 15/12/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *模板组的类型id（1是文本组，2是图片组，3是多图组）
 */
typedef enum: NSUInteger{
    GroupTypeText=1,
    GroupTypeImg,
    GroupTypeImgs,

} GroupType;

/**
 *审核状态描述：待审核，通过，不通过
 */
typedef enum: NSUInteger{
    auditStatusWaiting=1,
    auditStatusPass,
    auditStatusRefuse,
    
} auditStatus;

@interface TaskDetailModel : NSObject


@property(strong,nonatomic)NSString *refuReason;//审核拒绝原因，资料被拒绝时，才需要显示出来
@property(strong,nonatomic)NSString *taskId;//任务Id
@property(strong,nonatomic)NSString *taskName;//任务名称
@property(assign,nonatomic)float amount;//任务单价
@property(assign,nonatomic)int taskType;//任务类型id（1分享类，2下载类，3签约类）
@property(strong,nonatomic)NSString *taskTypeName;//任务类型名称
@property(assign,nonatomic)int taskStatus;//任务状态码：1是进行中，3是过期，4是终止
@property(strong,nonatomic)NSString *taskStatusName;//任务状态描述：1是进行中，3是过期，4是终止
@property(strong,nonatomic)NSString *auditCycle;//(审核周期)
@property(strong,nonatomic)NSString *taskDatumId;//	资料id
@property(assign,nonatomic)int auditStatus;//审核状态描述：待审核，通过，不通过
@property(strong,nonatomic)NSString *createDate;//资料提交时间
@property(strong,nonatomic)NSString *auditTime;//资料审核过或不过的时间
@property(assign,nonatomic)int groupType;//模板组的类型id（1是文本组，2是图片组，3是多图组）
@property(strong,nonatomic)NSArray *titlesList;//资料的展示信息集合，集合中元素类型是字符串（groupType是文本组时，集合中是资料描述，否则是图片地址）
/** 标签名称 */
@property (nonatomic,strong) NSString *tagName;
/** 标签颜色编码 */
@property (nonatomic,strong) NSString *tagColorCode;

@property(strong,nonatomic)NSString *ctId;//推手任务绑定关系id
@property(strong,nonatomic)NSString *logo;//商家logo图片完整地址
@property(assign,nonatomic)long taskDatumCount;//当前状态下资料的总数

@end
