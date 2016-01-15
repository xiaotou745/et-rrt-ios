//
//  PartnerViewController.m
//  RRDT1.0
//
//  Created by riverman on 16/1/8.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "PartnerViewController.h"
#import "ZXingObjC.h"

@interface PartnerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bonusTotal;
@property (weak, nonatomic) IBOutlet UILabel *partnerNum;
@property (weak, nonatomic) IBOutlet UILabel *recommendPhone;
@property (weak, nonatomic) IBOutlet UIImageView *appBar;
@end

@implementation PartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    self.title=@"我的合伙人";
    
    if (_recommendPhone__.length==0) {
        _recommendPhone__=@"无推荐人";
    }
    self.bonusTotal.textColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    self.bonusTotal.text=[NSString stringWithFormat:@"%.2f",[_bonusTotal__ floatValue]];
    self.recommendPhone.text=[_recommendPhone__ replaceNumberWithStar];
    self.partnerNum.text=_partnerNum__;
    
    
    [self creatBarView];
    
}
-(void)creatBarView{
 
       NSString *_downUrl=@"http://renrentui.me";
//    NSString *_downUrl=@"https://itunes.apple.com/us/app/ren-ren-tui-quan-min-de-tui/id1024858718?l=zh&ls=1&mt=8";
//    NSString *_downUrl=@"itms://itunes.apple.com/us/app/ren-ren-tui-quan-min-de-tui/id1024858718?l=zh&ls=1&mt=8";
//    NSString *_downUrl=@"itms-apps://itunes.apple.com/us/app/ren-ren-tui-quan-min-de-tui/id1024858718?l=zh&ls=1&mt=8";

    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:_downUrl
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        _appBar.image = [UIImage imageWithCGImage:image];
        
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
            if(index==0) {
//                 UIImageWriteToSavedPhotosAlbum(_appBar.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/ren-ren-tui-quan-min-de-tui/id1024858718?l=zh&ls=1&mt=8"]];
            }
            
        } onCancel:^(){
            
        }];
    }
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存失败" ;
    }else{
        msg = @"保存成功" ;
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
