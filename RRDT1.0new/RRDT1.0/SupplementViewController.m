//
//  SupplementViewController.m
//  RRDT1.0
//
//  Created by riverman on 16/3/4.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "SupplementViewController.h"
#import "MNDatePicker.h"
#define DateFormateKeyDay @"newEventDateFormateKeyDay"
#define DateFormateKeyTime @"newEventDateFormateKeyTime"
#define DateFormateKeyFull @"NewEventDateFormateKeyFull"

@interface SupplementViewController ()<MNDatePicerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *birthText;
@property (weak, nonatomic) IBOutlet UIButton *confirmBTN;

@property (strong, nonatomic) MNDatePicker * datePicker;

// api value
@property (copy, nonatomic) NSString * birthDate;
@end

@implementation SupplementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _user = [[User alloc] init];
    
    _confirmBTN.backgroundColor=[UIColor colorWithRed:0 green:0.74 blue:0.84 alpha:1];

}

- (IBAction)confirmBTN:(id)sender {
    
    if (_nameTF.text.length==0) {
        [self postAlertWithMsg:@"名字不能为空"];
        return;
    }
    if (_nameTF.text.length>10) {
        [self postAlertWithMsg:@"名字的最大长度为10"];
        return;
    }
    if (_birthDate.length==0) {
        [self postAlertWithMsg:@"请选择出生日期"];
        return;
    }
    
    [self changeMyInfo];
}

#pragma mark 更改用户信息
- (void)changeMyInfo{
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        
        
        NSDictionary *parameters = @{@"userId"   : _user.userId,
                                     @"userName" : _nameTF.text,
                                     @"sex"      : @"",
                                     @"age"      :@( _user.age),
                                     @"headImage":@"",
                                     @"birthDay":_birthDate};
        
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        parameters=[parameters security];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_ChangeInfo] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"JSON: %@", responseObject);
            NSNumber *code = [responseObject objectForKey:@"code"];
            int code_int = [code intValue];
            if (code_int == 200) {
//                [self.view makeToast:@"修改成功" duration:1.0 position:CSToastPositionTop];
                
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:_user];
                NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
                [dd setObject:userData forKey:@"myUser"];
                [dd synchronize];

                [UIAlertView showAlertViewWithTitle:@"姓名设置成功" message:@"你还可以补全信息，让大家更好的认识你哦" cancelButtonTitle:@"去做任务" otherButtonTitles:@[@"补全个人信息"] onDismiss:^(NSInteger buttonIndex){
                    //补全个人信息
                    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app goto_MyCenterVC];
                    
                    
                } onCancel:^{
                    //去可接任务页面
                    [[NSNotificationCenter defaultCenter ]postNotificationName:notify_loginBackVC object:nil];
                }];
                
                
            }else{
                [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
-(void)gotoWaitVC{
    [[NSNotificationCenter defaultCenter]postNotificationName:notify_loginBackVC object:nil];

}
- (IBAction)selectBirthText:(id)sender {
    [self showDatePicker];
}

- (IBAction)selectBirth:(id)sender {
    [self showDatePicker];
}

#pragma mark - datePicker
- (void)showDatePicker{
    [self dismissDatePicker];
    self.datePicker = [[MNDatePicker alloc] initWithDelegate:self];
    self.datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.datePicker.date = [NSDate date];
    [self.datePicker showInView:self.view];
}

- (void)dismissDatePicker{
    [self.datePicker cancelPicker];
    self.datePicker.delegate = nil;
    self.datePicker = nil;
}

- (void)MNDatePickerDidSelected:(MNDatePicker *)datePicker{
  
    self.birthDate = [self dateDictionWithDate:datePicker.datePicker.date];
    _birthText.text=self.birthDate;

}

- (NSString *)dateDictionWithDate:(NSDate *)adate{
    NSDate * date = adate;
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    //    if ([adate isCurrentDay:[NSDate date]]) {
    //        [dateFormatter setDateFormat:@"MM月dd号(今天)"];
    //    }else{
    //        [dateFormatter setDateFormat:@"MM月dd号"];
    //    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString * dateString = [dateFormatter stringFromDate:localeDate];
    return dateString;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MyTools closeKeyboard];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
