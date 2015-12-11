//
//  ControlTemplate.h
//  RRDT1.0
//
//  Created by riverman on 15/12/8.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *组类型 1 文字组 2 图片组 3多图组
 */typedef enum: NSUInteger{
     groupTypeText=1,
     groupTypeImage,
     groupTypeImages,
     
 } GroupType;

@interface ControlTemplate : NSObject

/** 组id */
@property (nonatomic,strong) NSString *groupId;
/** 组类型 组类型 1 文字组 2 图片组 3多图组 */
@property (nonatomic,assign) int groupType;
/** 资料ID（获取资料详情时必传*/
@property (nonatomic,strong) NSString *taskDatumId;
/** 任务ID */
@property (nonatomic,strong) NSString *taskId;
/** 组标题 */
@property (nonatomic,strong) NSString *title;
/** 控件值 */
@property (nonatomic,strong) NSArray *controlList;
@end
