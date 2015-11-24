//
//  MyVersion.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/13.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyVersion : NSObject
/**最新版本号*/
@property (nonatomic,strong) NSString *version;
/**该版本是否强制更新*/
@property (nonatomic,strong) NSString *isMust;
/**下载地址*/
@property (nonatomic,strong) NSString *updateUrl;
/**版本升级提示信息*/
@property (nonatomic,strong) NSString *message;

@end
