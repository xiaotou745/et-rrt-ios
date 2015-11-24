//
//  PostContractViewController.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "PostContractViewController.h"

#import "ContractImageTableViewCell.h"

#include "ContractTextTableViewCell.h"

#import "CoreLabel.h"

#import "ControlInfo.h"

#import "CoreStatusBtn.h"

#import "UIButton+WebCache.h"

#import "TPKeyboardAvoidingTableView.h"

@interface PostContractViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *arr_image;
    NSMutableArray *arr_text;
    NSMutableArray *arr_all;
    
    NSMutableDictionary *value;
    
    
    NSString *img_str;
    NSInteger img_tag;
    
//    NSMutableDictionary *image_Dic;
    NSMutableArray *image_Dic;
    
    
    NSMutableArray *value_arr;
    

    NSMutableArray *arr_imageValue;
    NSMutableArray *arr_textValue;
    
    UIView *topView;
    
//    UIView *top_footView;
}
/** 主照片 */
@property (nonatomic,strong) UIImageView        *headImageView;
/** 标题 */
@property (nonatomic,strong) UILabel            *headLabel;
/** 公告 */
@property (nonatomic,strong) UILabel            *infoLabel;
/** 公告img */
@property (nonatomic,strong) UIImageView        *img_info;
/** 金额 */
@property (nonatomic,strong) CoreLabel          *moneyLabel;



@property (nonatomic,strong) UILabel            *titleLab;

@property (nonatomic,strong) UILabel            *centerLab;

@property (nonatomic,strong) TPKeyboardAvoidingTableView        *mytable;

@property (nonatomic,strong) CoreStatusBtn      *postBtn;

//键盘高度
@property (nonatomic,assign) CGFloat            keyBoardHeight;

@property (nonatomic,strong) UIToolbar          *myTololBar;

@end

