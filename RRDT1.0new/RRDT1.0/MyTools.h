//
//  MyTools.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/18.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Toast.h"
#import <Masonry.h>
#import "MBProgressHUD.h"
#import "User.h"
#import "CoreStatus.h"
#import "UIScrollView+MJExtension.h"
#import "CoreViewNetWorkStausManager.h"
#import "Security.h"
#import "HttpHelper.h"
#import "JSONKit.h"
#import "Task.h"
#import <MJRefresh.h>
#import <UIScrollView+EmptyDataSet.h>
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "MyMD5.h"
#import "CustomIOSAlertView.h"

#define HEIGHT     [[UIScreen mainScreen] bounds].size.height //获取屏幕的高度
#define WIDTH      [[UIScreen mainScreen] bounds].size.width  //获取屏幕的宽度

#define appVersion @"101"

#pragma mark 用户接口
//#define URL_All @"http://192.168.1.224:8080/renrenapihttp/services"
#define URL_All @"http://10.8.8.64:8080/renrenapihttp/services"
//#define URL_All @"http://apinew.renrenditui.cn/20151105/services/"
/*
 *上传图片
 */
#define URL_PostImg @"http://10.8.8.62:8188/upload/uploadimg?uploadfrom="
//#define URL_PostImg @"http://upload.renrenditui.cn/upload/uploadimg?uploadfrom="
/*
 *得到图片
 */
#define URL_GetImg @"http://192.168.1.222:8189"
//#define URL_GetImg @"http://img.renrenditui.cn"


/*
 *获取验证码
 */
#define URL_VerifyCode @"/userc/sendcode"
/*
 *用户登录  15711331552
 */
#define URL_UserLogin @"/userc/signin"
/*
 *用户注册
 */
#define URL_UserRegister @"/userc/signup"
/*
 *修改密码
 */
#define URL_ChangePassword @"/userc/modifypwd"
/*
 *忘记密码
 */
#define URL_ForgetPassword @"/userc/forgotpwd"
/*
 *用户信息
 */
#define URL_MyInmoney @"/userc/getuserc"
/*
 *申请提现
 */
#define URL_WithDraw @"/userc/withdraw"
/*
 *修改用户信息
 */
#define URL_ChangeInfo @"/userc/modifyuserc"



#pragma mark 任务接口
/*
 *获取未领取任务
 */
#define URL_GetNewTaskList @"/task/getnewtasklist"
/*
 *获取已经领取任务
 */
#define URL_GetreceiveTaskList @"/task/getmyreceivedtasklist"
/*
 *获取全部任务
 */
#define URL_GetAlltaskList @"/task/getsubmittedtasklist"
/*
 *任务详情
 */
#define URL_TaskContent @"/task/taskdetail"
/*
 *领取任务
 */
#define URL_ReceiverTask @"/task/gettask"
/*
 *放弃任务
 */
#define URL_GiveUpTask @"/task/canceltask"
/*
 *提交任务
 */
#define URL_PostTask @"/task/submittask"



/*
 *版本更新
 */
#define URL_GetVersion @"/common/versioncheck"


#pragma mark 16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBandAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(float)alphaValue]

#define IOS_VERSION   ([[[UIDevice currentDevice] systemVersion] floatValue])

#define MYCOLOR 0x38b0de
#define MYCOLOR1 0x89c997

#define WRITEColor  0xffffff
#define BLUEColor   0x0090ce
#define GRARYColor  0x767676

@interface MyTools : NSObject

@end
