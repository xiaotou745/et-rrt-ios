//
//  HelpCenterViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/15.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "HelpCenterViewController.h"

@interface HelpCenterViewController ()<UIWebViewDelegate>
{
    UIWebView *myWeb;
}
@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助中心";
    
    self.view.backgroundColor = [UIColor whiteColor];
    myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    myWeb.delegate = self;
    [self.view addSubview:myWeb];
    
    
    [self loadWebPageWithString:@"http://m.renrenditui.cn/htmls/help.html"];
}
- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [myWeb loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"未知错误" offsetY:-100 failClickBlock:^{
        [self loadWebPageWithString:@"http://m.renrenditui.cn/htmls/help.html"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)delete:(id)sender{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

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
