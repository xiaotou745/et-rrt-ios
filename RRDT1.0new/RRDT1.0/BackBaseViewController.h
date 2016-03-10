//
//  BackBaseViewController.h
//  2015-01-10-UINavigation封装Demo
//
//  Created by TangJR on 15/1/10.
//  Copyright (c) 2015年 tangjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface BackBaseViewController : UIViewController
{
    User *_user;

}
- (void)hideTabBar;
- (void)showTabBar;
- (void)postAlertWithMsg:(NSString *)msg;
@end
