//
//  ControlInfo.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlInfo : NSObject

/** 控件类型 */
@property (nonatomic,strong) NSString *controlType;

/** 控件标题 */
@property (nonatomic,strong) NSString *title;

/** 控件名称(提交合同参数key) */
@property (nonatomic,strong) NSString *name;

/** 默认值 */
@property (nonatomic,strong) NSString *defaultValue;

/** 控件值 */
@property (nonatomic,strong) NSString *controlData;

/** 控件排序标识 */
@property (nonatomic,strong) NSString *orderNum;

/** 已经提交合同显示提交的值,没有的话显示空字符串 */
@property (nonatomic,strong) NSString *hadValue;
/** 已经提交合同显示提交的值,没有的话显示空字符串 相对路径 */
@property (nonatomic,strong) NSString *controlValue;

@end