@implementation PostContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"提交审核";
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [_delegate backPostContract];
}
- (void)viewCreat{
    
    arr_image   = [NSMutableArray array];
    arr_text    = [NSMutableArray array];
    arr_all     = [NSMutableArray array];
    value       = [NSMutableDictionary dictionary];
    value_arr   = [NSMutableArray array];
    
    arr_imageValue = [NSMutableArray array];
    arr_textValue  = [NSMutableArray array];
    
    image_Dic = [NSMutableArray array];
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    
    

    
    
    [topView addSubview:[self headImageView]];
    [topView addSubview:[self headLabel]];
    [topView addSubview:[self moneyLabel]];
    [topView addSubview:[self infoLabel]];
    [topView addSubview:[self img_info]];
    
    
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(15);
        make.left.equalTo(topView).with.offset(12);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(15);
        make.left.mas_equalTo(_headImageView.mas_right).offset(15);
        make.right.equalTo(topView).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(_img_info.mas_right).offset(5);
        make.right.equalTo(topView).with.offset(-10);
        make.height.equalTo(@30);
        
    }];
    
    [_img_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headLabel.mas_bottom).offset(7.5);
        make.left.mas_equalTo(_headImageView.mas_right).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headLabel.mas_bottom).offset(0);
        make.right.equalTo(topView).with.offset(-10);
        make.left.mas_equalTo(_infoLabel.mas_right).offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, WIDTH, 10)];
    lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [topView addSubview:lineView];
    
    _headImageView = [[UIImageView alloc]init];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_task.logo]] placeholderImage:[UIImage imageNamed:@"icon_morentu"] options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

    
    _moneyLabel.textColor = [UIColor clearColor];
    _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f/次",_task.amount];
    [_moneyLabel addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(0,1)];
    [_moneyLabel addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(1,_moneyLabel.text.length - 3)];
    [_moneyLabel addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:10] range:NSMakeRange(_moneyLabel.text.length - 2,2)];
    [_moneyLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(0,_moneyLabel.text.length - 2)];
    [_moneyLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(_moneyLabel.text.length - 2,2)];
    
    _headLabel.text = _task.taskTitle;
    _infoLabel.text = [NSString stringWithFormat:@"审核 %@天",_task.auditCycle];

    
    if (_tag != 333) {
        _mytable = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - HEIGHT/15 - 20) style:UITableViewStylePlain];
    }else{
        _mytable = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    }

    _mytable.delegate = self;
    _mytable.dataSource = self;
    _mytable.tableFooterView = [UIView new];
    [self.view addSubview:_mytable];
    _mytable.backgroundColor = UIColorFromRGB(0xe8e8e8);
    _mytable.tableHeaderView = topView;


    
    

    if (_tag!= 333) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 64 - (HEIGHT/15 + 20), WIDTH, HEIGHT/15 + 20)];
        footView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        _postBtn = [[CoreStatusBtn alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, HEIGHT/15)];
        _postBtn.layer.cornerRadius = 4;
        _postBtn.layer.masksToBounds = YES;
        [_postBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _postBtn.backgroundColorForNormal = UIColorFromRGB(0x00bcd5);
        _postBtn.shutOffColorLoadingAnim = YES;
        _postBtn.shutOffZoomAnim = YES;
        _postBtn.status = CoreStatusBtnStatusNormal;
        _postBtn.msg = @"正在提交";
        [footView addSubview:_postBtn];
        [self.view addSubview:footView];
        [_postBtn addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    

    
    if (_tag == 111) {
        [self classify];
    }else{
        [self valueClassify];
    }

}
#pragma mark 上传资料
- (void)postBtnClick{
    
    [self getInfoDic];
    
    NSLog(@"????%@>>>>>>%@and>>value%@",value_arr,_task.controlInfo,value);
    if (value_arr.count < _task.controlInfo.count) {
        [self.view makeToast:@"还有未填写的资料" duration:1.0 position:CSToastPositionTop];
    }else{
    
    NSLog(@"value%@",value_arr);
    User *user = [[User alloc] init];
    NSLog(@">>>>>%@",user.userId);
    NSDictionary *dataDic = @{@"userId"         :user.userId,
                              @"orderId"        :_task.orderId,
                              @"valueInfo"      :value_arr,
                              @"templateId"     :_task.templateId};
    
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    _postBtn.status = CoreStatusBtnStatusProgress;
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_PostTask] parameters:dataDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"dataDic%@",dataDic);
        
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"dic“”“》》》》》》%@",dataDic);
        NSNumber *code = [responseObject objectForKey:@"code"];
        int code_int = [code intValue];
        if (code_int == 200) {
            
            _postBtn.status = CoreStatusBtnStatusSuccess;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            NSString *msg = [NSString stringWithFormat:@"审核时间 %@天，请耐心等待",_task.auditCycle];
            CustomIOSAlertView *alert = [self successAlert:@"icon_success" andtitle:@"提交成功" andmsg:msg andButtonItem:[NSMutableArray arrayWithObjects:@"确定",@"再次领取", nil]];
            [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                
                [alertView close];
                
                
                if (_onlyType == 999) {
                    if (buttonIndex == 0) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else if (buttonIndex == 1){
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"ListPostBackNotification" object:_task userInfo:nil];
                    }
                }else{
                    if (buttonIndex == 0) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else if (buttonIndex == 1){
                        [self.navigationController popViewControllerAnimated:YES];
                        [self.delegate backPostContract];
                    }
                }
                
                
                
            }];
            [alert show];
        }else{
            _postBtn.status = CoreStatusBtnStatusFalse;
            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        _postBtn.status = CoreStatusBtnStatusFalse;
        [self.view makeToast:@"系统异常" duration:1.0 position:CSToastPositionTop];
    }];
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
- (void)classify{
    NSArray *type = @[@"Text",@"FileUpload"];
    for (NSDictionary *dic in _task.controlInfo) {
        
        ControlInfo *controInfo = [[ControlInfo alloc] init];
        [controInfo setValuesForKeysWithDictionary:dic];
        
        int item = (int)[type indexOfObject:controInfo.controlType];
        switch (item) {
            case 0:
                //文本
                [arr_text addObject:controInfo];
                break;
            case 1:
                //图片上传
                [arr_image addObject:controInfo];
                [image_Dic addObject:UIImageJPEGRepresentation([UIImage imageNamed:@"icon_imgadd"], 1)];
                break;
            default:
                break;
        }
    }
    
    if (arr_text.count!=0) {
        [arr_all addObject:@{@"data":arr_text,
                             @"count":[NSNumber numberWithInteger:arr_text.count],
                             @"type":@"text"}];
    }
    if (arr_image.count!=0) {
        [arr_all addObject:@{@"data":arr_image,
                             @"count":[NSNumber numberWithInteger:arr_image.count],
                             @"type":@"image"}];
    }
    
    NSLog(@">>>>>%@",arr_all);
    [_mytable reloadData];
}
- (void)valueClassify{
    NSArray *type = @[@"Text",@"FileUpload"];
    for (NSDictionary *dic in _task.controlInfo) {
        
        
        
        ControlInfo *controInfo = [[ControlInfo alloc] init];
        [controInfo setValuesForKeysWithDictionary:dic];
        
        if (_tag == 222) {
            [value setValue:controInfo.controlValue forKey:controInfo.name];
        }
        
        int item = (int)[type indexOfObject:controInfo.controlType];
        switch (item) {
            case 0:
                //文本
                [arr_text addObject:controInfo];
                if (controInfo.hadValue.length!=0) {
                    [arr_textValue addObject:controInfo.hadValue];
                }else{
                    [arr_textValue addObject:@""];
                }
                break;
            case 1:
                //图片上传
                [arr_image addObject:controInfo];
                if (controInfo.hadValue.length!=0) {
                   [arr_imageValue addObject:controInfo.controlValue];
                   [image_Dic addObject:controInfo.hadValue];
                }else{
                    [arr_imageValue addObject:@""];
                    [image_Dic addObject:@""];
                }
                break;
            default:
                break;
        }
    }
    
    if (arr_text.count!=0) {
        [arr_all addObject:@{@"data":arr_text,
                             @"count":[NSNumber numberWithInteger:arr_text.count],
                             @"type":@"text"}];
    }
    if (arr_image.count!=0) {
        [arr_all addObject:@{@"data":arr_image,
                             @"count":[NSNumber numberWithInteger:arr_image.count],
                             @"type":@"image"}];
    }

    NSLog(@">>>>>%@",arr_all);
    [_mytable reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arr_all.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[[arr_all objectAtIndex:section] objectForKey:@"count"] integerValue];

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, WIDTH, 30)];
    customView.layer.borderWidth = 1;
    customView.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
    customView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = UIColorFromRGB(0x333333);
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.frame = CGRectMake(12, 0.0, WIDTH - 12, 30);

    
    
    NSArray *item = @[@"text",@"image"];
    
    NSString *type = [[arr_all objectAtIndex:section] objectForKey:@"type"];
    
    int typeValue = (int)[item indexOfObject:type];
    
    switch (typeValue) {
        case 0:
            headerLabel.text = @"开始填写";
            break;
        case 1:
            headerLabel.text = @"上传图片";
            break;
        default:
            break;
    }
    
    
    [customView addSubview:headerLabel];
    
    return customView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *item = @[@"text",@"image"];
    
    NSString *type = [[arr_all objectAtIndex:section] objectForKey:@"type"];
    
    int typeValue = (int)[item indexOfObject:type];
    
    NSString *titile;
    switch (typeValue) {
        case 0:
            titile = @"开始填写";
            break;
        case 1:
            titile = @"上传图片";
            break;
        default:
            break;
    }
    return titile;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Cell_imagestr  = @"Cell_image";
    static NSString *Cell_textstr   = @"Cell_text";
    
    ContractImageTableViewCell  *Cell_image     = (ContractImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    ContractTextTableViewCell   *Cell_text      = (ContractTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell_textstr];
    
    NSArray *item = @[@"text",@"image"];
    
    NSString *type = [[arr_all objectAtIndex:indexPath.section] objectForKey:@"type"];
    
    int typeValue = (int)[item indexOfObject:type];
    
    
    if (indexPath.section == 0) {
        
    }
    
    
    switch (typeValue) {
        case 0:
            //text
            
            if (!Cell_text) {
                Cell_text = [[ContractTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell_textstr];
            }
            NSLog(@"走了 走了 走了 ");
            if (_tag==333) {
                NSLog(@">>>arrr%@",arr_textValue);
                Cell_text.myTxt.text = [arr_textValue objectAtIndex:indexPath.row];
                Cell_text.myTxt.enabled = NO;
            }else{
                ControlInfo *controlInfo = [[[arr_all objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
                Cell_text.myTxt.tag = [controlInfo.orderNum integerValue];
                Cell_text.myName = controlInfo.name;
                if (_tag == 222) {
                    Cell_text.myTxt.text = [arr_textValue objectAtIndex:indexPath.row];
                }else{
                    if ([[value objectForKey:controlInfo.name] length] == 0) {
                        Cell_text.myTxt.placeholder = controlInfo.title;
                    }else{
                        Cell_text.myTxt.text = [value objectForKey:controlInfo.name];
                    }
                    
                }
                
                
                [Cell_text.myTxt addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            }
            return Cell_text;
            break;

        case 1:
            //image
            if (!Cell_image) {
                Cell_image = [[ContractImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell_imagestr];
                ControlInfo *controlInfo = [[[arr_all objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
//                NSLog(@"celllll>>>>%@",arr_all);
                Cell_image.textLabel.text = controlInfo.title;
                Cell_image.myImg_btn.tag = indexPath.row;
                Cell_image.myName = controlInfo.name;

//                NSLog(@">>>>>>qqqqwqqq%zi",_tag);
                if (_tag == 111) {
                    [Cell_image.myImg_btn addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
//                    NSLog(@">>>>>%@",image_Dic);
                    [Cell_image.myImg_btn setBackgroundImage:[UIImage imageWithData:[image_Dic objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                }else{
                    NSLog(@">>>aaabbbaaa>>>%@",[NSString stringWithFormat:@"%@",[image_Dic objectAtIndex:indexPath.row]]);
                    [Cell_image.myImg_btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[image_Dic objectAtIndex:indexPath.row]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imgadd"]];
                    if (_tag == 333) {
                        Cell_image.myImg_btn.enabled = NO;
                    }else{
                        [Cell_image.myImg_btn addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
            return Cell_image;
            break;
        default:
            return nil;
            break;
    }


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *item = @[@"text",@"image"];
    
    NSString *type = [[arr_all objectAtIndex:indexPath.section] objectForKey:@"type"];
    
    int typeValue = (int)[item indexOfObject:type];
    
    CGFloat height;
    switch (typeValue) {
        case 0:
            //text
            height = 44;
            break;
        case 1:
            //image
            height = 100;
            break;
        default:
            height = 0;
            break;
    }
    return  height;

}
- (void)getInfoDic{

    [value_arr removeAllObjects];
    for (id key in value) {
        NSDictionary *dic = @{@"controlName":key,
                              @"controlValue":[value objectForKey:key]
                              };
        [value_arr addObject:dic];
    }
}
- (void)textFieldWithText:(UITextField *)textField
{
    
    
    ContractTextTableViewCell *cell;
    if (IOS_VERSION >= 7.0 && IOS_VERSION < 8.0) {
        cell = (ContractTextTableViewCell *)[[textField superview] superview];
    }else{
        cell = (ContractTextTableViewCell *)[textField superview];
    }
    cell.isChange = 999;
    [value setValue:textField.text forKey:cell.myName];
}
- (void)changeImage:(UIButton *)btn{
    
//    [self hideKeyBoard];
    [self resignKeyBoardInView:_mytable];
    
    NSLog(@"%zi---%@",btn.tag,[[btn superview] superview]);
    img_tag = btn.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照",@"相册", nil];

    ContractImageTableViewCell *cell;
    if (IOS_VERSION >= 7.0 && IOS_VERSION < 8.0) {
        cell = (ContractImageTableViewCell *)[[btn superview] superview];
    }else{
        cell = (ContractImageTableViewCell *)[btn superview];
    }

    
    NSLog(@"cellname>>>>%@",cell.myName);
    img_str = cell.myName;
    [actionSheet showInView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%zi",buttonIndex);

        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePickerController.delegate = self;
    

//    img_tag = actionSheet.tag;
    
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    
    [self postImg:data];
    
    
}
//取消点击
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)postGetMyTask{
    [self getTaskContent];
}
#pragma mark 请求数据
- (void)getTaskContent{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    
    
    User *user = [[User alloc] init];
    NSLog(@">>>>#%@",_task.taskId);
    NSDictionary *parmeters = @{@"userId"       :user.userId,
                                @"taskId"       :_task.taskId,
                                @"orderId"      :_task.orderId
                                };
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_TaskContent] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"---->>>>>%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 200) {
            [self viewCreat];
            
            [self successView:[responseObject objectForKey:@"data"]];
            
            [CoreViewNetWorkStausManager dismiss:self.view animated:YES];
        }else{
            NSLog(@">>>>>>%@",[responseObject objectForKey:@"msg"]);
            [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:[responseObject objectForKey:@"msg"] offsetY:-100 failClickBlock:^{
                [self getTaskContent];
            }];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [CoreViewNetWorkStausManager show:self.view type:CMTypeError msg:@"加载失败" subMsg:@"未知错误" offsetY:-100 failClickBlock:^{
            [self getTaskContent];
        }];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
- (void)successView:(NSDictionary*)dic{
    

    
    _task.taskId            = [dic objectForKeyedSubscript:@"id"];
    _task.taskTitle         = [dic objectForKey:@"taskTitle"];
    _task.taskNotice        = [dic objectForKey:@"taskNotice"];
    _task.amount            = [[dic objectForKey:@"amount"] floatValue];
    _task.endTime           = [dic objectForKey:@"endTime"];
    _task.availableCount    = [dic objectForKey:@"availableCount"];
    _task.paymentMethod     = [dic objectForKey:@"paymentMethod"];
    _task.taskGeneralInfo   = [dic objectForKey:@"taskGeneralInfo"];
    _task.taskNote          = [dic objectForKey:@"taskNote"];
    _task.businessId        = [dic objectForKey:@"businessId"];
    _task.templateId        = [dic objectForKey:@"templateId"];
    _task.pusher            = [dic objectForKey:@"pusher"];
    _task.templateName      = [dic objectForKey:@"templateName"];
    _task.isHad             = [dic objectForKey:@"isHad"];
    _task.orderId           = [dic objectForKey:@"orderId"];
    _task.logo              = [dic objectForKey:@"logo"];
    _task.companySummary    = [dic objectForKey:@"companySummary"];
    _task.auditCycle        = [dic objectForKey:@"auditCycle"];
    _task.controlInfo       = [dic objectForKey:@"controlInfo"];
    _task.isAgainPickUp     = [dic objectForKey:@"isAgainPickUp"];
    
    

    
    
    [self viewCreat];
    

    
}

- (void)postImg:(NSData *)img_data{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [HttpHelper initHttpHelper];
    [manager POST:[NSString stringWithFormat:@"%@3",URL_PostImg] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:img_data name:@"imgstream" fileName:@"idCardImg.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@">>>%@",responseObject);
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseObject objectForKey:@"Status"] intValue] == 1) {
            [value setValue:[[responseObject objectForKey:@"Result"] objectForKey:@"RelativePath"] forKey:img_str];
            NSLog(@"》》》》%@",value);
            
            if (_tag == 111) {
                [image_Dic replaceObjectAtIndex:img_tag withObject:img_data];
            }else{
                [image_Dic replaceObjectAtIndex:img_tag withObject:[[responseObject objectForKey:@"Result"] objectForKey:@"FileUrl"]];
            }
            
            NSLog(@"image_Dic>>>>>>%@tag%zi",image_Dic,img_tag);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mytable reloadData];
            });
        }else{
            [self.view makeToast:[responseObject objectForKey:@"Message"] duration:1.0 position:CSToastPositionTop];
        }
        
        NSLog(@">>>>>>%@",value);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"图片上传失败" duration:1.0 position:CSToastPositionTop];
        NSLog(@"-----%@",operation);
        NSLog(@"===+++++%@",error);
    }];
}

#pragma mark 懒加载

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
    }
    return _headImageView;
}
- (UILabel *)headLabel{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] init];
        _headLabel.font = [UIFont systemFontOfSize:15];
        _headLabel.numberOfLines = 1;
        _headLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _headLabel;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.textColor = UIColorFromRGB(0x333333);
        _infoLabel.numberOfLines = 2;
    }
    return _infoLabel;
}
- (UIImageView *)img_info{
    if (!_img_info) {
        _img_info = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time"]];
    }
    return _img_info;
}
- (CoreLabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[CoreLabel alloc] init];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (CustomIOSAlertView *)successAlert:(NSString *)imgStr andtitle:(NSString *)title andmsg:(NSString *)msg andButtonItem:(NSMutableArray *)item{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 40, HEIGHT/4)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
    UILabel *lab_titile = [[UILabel alloc] init];
    lab_titile.font = [UIFont systemFontOfSize:16];
    lab_titile.textColor = UIColorFromRGB(0x666666);
    lab_titile.textAlignment = NSTextAlignmentCenter;
    UILabel*lab_msg = [[UILabel alloc] init];
    lab_msg.font = [UIFont systemFontOfSize:14];
    lab_msg.textColor = UIColorFromRGB(0x888888);
    lab_msg.numberOfLines = 0;
    lab_msg.textAlignment = NSTextAlignmentCenter;
    [view addSubview:img];
    [view addSubview:lab_titile];
    [view addSubview:lab_msg];
    lab_titile.text = title;
    lab_msg.text = msg;
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.mas_equalTo(HEIGHT/15);
        make.width.mas_equalTo(HEIGHT/15);
    }];
    [lab_titile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).offset(10);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.left.equalTo(view).with.offset(20);
        make.right.equalTo(view).with.offset(-20);
    }];
    [lab_msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab_titile.mas_bottom);
        make.centerX.mas_equalTo(view.mas_centerX);
        make.left.equalTo(view).with.offset(20);
        make.right.equalTo(view).with.offset(-20);
    }];
    
    // Add some custom content to the alert view
    [alertView setContainerView:view];
    
    // Modify the parameters
    [alertView setButtonTitles:item];
    
    // You may use a Block, rather than a delegate.
    
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    
    
    return alertView;
}
#pragma mark 滑动隐藏键盘
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self resignKeyBoardInView:_mytable];
    
}
- (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}
@end
