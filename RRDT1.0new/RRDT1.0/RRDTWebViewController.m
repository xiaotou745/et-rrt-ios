//
//  RRDTWebViewController.m
//  RRDT1.0
//
//  Created by riverman on 15/12/2.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "RRDTWebViewController.h"

@interface RRDTWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *rrdtWebView;
@end

@implementation RRDTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=@"链接详情";
    self.title=self.navTitle;

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self createView];
}

-(void)createView{
    
        [_rrdtWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
    _rrdtWebView.scalesPageToFit=YES;
    [self.view addSubview:_rrdtWebView];
    
    _rrdtWebView.delegate=self;

}
- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
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
