//
//  BillDetailModel.h
//  RRDT1.0
//
//  Created by riverman on 16/1/11.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillDetailModel : NSObject

@property(nonatomic,assign)long recordId;
@property(nonatomic,assign)float amount;
@property(nonatomic,assign)long recordType;
@property(nonatomic,strong)NSString  *statusName;
@property(nonatomic,strong)NSString  *recordTypeName;
@property(nonatomic,strong)NSString  *operateTime;
@property(nonatomic,strong)NSString  *remark;
@property(nonatomic,strong)NSString  *relationNo;

@end
