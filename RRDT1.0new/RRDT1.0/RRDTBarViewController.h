//
//  RRDTBarViewController.h
//  RRDT1.0
//
//  Created by riverman on 15/12/3.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRDTBarViewController : UIViewController

/**
 downUrl	非签约任务 时 下载地址
 */
@property(strong,nonatomic)NSString *downUrl;
/**
 scanTip	非签约任务 时 扫码说明
 */
@property(strong,nonatomic)NSString *scanTip;
/**
 reminder	非签约任务 时 温馨提示
 */
@property(strong,nonatomic)NSString *reminder;
@property(assign)BOOL navBackToHomeVC;
@end
