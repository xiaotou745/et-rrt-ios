//
//  AgainLoginViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/11/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "AgainLoginViewController.h"

#import "RegisterViewController.h"

@interface AgainLoginViewController ()

@end

@implementation AgainLoginViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerBtnClick{
    
    RegisterViewController *registerView = [[RegisterViewController alloc]init];
    
    registerView.againType = 999;
    
    [self.navigationController pushViewController:registerView animated:YES];
    
}
- (void)backBarButtonPressed{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)dissmissLogin{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
