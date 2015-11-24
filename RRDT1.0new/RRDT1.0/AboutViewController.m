//
//  AboutViewController.m
//  myappinbuyyer
//
//  Created by XuLee on 15/8/21.
//  Copyright (c) 2015年 XuLee. All rights reserved.
//

#import "AboutViewController.h"
#import "MyTools.h"
@interface AboutViewController ()
{
    UITextView *txtview;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.translucent = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewCreat
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"人人地推用户协议";
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //    UITextView *txtview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-44)];
    txtview=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, HEIGHT-64-20)];
    txtview.layer.masksToBounds = YES;
    txtview.layer.cornerRadius = 10;
    txtview.layer.borderColor = [UIColor blackColor].CGColor;
    txtview.layer.borderWidth = 1.0f;
    [self.view addSubview:txtview];
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"UseTerm_CH" ofType:@"txt"];
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"PrivacyPolicy_CH" ofType:@"txt"];
    NSString *str1 = [NSString stringWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:nil];
    NSString *str2 = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
    txtview.text = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    txtview.editable = NO;
    
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
