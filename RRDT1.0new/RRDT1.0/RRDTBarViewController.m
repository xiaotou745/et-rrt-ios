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
@property (weak, nonatomic) IBOutlet UILabel *scanTipLab;
@property (weak, nonatomic) IBOutlet UIImageView *barImgV;
@property (weak, nonatomic) IBOutlet UILabel *reminderLab;

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
    if (_navBackToHomeVC)    [self.navigationController popToRootViewControllerAnimated:YES];

   else [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatBarView{

    _scanTipLab.text=_scanTip;
    _reminderLab.text=_reminder;
    
    if (_downUrl==nil||_downUrl.length==0) {
        _downUrl=@"http://renrentui.me";
    }
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:_downUrl
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
- (IBAction)longPress:(id)sender {
    UILongPressGestureRecognizer *longPress=(UILongPressGestureRecognizer *)sender;
    
    if(longPress.state==UIGestureRecognizerStateBegan){
        [UIAlertView showAlertViewWithTitle:@"您要将二维码保存到相册吗" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger index){
            if(index==0)     UIImageWriteToSavedPhotosAlbum(_barImgV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            
        } onCancel:^(){
            
        }];
    }
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];

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
