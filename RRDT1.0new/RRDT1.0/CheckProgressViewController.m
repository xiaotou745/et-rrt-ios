//
//  CheckProgressViewController.m
//  RRDT1.0
//
//  Created by riverman on 15/12/5.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "CheckProgressViewController.h"
#import "PostContractViewController.h"
@interface CheckProgressViewController ()



@property (weak, nonatomic) IBOutlet UILabel *submitText;
@property (weak, nonatomic) IBOutlet UILabel *submitTime;
@property (weak, nonatomic) IBOutlet UIImageView *submitIcon;

@property (weak, nonatomic) IBOutlet UILabel *checkResult;
@property (weak, nonatomic) IBOutlet UILabel *checkTime;
@property (weak, nonatomic) IBOutlet UIImageView *checkIcon;
@property (weak, nonatomic) IBOutlet UIImageView *lineIcon;


@property (weak, nonatomic) IBOutlet UIButton *lookDetailBTN;
@property (weak, nonatomic) IBOutlet UIButton *editBTN;

@end

@implementation CheckProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    self.title=@"审核详情";
    [self configDatas];
}


-(void)configDatas{
    
    _lookDetailBTN.layer.cornerRadius=5;
    _lookDetailBTN.layer.masksToBounds=YES;
    _lookDetailBTN.layer.borderColor=UIColorFromRGB(0x00bcd5).CGColor;
    _lookDetailBTN.layer.borderWidth=1;
    _lookDetailBTN.backgroundColor=[UIColor whiteColor];
    [_lookDetailBTN setTitleColor:UIColorFromRGB(0x00bcd5) forState:UIControlStateNormal];
    
    _editBTN.layer.cornerRadius=5;
    _editBTN.layer.masksToBounds=YES;
    _editBTN.layer.borderWidth=1;
    if ([_model.taskStatus isEqualToString:@"已过期"]) {
        _editBTN.enabled=NO;
        _editBTN.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _editBTN.backgroundColor=[UIColor lightGrayColor];
        [_editBTN setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }else{
        _editBTN.layer.borderColor=UIColorFromRGB(0x00bcd5).CGColor;
        _editBTN.backgroundColor=UIColorFromRGB(0x00bcd5);
        [_editBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
   
    _lineIcon.backgroundColor=UIColorFromRGB(0x00bcd5);
    
    
    _submitText.textColor=UIColorFromRGB(0x00bcd5);
    _submitTime.text=_model.createDate;
    _submitTime.textColor=UIColorFromRGB(0x00bcd5);

    _checkResult.text=[self auditStatus:_model.auditStatus];
    
    if (auditStatusPass== _model.auditStatus) {
        _checkIcon.image=[UIImage imageNamed:@"TaskDetail_pass"];
        _checkTime.text=_model.auditTime;

    }else if (auditStatusWaiting== _model.auditStatus){
        _checkIcon.image=[UIImage imageNamed:@"TaskDetail_wait"];
        _checkTime.text = [NSString stringWithFormat:@"审核周期%@天",_model.auditCycle];


    }else if (auditStatusRefuse== _model.auditStatus){
        _checkIcon.image=[UIImage imageNamed:@"TaskDetail_refuse"];
        _checkTime.text=_model.auditTime;

    }
    
   
}
- (IBAction)lookDetailBTN:(id)sender {

    PostContractViewController *post = [[PostContractViewController alloc] init];
    post.taskId = _model.taskId;
    post.taskDatumId=_model.taskDatumId;
    post.tag = 222;
    post.onlyType = 999;
    [post postGetMyTask];
    [self.navigationController pushViewController:post animated:YES];

}

- (IBAction)editBTN:(id)sender {

    PostContractViewController *post = [[PostContractViewController alloc] init];
    post.taskId = _model.taskId;
    post.taskDatumId=@"";
    post.tag = 111;
    post.onlyType = 999;
    [post postGetMyTask];
    [self.navigationController pushViewController:post animated:YES];
}

-(NSString *)auditStatus:(NSInteger)status{
    NSString *auditStatus;
    if (auditStatusPass==status) {
        auditStatus=@"审核通过";
    }else if (auditStatusWaiting==status){
        auditStatus=@"审核中";
    }else if (auditStatusRefuse==status){
        auditStatus=@"审核未通过";
    }
    return auditStatus;

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
