//
//  User.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/24.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCopying,NSMutableCopying,NSCoding>

@property (nonatomic,strong)NSString *userId;

@property (nonatomic,assign)BOOL     isLogin;

@property (nonatomic,strong)NSString *userPhoneNo;

@property (nonatomic,strong)NSString *fullHeadImage;

#pragma mark 用户资料
@property (nonatomic,assign)NSInteger   age;

@property (nonatomic,assign)NSInteger   sex;
@property (nonatomic,strong)NSString   *birthDay;

@property (nonatomic,strong)NSString    *userName;

@property (nonatomic,strong)NSString    *cityName;

@property (nonatomic,strong)NSString    *education;

@property (nonatomic,strong)NSString    *headImage;

#pragma mark 用户收入信息

/**余额*/
@property (nonatomic,assign)float    balance;
/**正在审核中的金额*/
@property (nonatomic,assign)float    checking;
/**已提现金额*/
@property (nonatomic,assign)float    hadWithdraw;
/**可提现金额*/
@property (nonatomic,assign)float    withdraw;
/**提现中的金额*/
@property (nonatomic,assign)float    withdrawing;
/**累计财富*/
@property (nonatomic,assign)float    totalAmount;

#pragma mark 用户金融信息

/**提现账号*/
@property (nonatomic,strong)NSString    *accountNo;
/**账号实名*/
@property (nonatomic,strong)NSString    *trueName;
/**账号类型 账号类型(-1没绑定 1网银 2支付宝 3微信 4财付通 5百度钱包)（新增，本版只支持支付宝）*/
@property (nonatomic,assign)int    accountType;

+(id)create;//声明创建对象的方法

@end
