//
//  MyInfoViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/23.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSArray *arr1;
    
    NSMutableArray *userArr1 ;
}
@property (nonatomic,strong)UITableView *mytable;

@property (nonatomic,strong)UIImageView *headImage;

@property (nonatomic,strong)NSData *user_imgdata;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewCreat];
    
    
    self.title = @"个人资料";
    
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"请检查网络设置" offsetY:-100 failClickBlock:^{
            NSLog(@"?>?>>>>>??>?>");
            [self getMyInfo];
        }];
    }else{
        [self getMyInfo];
    }
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backTo)];
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}
- (void)viewCreat{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _user = [[User alloc] init];
    userArr1 = [NSMutableArray array];
    arr1 = @[@"头像",@"姓名",@"手机",@"性别",@"年龄"];

    
    _mytable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.showsVerticalScrollIndicator = NO;
    _mytable.showsHorizontalScrollIndicator = NO;
    _mytable.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [self.view addSubview:_mytable];
    
    [_mytable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(-0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(-0);
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(changeMyInfo)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"0xffffff" alpha:0.8]];
    
    
//    _mytable.tableFooterView = [UIView new];
//    _mytable.tableHeaderView = [UIView new];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , 0)];
//    view.backgroundColor = UIColorFromRGB(0xf9f9f9);
//    _mytable.tableHeaderView = view;
}
#pragma mark 更改用户信息
- (void)changeMyInfo{
        NSLog(@">>>>>>%@",userArr1);
    if ([[CoreStatus currentNetWorkStatusString]isEqualToString:@"无网络"]) {
        [self.view makeToast:@"当前没有网络" duration:1.0 position:CSToastPositionTop];
    }else{
        AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
        
        NSDictionary *parameters = @{@"userId"   : _user.userId,
                                     @"userName" : [userArr1 objectAtIndex:1],
                                     @"sex"      : [userArr1 objectAtIndex:3],
                                     @"age"      : [userArr1 objectAtIndex:4],
                                     @"headImage": [userArr1 objectAtIndex:0]};
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_ChangeInfo] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"JSON: %@", responseObject);
            NSNumber *code = [responseObject objectForKey:@"code"];
            int code_int = [code intValue];
            if (code_int == 200) {
                [self.view makeToast:@"修改成功" duration:1.0 position:CSToastPositionTop];
                
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:_user];
                NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
                [dd setObject:userData forKey:@"myUser"];
                NSLog(@">>>data>>>%@",_user_imgdata);
                [dd setValue:_user_imgdata forKey:@"userimage"];
                [dd synchronize];
                
                
            }else{
                [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
#pragma mark 获得用户信息
- (void)getMyInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    
    NSLog(@">>>>>>%@",_user.userId);
    NSDictionary *parameters = @{@"userId": _user.userId};
    

    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_MyInmoney] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@">>>>>%@",operation);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
            
            _user.userName = [[responseObject objectForKey:@"data"] objectForKey:@"clienterName"];
            _user.userPhoneNo = [[responseObject objectForKey:@"data"] objectForKey:@"phoneNo"] ;
            
            _user.sex = [[[responseObject objectForKey:@"data"] objectForKey:@"sex"] integerValue];
            _user.age = [[[responseObject objectForKey:@"data"] objectForKey:@"age"] integerValue];
            _user.fullHeadImage = [[responseObject objectForKey:@"data"] objectForKey:@"fullHeadImage"];
            _user.headImage = [[responseObject objectForKey:@"data"] objectForKey:@"headImage"];
            [userArr1 addObject:_user.headImage];
            [userArr1 addObject:_user.userName];
            [userArr1 addObject:_user.userPhoneNo];
            [userArr1 addObject:[NSString stringWithFormat:@"%zi",_user.sex]];
            [userArr1 addObject:[NSString stringWithFormat:@"%zi",_user.age]];

            [_mytable reloadData];
            
            NSLog(@"-----%@",userArr1);
        }else{
            [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:[responseObject objectForKey:@"msg"] offsetY:-100 failClickBlock:^{
                NSLog(@"?>?>>>>>??>?>");
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"未知错误" offsetY:-100 failClickBlock:^{
            NSLog(@"?>?>>>>>??>?>");
        }];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark 列表代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return userArr1.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenifier];
        cell.backgroundColor = UIColorFromRGB(0xf9f9f9);
    }
        cell.textLabel.text = [arr1 objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            _headImage = [[UIImageView alloc] init];
            NSURL *myUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_user.fullHeadImage]];
            if (_user.fullHeadImage.length != 0) {
                NSUserDefaults *dd = [NSUserDefaults standardUserDefaults];
                NSData *myData = [dd objectForKey:@"userimage"];
                if (myData.length == 0) {
                    [_headImage sd_setImageWithURL:myUrl placeholderImage:nil options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                            _headImage.image = [UIImage imageNamed:@"icon_usermorentu"];;
                        }else{
                            [dd setValue:UIImagePNGRepresentation(image) forKey:@"userimage"];
                        }
                        
                    }];
                }else{
                    [_headImage sd_setImageWithURL:myUrl placeholderImage:[UIImage imageWithData:myData] options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if (error) {
                            _headImage.image = [UIImage imageWithData:myData];
                        }else{
                            [dd setValue:UIImagePNGRepresentation(image) forKey:@"userimage"];
                        }
                    }];
                }

            }else{
                _headImage.image = [UIImage imageNamed:@"icon_usermorentu"];
            }
            
            [cell.contentView addSubview:_headImage];
            [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(10);
                make.right.equalTo(cell.contentView).with.offset(-10);
                make.width.equalTo(@60);
                make.height.equalTo(@60);
            }];
        }else if(indexPath.row == 1){
            if (userArr1.count == 5) {
                    cell.detailTextLabel.text = [userArr1 objectAtIndex:indexPath.row];
            }
            
        }else if (indexPath.row == 2){
            cell.detailTextLabel.text = [[userArr1 objectAtIndex:indexPath.row] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }else if (indexPath.row == 3){
            if ([[userArr1 objectAtIndex:3] isEqualToString:@"1"]) {
                cell.detailTextLabel.text = @"男";
            }else if([[userArr1 objectAtIndex:3] isEqualToString:@"2"]){
                cell.detailTextLabel.text = @"女";
            }
        }else if (indexPath.row == 4){
            cell.detailTextLabel.text = [userArr1 objectAtIndex:indexPath.row];
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        if (indexPath.row == 0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"拍照",@"相册", nil];
            actionSheet.tag = 99;
            [actionSheet showInView:self.view];
        }else if (indexPath.row == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改姓名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alert textFieldAtIndex:0] setText:[userArr1 objectAtIndex:1]];
            [alert show];
            alert.tag = 999;
        }else if (indexPath.row == 2){
            
        }else if (indexPath.row == 3){
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"男",@"女", nil];
            actionSheet.tag = 111;
            [actionSheet showInView:self.view];
        }else if (indexPath.row == 4){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改年龄" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alert textFieldAtIndex:0] setText:[userArr1 objectAtIndex:1]];
            [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
            [[alert textFieldAtIndex:0] setClearsOnBeginEditing:YES];
            alert.tag = 9999;
            [alert show];

        }

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%zi",buttonIndex);
    
    if (actionSheet.tag == 111){
        
        [userArr1 replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%zi",buttonIndex+1]];
        
        [_mytable reloadData];
    }else if (actionSheet.tag == 99){
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePickerController.delegate = self;
        
        
        if (buttonIndex == 0) {
            //拍照
            BOOL flag = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if (flag) {
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;//相机
                [self presentViewController:imagePickerController animated:YES completion:^{
                    
                }];
            }
        }else if (buttonIndex == 1){
            //图片库
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//图片库
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _headImage.image = image;
    
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    
    [self postImg:data];
    
    _user_imgdata = data;
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [[alertView textFieldAtIndex:0] resignFirstResponder];
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            [userArr1 replaceObjectAtIndex:1 withObject:[[[alertView textFieldAtIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [_mytable reloadData];
        }
    }else if (alertView.tag == 9999){
        if (buttonIndex == 1) {
            if ([[[alertView textFieldAtIndex:0] text] intValue]<0||[[[alertView textFieldAtIndex:0] text] intValue]>120) {
                [self.view makeToast:@"年龄有误" duration:1.0 position:CSToastPositionTop];
            }else{
                [userArr1 replaceObjectAtIndex:4 withObject:[[alertView textFieldAtIndex:0] text]];
                [_mytable reloadData];
            }
            
        }
    }
}

//取消点击
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)postImg:(NSData *)img_data{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    [manager POST:[NSString stringWithFormat:@"%@2",URL_PostImg] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:img_data name:@"imgstream" fileName:@"idCardImg.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@">>>%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"Status"] integerValue]== 1) {
            _user.fullHeadImage = [[responseObject objectForKey:@"Result"] objectForKey:@"FileUrl"];
            [userArr1 replaceObjectAtIndex:0 withObject:[[responseObject objectForKey:@"Result"] objectForKey:@"RelativePath"]];
            
        }else{
            [self.view makeToast:[responseObject objectForKey:@"Message"] duration:1.0 position:CSToastPositionTop];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"-----%@",operation);
        NSLog(@"===+++++%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"图片上传失败" duration:1.0 position:CSToastPositionTop];
    }];
 
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
