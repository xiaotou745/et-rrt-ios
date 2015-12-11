//
//  ControlInfo.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlInfo : NSObject

/** 控件排序标识 */
@property (nonatomic,strong) NSString *orderNum;

/** groupId */
@property (nonatomic,strong) NSString *groupId;

/** 提交任务时的key */
@property (nonatomic,strong) NSString *controlKey;


/** 控件类型 1是Text 文本框 2是FileUpload 图片上传*/
@property (nonatomic,strong) NSString * controlTypeId;

/** 控件说明 */
@property (nonatomic,strong) NSString *controlTitle;

/** 控件选项 */
@property (nonatomic,strong) NSString *controlData;
/** 控件名称(提交合同参数key) */
//@property (nonatomic,strong) NSString *name;

/** 控件默认值（获取资料模板时有效） */
@property (nonatomic,strong) NSString *defaultValue;

/** 已经提交合同显示提交的值,没有的话显示空字符串 相对路径 控件值(获取资料详情时有效) */
@property (nonatomic,strong) NSString *controlValue;


/** 已经提交合同显示提交的值,没有的话显示空字符串 */
//@property (nonatomic,strong) NSString *hadValue;



@end
