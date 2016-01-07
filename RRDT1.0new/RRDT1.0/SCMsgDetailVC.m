//
//  SCMsgDetailVC.m
//  SupermanC
//
//  Created by riverman on 15/6/18.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "SCMsgDetailVC.h"

@interface SCMsgDetailVC ()

@end

@implementation SCMsgDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息中心";
    [self configData];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFY_Mark_read_message object:nil];
}
//-(void)getDetailInfo
//{
//
//    
//    [self showProgressWithTitle:nil];
//    [SLAppAPIClient getMesssageWithMessageId:self.msgId success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self hiddenProgress];
//        if ([responseObject[@"Status"]intValue] ==1) {
//            
//            self.infoDic=responseObject[@"Result"];
//            [self configData];
//            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_Mark_read_message object:nil];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self hiddenProgress];
//
//    }];
//
//}

-(void)configData
{
//    UILabel *titleLabel=[ManFactory createLabelWithFrame:CGRectMake(20, 80, DEF_SCEEN_WIDTH-40, 30) Font:18 Text:self.infoDic[@"Content"]];
//    
    UILabel *timeLabel=[ManFactory createLabelWithFrame:CGRectMake(10,6, 200, 30) Font:16 Text:_model.createDate];

    NSString * contents = _model.msg;
    UITextView *infoText=[ManFactory createTextViewWithFrame:CGRectMake(5, timeLabel.bottom, DEF_SCEEN_WIDTH-10, DEF_SCEEN_HEIGHT-timeLabel.bottom) textFont:14   textString:[NSString stringWithFormat:@"    %@",contents] isEditable:NO];
    
    infoText.textColor=[UIColor grayColor];
    infoText.backgroundColor=self.view.backgroundColor;
    
    //不显示 标题
//    [self.view addSubview:titleLabel];
    [self.view addSubview:timeLabel];
    [self.view addSubview:infoText];
    
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
