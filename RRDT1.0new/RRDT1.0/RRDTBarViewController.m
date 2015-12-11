//
//  RRDTBarViewController.m
//  RRDT1.0
//
//  Created by riverman on 15/12/3.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "RRDTBarViewController.h"
#import "ZXingObjC.h"

@interface RRDTBarViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *barImgV;
@end

@implementation RRDTBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"邀请扫码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
    _titleLab.textColor=UIColorFromRGB(0x00bcd5);
    [self creatBarView];
    
}
- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatBarView{

    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:_urlString
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        _barImgV.image = [UIImage imageWithCGImage:image];
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString *errorMessage = [error localizedDescription];
        
        NSLog(@"%@",errorMessage);
        
    }
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
