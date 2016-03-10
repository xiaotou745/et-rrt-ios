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

#define appVersion @"110"

/**aes加密:开发、测试不加密  线上加密*/
#define isUseAESEncrypt 0

#pragma mark 用户接口

#define URL_All @"http://10.8.8.64:8080/renrenapihttp/services"
//#define URL_All @"http://api.renrentui.me/20160120/services"

/*
 *上传图片
 */
#define URL_PostImg @"http://10.8.8.64:8094/upload/fileupload/uploadimg"
//#define URL_PostImg @"http://upload.renrentui.me/upload/fileupload/uploadimg"



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
 *1.2.3 资料审核详情列表V1.0.2
 */
#define URL_Getmytaskdatumlist @"/taskdatum/getmytaskdatumlist"

/*
 *1.3.0 C获取资料详情(或资料模板)(java必须大小写符合)V1.0.2
 */
#define URL_Gettaskdatumdetail @"/taskdatum/gettaskdatumdetail"

/**1.3.1 获取消息列表V1.0.2
 */
#define URL_Getmymsglist @"/msg/getmymsglist"


/**1.3.2 删除或将消息置为已读V1.0.2
 */
#define URL_updatemsg @"/msg/updatemsg"

/**1.3.3 获取城市列表信息V1.0.2
 */
#define URL_Gethotregionandall @"/region/gethotregionandall"

/**1.3.4 绑定支付宝账号
 */
#define URL_bindalipay @"/userc/bindalipay"


/**1.3.5 获取未读消息数量
 */
#define URL_getmymsgcount @"/msg/getmymsgcount"

/**1.3.6 获取资金明细列表（收支记录）
 */
#define URL_getbalancerecordlist @"/userc/getbalancerecordlist"

/**1.3.7 资料审核详情分组后列表（新增）
 */
#define URL_getmytaskdatumgrouplist @"/taskdatum/getmytaskdatumgrouplist"

/**1.3.8 任务参与人列表（新增）
 */
#define URL_getclienterlistbytaskid @"/userc/getclienterlistbytaskid"

/**1.3.9 获取合伙人分红信息（新增）
 */
#define URL_getpartnerinfo @"/userc/getpartnerinfo"
/**
 1.4.0 分页获取合伙人列表（新增）
 */
#define URL_getpartnerlist @"/userc/getpartnerlist"


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
+ (void)closeKeyboard;
+ (void)call:(NSString *)phoneNumber atView:(UIView *)aView;

+(NSString *)getTasktypeImageName:(int)type;

+(NSString *)getTasktype:(int)type;
+(UIColor *)getTasktypeBGColor:(int)type;

/// 当前系统时间
+ (NSString *)currentTime;
@end

@interface MyTools (times)
/**
 去掉秒
 2015-12-16 10:49:08
 2015-12-16 10:49
 */
+(NSString *)timeString:(NSString *)string;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end

@interface MyTools (CityAddressManager)

//存储CityAddress.plist
+(void)writeToFile:(NSArray *)CityAddress;
//读取CityAddress.plist
+(NSArray *)readCityAddress;
@end