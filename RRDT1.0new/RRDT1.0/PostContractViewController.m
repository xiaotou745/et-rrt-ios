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

#import "EditInfoImgCell.h"

#import "CoreLabel.h"

#import "ControlInfo.h"

#import "ControlTemplate.h"

#import "CoreStatusBtn.h"

#import "UIButton+WebCache.h"

#import "TPKeyboardAvoidingTableView.h"


@interface PostContractViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *arr_text;
    NSMutableArray *arr_image;
    NSMutableArray *arr_images;
    NSMutableArray *arr_all;
    
    NSMutableArray *sectionTempplate;
    NSArray *item;
    
    NSMutableDictionary *value;
    
    
    NSString *img_str;
    NSInteger img_tag;
    
    NSMutableArray *image_Dic;
    
    
    NSMutableArray *value_arr;
    

    NSMutableArray *arr_textValue;
    
    UIView *topView;
    
//    UIView *top_footView;
}
/**
 主照片
 */
@property (nonatomic,strong) UIImageView    *headImageView;
/**
 标题
 */
@property (nonatomic,strong) UILabel        *headLabel;
/**
 状态
 */
@property (nonatomic,strong) CoreLabel        *statusLabel;


/**
 时间
 */
@property (nonatomic,strong) CoreLabel        *timeLabel;
/**
 金额
 */
@property (nonatomic,strong) CoreLabel      *moneyLabel;
/**
 lineLAB
 */
@property (nonatomic,strong) UILabel        *line_label;



@property (nonatomic,strong) UILabel    *lab1;//1-1

@property (nonatomic,strong) UILabel    *lab2;//1-2

@property (nonatomic,strong) CoreLabel    *lab3;//2-1

@property (nonatomic,strong) UIImageView    *img1;//1-1

@property (nonatomic,strong) UIImageView    *img2;//1-2

@property (nonatomic,strong) UIImageView    *img3;//2-1



@property (nonatomic,strong) UILabel            *titleLab;

@property (nonatomic,strong) UILabel            *centerLab;

@property (nonatomic,strong) TPKeyboardAvoidingTableView        *mytable;

@property (nonatomic,strong) CoreStatusBtn      *postBtn;

//键盘高度
@property (nonatomic,assign) CGFloat            keyBoardHeight;

@property (nonatomic,strong) UIToolbar          *myTololBar;

@property (nonatomic,strong) NSArray          *templateGroup;

@property(nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation PostContractViewController

-(void)backBarButtonPressed{

    if (_tag ==111) {
        [UIAlertView showAlertViewWithTitle:@"您还未提交资料，确定退出吗" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger index){
            if(index==0) [self.navigationController popViewControllerAnimated:YES];

        } onCancel:^(){
        
        }];
 
    }else [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"资料录入";
    item = @[@"text",@"image",@"images"];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [_delegate backPostContract];
}
- (void)viewCreat{
    
    sectionTempplate=[NSMutableArray array];
    arr_image   = [NSMutableArray array];
    arr_images   = [NSMutableArray array];
    arr_text    = [NSMutableArray array];
    arr_all     = [NSMutableArray array];
    value       = [NSMutableDictionary dictionary];
    value_arr   = [NSMutableArray array];
    
    arr_textValue  = [NSMutableArray array];
    
    image_Dic = [NSMutableArray array];
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    topView.backgroundColor = [UIColor whiteColor];
    

    
    [topView addSubview:[self headImageView]];
    [topView addSubview:[self headLabel]];
    [topView addSubview:[self statusLabel]];
    [topView addSubview:[self moneyLabel]];
    [topView addSubview:[self line_label]];
    
    [topView addSubview:[self lab1]];
    [topView addSubview:[self lab2]];
    [topView addSubview:[self lab3]];
    
    [topView addSubview:[self img1]];
    [topView addSubview:[self img2]];
    [topView addSubview:[self img3]];
    
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(15);
        make.left.equalTo(topView).with.offset(12);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(15);
        make.left.mas_equalTo(_headImageView.mas_right).offset(12);
        make.right.equalTo(topView).with.offset(-12);
        make.height.mas_equalTo(20);
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headLabel.mas_bottom);
        make.left.mas_equalTo(_headImageView.mas_right).offset(12);
        make.right.equalTo(_moneyLabel.mas_left).with.offset(0);
        make.height.mas_equalTo(40);
    }];
    
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headLabel.mas_bottom);
        make.right.equalTo(topView).with.offset(-10);
        make.width.mas_equalTo(100);
        make.height.equalTo(@20);
    }];
    [_line_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(12);
        make.right.equalTo(topView).with.offset(-12);
        make.top.mas_equalTo(_headImageView.mas_bottom).offset(10);
        make.height.equalTo(@1);
    }];
    
    
    [_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
        make.left.mas_equalTo(_img1.mas_right).offset(5);
        make.height.equalTo(@15);
    }];
    [_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
        make.left.mas_equalTo(_img2.mas_right).offset(5);
        make.height.equalTo(@15);
    }];
    
    [_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lab1.mas_bottom).offset(5);
        make.left.mas_equalTo(_img3.mas_right).offset(5);
        make.height.equalTo(@15);
    }];
    
    [_img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
        make.left.equalTo(topView).with.offset(10);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    [_img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line_label.mas_bottom).offset(10);
        make.left.mas_equalTo(_lab1.mas_right).offset(40);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    [_img3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_img1.mas_bottom).offset(5);
        make.left.equalTo(topView).with.offset(10);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, WIDTH, 10)];
    lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [topView addSubview:lineView];
    
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_task.logo]] placeholderImage:[UIImage imageNamed:@"icon_morentu"] options:1 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _headLabel.text = _task.taskTitle;
    
    _moneyLabel.textColor = [UIColor clearColor];
    _moneyLabel.text = [NSString stringWithFormat:@"￥%.2f/次",_task.amount];
    [_moneyLabel addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(0,1)];
    [_moneyLabel addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(1,_moneyLabel.text.length - 3)];
    [_moneyLabel addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:10] range:NSMakeRange(_moneyLabel.text.length - 2,2)];
    [_moneyLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(0,_moneyLabel.text.length - 2)];
    [_moneyLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(_moneyLabel.text.length - 2,2)];

    _statusLabel.text =[NSString stringWithFormat:@" %@  %@",[MyTools getTasktype:_task.taskType],_task.taskGeneralInfo];
    
    
    [_statusLabel addAttr:CoreLabelAttrColor value:[UIColor whiteColor] range:NSMakeRange(0,4)];
    [_statusLabel addAttr:CoreLabelAttBackgroundColor value:[MyTools getTasktypeBGColor:_task.taskType] range:NSMakeRange(0,4)];
    
    [_statusLabel addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(4,_statusLabel.text.length - 4)];
    _statusLabel.textColor=UIColorFromRGB(0xbbc0c7);

    _lab1.text = [NSString stringWithFormat:@"审核 %@天",_task.auditCycle];
    _lab2.text = [NSString stringWithFormat:@"截止时间 %@",[_task.endTime substringWithRange:NSMakeRange(0, 10)]];
    _lab3.text = [NSString stringWithFormat:@"咨询 %@",_task.hotLine];
    if(_task.hotLine.length==0||_task.hotLine==nil){
        
        [_lab3 setHidden:YES];
        [_img3 setHidden:YES];
    }else{
        [_lab3 setHidden:NO];
        [_img3 setHidden:NO];
    }

    [_lab3 addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x00bcd5) range:NSMakeRange(3,_lab3.text.length - 3)];
    
    
    if (_tag != 222) {
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


    
    

    if (_tag!= 222) {
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
    
    BOOL Value = NO;
    
                    
    for (NSDictionary *controlDic in value_arr) {
        
        NSString *controlValue=controlDic[@"controlValue"];
      controlValue= [controlValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (![controlValue isEqualToString:@""]) {
            //前端至少一项必填
            Value=YES;
            break;
        }
    }
    //前端 一项都没填
    if (!Value){
        [self.view makeToast:@"请填写资料后再提交" duration:1.0 position:CSToastPositionTop];
        return;
    }
    
    NSLog(@"????%@>>>>>>%@and>>value%@",value_arr,_task.controlInfo,value);
    
    NSLog(@"value%@",value_arr);
    User *user = [[User alloc] init];
    NSLog(@">>>>>%@",user.userId);
    NSDictionary *dataDic = @{@"userId"         :user.userId,
                              @"ctId"        :_task.ctId,
                              @"valueInfo"      :value_arr,
                              @"taskId"     :_task.taskId};
    
    
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
            [UIAlertView showAlertViewWithTitle:@"提交成功" message:msg cancelButtonTitle:@"确定" otherButtonTitles:@[@"再次提交"] onDismiss:^(NSInteger buttonIndex){
                
                [self postGetMyTask];

            } onCancel:^(){
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            _postBtn.status = CoreStatusBtnStatusFalse;
            [self.view makeToast:[responseObject objectForKey:@"msg"] duration:1.0 position:CSToastPositionTop];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        _postBtn.status = CoreStatusBtnStatusFalse;
        [self.view makeToast:@"系统异常" duration:1.0 position:CSToastPositionTop];
    }];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
- (void)classify{
    NSArray *type = @[@"Text",@"FileUpload"];
    for (NSDictionary *dic in _templateGroup) {
        
        ControlTemplate *temp=[[ControlTemplate alloc]init];
        [temp setValuesForKeysWithDictionary:dic];
        [sectionTempplate addObject:temp];
        
        [arr_text  removeAllObjects];
        [arr_image  removeAllObjects];
        [arr_images  removeAllObjects];

        
        for (NSDictionary *info in temp.controlList) {
            ControlInfo *controInfo = [[ControlInfo alloc] init];
            [controInfo setValuesForKeysWithDictionary:info];
            [value setValue:@"" forKey:controInfo.controlKey];

            int item =temp.groupType;
            switch (item) {
                case groupTypeText:
                    //文本

                    [arr_text addObject:controInfo];
                    break;
                case groupTypeImage:
                    //图片上传
                    [arr_image addObject:controInfo];
                    break;
                case groupTypeImages:
                    //图片上传
                    [arr_images addObject:controInfo];
                    break;

                default:
                    break;
                }
        }
        
        if (arr_text.count!=0) {
            [arr_all addObject:@{@"data":[arr_text mutableCopy],
                                 @"count":[NSNumber numberWithInteger:arr_text.count],
                                 @"type":@"text"}];
        }
        if (arr_image.count!=0) {
            [arr_all addObject:@{@"data":[arr_image mutableCopy],
                                 @"count":[NSNumber numberWithInteger:arr_image.count],
                                 @"type":@"image"}];
        }
        if (arr_images.count!=0) {
            [arr_all addObject:@{@"data":[arr_images mutableCopy],
                                 @"count":[NSNumber numberWithInteger:(arr_images.count+4)/5],
                                 @"type":@"images"}];
        }

    }
    

    NSLog(@"classify>>>>>%@",arr_all);
    [_mytable reloadData];
}
- (void)valueClassify{
        NSArray *type = @[@"Text",@"FileUpload"];
        for (NSDictionary *dic in _templateGroup) {
        
            ControlTemplate *temp=[[ControlTemplate alloc]init];
            [temp setValuesForKeysWithDictionary:dic];
            [sectionTempplate addObject:temp];

            [arr_text  removeAllObjects];
            [arr_image  removeAllObjects];
            [arr_images  removeAllObjects];

            for (NSDictionary *info in temp.controlList) {
        
                ControlInfo *controInfo = [[ControlInfo alloc] init];
                [controInfo setValuesForKeysWithDictionary:info];
                
                if (_tag == 222) {
                    [value setValue:controInfo.controlValue forKey:controInfo.controlKey];
                }
        
                int item = temp.groupType;
                switch (item) {
                    case groupTypeText:
                        //文本
                        [arr_text addObject:controInfo];
                        
                        break;
                    case groupTypeImage:
                        //图片上传
                        [arr_image addObject:controInfo];
                        
                        break;
                    case groupTypeImages:
                        //图片上传
                        [arr_images addObject:controInfo];
                        break;

                    default:
                        break;
                }
            }
            if (arr_text.count!=0) {
                [arr_all addObject:@{@"data":[arr_text mutableCopy],
                                     @"count":[NSNumber numberWithInteger:arr_text.count],
                                     @"type":@"text"}];
            }
            if (arr_image.count!=0) {
                [arr_all addObject:@{@"data":[arr_image mutableCopy],
                                     @"count":[NSNumber numberWithInteger:arr_image.count],
                                     @"type":@"image"}];
            }
            if (arr_images.count!=0) {
                [arr_all addObject:@{@"data":[arr_images mutableCopy],
                                     @"count":[NSNumber numberWithInteger:(arr_images.count+4)/5],
                                     @"type":@"images"}];
            }

        }

    NSLog(@"valueClassify>>>>>%@",arr_all);
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

    ControlTemplate *templ=sectionTempplate[section];
    headerLabel.text=templ.title;
    [customView addSubview:headerLabel];
    
    return customView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Cell_textstr   = @"Cell_text";
    static NSString *Cell_imagestr  = @"Cell_image";

    ContractTextTableViewCell   *Cell_text      = (ContractTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell_textstr];
    ContractImageTableViewCell  *Cell_image     = (ContractImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString *type = [[arr_all objectAtIndex:indexPath.section] objectForKey:@"type"];
    
    ControlInfo *controInfo = [[ControlInfo alloc] init];
    controInfo=[arr_all objectAtIndex:indexPath.section][@"data"][indexPath.row];
    int typeValue = (int)[item indexOfObject:type];
    
    switch (typeValue) {
        case 0:
            //text
            
            if (!Cell_text) {
                Cell_text = [[ContractTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell_textstr];
            }
            NSLog(@"走了 走了 走了 ");
            if (_tag==333) {
                NSLog(@">>>arrr%@",arr_textValue);
                Cell_text.myTxt.text = controInfo.controlValue;
                Cell_text.myTxt.enabled = NO;
                
            }else{
                Cell_text.myTxt.tag = [controInfo.orderNum integerValue];
                Cell_text.myName = controInfo.controlKey;
//                if ([[value objectForKey:controInfo.controlValue] length] == 0) {
//                    Cell_text.myTxt.placeholder = controInfo.controlTitle;
//                }
                if (_tag == 222) {
                    [Cell_text.myTxt setEnabled:NO];
                    Cell_text.myTxt.text = controInfo.controlValue;
                    if (controInfo.controlValue.length == 0)Cell_text.myTxt.placeholder = controInfo.controlTitle;
                }else{
                    if ([[value objectForKey:controInfo.controlKey] length] == 0) {
                        Cell_text.myTxt.placeholder = controInfo.controlTitle;
                    }else{
                        Cell_text.myTxt.text = [value objectForKey:controInfo.controlKey];
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
//                NSLog(@"celllll>>>>%@",arr_all);
                Cell_image.textLabel.text = controInfo.controlTitle;
                Cell_image.myImg_btn.tag =10000*indexPath.section+indexPath.row;
                Cell_image.myName = controInfo.controlKey;

                if (_tag == 111) {
                    [Cell_image.myImg_btn addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
                    [Cell_image.myImg_btn sd_setBackgroundImageWithURL:[NSURL URLWithString:controInfo.controlValue] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imgadd"]];

                }else{
                    [Cell_image.myImg_btn sd_setBackgroundImageWithURL:[NSURL URLWithString:controInfo.controlValue] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imgadd"]];
                    Cell_image.myImg_btn.userInteractionEnabled = NO;

                    if (_tag == 333) {
                        Cell_image.myImg_btn.userInteractionEnabled = NO;
                    }else{
                        [Cell_image.myImg_btn addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
            return Cell_image;
            break;
        case 2:
        {
            //images
            EditInfoImgCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"EditInfoImgCell" owner:self options:nil]firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            NSArray *controlLists = [[arr_all objectAtIndex:indexPath.section] objectForKey:@"data"];
        
            //多图组 的行数
            NSInteger rows=(controlLists.count+4)/5;
            //最后一行的个数
            NSInteger lastRowCounts=controlLists.count%5;
            //为0  说明最后一行是满的
            if (lastRowCounts==0) {
                lastRowCounts=5;
            }
            
            if(indexPath.row==rows-1)   [cell  layoutViewsss:lastRowCounts];
            
            
            /*最后一行需要防止数组越界  非最后一行则不用*/
                if (lastRowCounts>0||indexPath.row+1<rows){
                    ControlInfo *conInfo=(ControlInfo *)controlLists[indexPath.row*5];
                    [cell.img0 sd_setImageWithURL:[NSURL URLWithString:conInfo.controlValue]  placeholderImage:[UIImage imageNamed:@"icon_imgadd"]];
                }
                if (lastRowCounts>1||indexPath.row+1<rows){
                    ControlInfo *conInfo=(ControlInfo *)controlLists[indexPath.row*5+1];
                    [cell.img1 sd_setImageWithURL:[NSURL URLWithString:conInfo.controlValue]  placeholderImage:[UIImage imageNamed:@"icon_imgadd"]];
                }
                if (lastRowCounts>2||indexPath.row+1<rows){
                    ControlInfo *conInfo=(ControlInfo *)controlLists[indexPath.row*5+2];
                    [cell.img2 sd_setImageWithURL:[NSURL URLWithString:conInfo.controlValue]  placeholderImage:[UIImage imageNamed:@"icon_imgadd"]];
                    
                }
                if (lastRowCounts>3||indexPath.row+1<rows){
                    ControlInfo *conInfo=(ControlInfo *)controlLists[indexPath.row*5+3];
                    [cell.img3 sd_setImageWithURL:[NSURL URLWithString:conInfo.controlValue]  placeholderImage:[UIImage imageNamed:@"icon_imgadd"]];
                    
                }
                if (lastRowCounts>4||indexPath.row+1<rows){
                    ControlInfo *conInfo=(ControlInfo *)controlLists[indexPath.row*5+4];
                    [cell.img4 sd_setImageWithURL:[NSURL URLWithString:conInfo.controlValue]  placeholderImage:[UIImage imageNamed:@"icon_imgadd"]];
                    
                }
            
            if(_tag==222||_tag==333){
                
                cell.img0.userInteractionEnabled = NO;
                cell.img1.userInteractionEnabled = NO;
                cell.img2.userInteractionEnabled = NO;
                cell.img3.userInteractionEnabled = NO;
                cell.img4.userInteractionEnabled = NO;
            }
            

            cell.editInfoBlock=^(NSInteger index){
                
                /*
                 *index 这一行的第几个
                 */
                [self pushCamera:index Section:indexPath.section Row:indexPath.row];
            };
            
            return cell;
            break;
        }


        default:
            return nil;
            break;
    }


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        case 2:
            //images
            height =WIDTH/4;
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
-(void)pushCamera:(NSInteger)index Section:(NSInteger)section Row:(NSInteger)row{

    [self resignKeyBoardInView:_mytable];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照",@"相册", nil];
    

    ControlInfo *controlInfo = [[[arr_all objectAtIndex:section] objectForKey:@"data"] objectAtIndex:row*5+index];
    img_str = controlInfo.controlKey;
    img_tag=arr_image.count+row*5+index;
    _indexPath=[NSIndexPath indexPathForRow:row*5+index inSection:section];
    [actionSheet showInView:self.view];
}

- (void)changeImage:(UIButton *)btn{
    
    NSInteger section=btn.tag/10000;
    NSInteger row=btn.tag%10000;
   _indexPath= [NSIndexPath indexPathForRow:row inSection:section];
    
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
    NSLog(@">>>>#%@",_taskId);
    NSDictionary *parmeters = @{@"userId"       :user.userId,
                                @"taskId"       :_taskId,
                                @"taskDatumId":_taskDatumId};
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_All,URL_Gettaskdatumdetail] parameters:parmeters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"---->>>>>%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 200) {
//            [self viewCreat];
            
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
- (void)successView:(NSDictionary*)data{
    
    NSDictionary *task=data[@"task"];
    _task=[[Task alloc]init];
    [_task setValuesForKeysWithDictionary:task];

    _templateGroup=[NSArray arrayWithArray:data[@"templateGroup"]];
    
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

            NSString *FileUrl=[[responseObject objectForKey:@"Result"] objectForKey:@"FileUrl"];
            [self replaceControlInfo:FileUrl];
            
            
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
-(void)replaceControlInfo:(NSString *)fileUrl{
/**
 [arr_all addObject:
    @{
    @"data":[arr_text mutableCopy],
    @"count":[NSNumber numberWithInteger:arr_text.count],
    @"type":@"text"}
    ];
 */
    ControlInfo *newInfo=arr_all[_indexPath.section][@"data"][_indexPath.row];
    newInfo.controlValue=fileUrl;
    
    NSMutableArray *results=[NSMutableArray array];
    for (int section=0; section<arr_all.count; section++) {
      
        NSDictionary *dic=arr_all[section];
        
        if (section== _indexPath.section) {
            
            NSMutableArray *conInfoLists=[NSMutableArray arrayWithArray:dic[@"data"]];

           [conInfoLists replaceObjectAtIndex:_indexPath.row withObject:newInfo];
                

            [results addObject:@{
                                 @"data":[conInfoLists mutableCopy],
                                 @"count":dic[@"count"],
                                 @"type":dic[@"type"]}];
        }else  [results addObject:dic];
       
    }
    
    arr_all=[results copy];
}
-(void)callHotLine{
    
    [MyTools call:_task.hotLine atView:self.view];
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

- (CoreLabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[CoreLabel alloc] init];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (CoreLabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[CoreLabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12];
    }
    return _statusLabel;
}

- (CoreLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel =[[CoreLabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UILabel *)line_label{
    if (!_line_label) {
        _line_label = [[UILabel alloc] init];
        _line_label.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _line_label;
}
- (UILabel *)lab1{
    if (!_lab1) {
        _lab1 = [[UILabel alloc] init];
        _lab1.font = [UIFont systemFontOfSize:12];
        _lab1.textColor = UIColorFromRGB(0x333333);
    }
    return _lab1;
}
- (UILabel *)lab2{
    if (!_lab2) {
        _lab2 = [[UILabel alloc] init];
        _lab2.font = [UIFont systemFontOfSize:12];
        _lab2.textColor = UIColorFromRGB(0x333333);
    }
    return _lab2;
}
- (CoreLabel *)lab3{
    if (!_lab3) {
        _lab3 = [[CoreLabel alloc] init];
        _lab3.font = [UIFont systemFontOfSize:12];
        _lab3.textColor = UIColorFromRGB(0x333333);
        _lab3.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callHotLine)];
        [_lab3 addGestureRecognizer:tap];
    }
    return _lab3;
}

- (UILabel *)iconLabel{
    
    UILabel *iconLab = [[UILabel alloc] init];
    iconLab.font = [UIFont systemFontOfSize:15];
    iconLab.numberOfLines = 1;
    iconLab.textColor=[UIColor whiteColor];
    iconLab.textAlignment=NSTextAlignmentCenter;
    iconLab.backgroundColor=UIColorFromRGB(0x00bcd5);
    return iconLab;
}
- (UILabel *)contentLab{
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = [UIFont systemFontOfSize:14];
    contentLab.numberOfLines = 2;
    //    contentLab.backgroundColor=[UIColor blueColor];
    return contentLab;
}
- (UILabel *)vvvLab{
    
    UILabel *vvvLab = [[UILabel alloc] init];
    vvvLab.font = [UIFont systemFontOfSize:15];
    vvvLab.backgroundColor=UIColorFromRGB(0x00bcd5);
    return vvvLab;
}

- (UILabel *)pointLabel{
    
    UILabel *pointLabel = [[UILabel alloc] init];
    pointLabel.font = [UIFont systemFontOfSize:15];
    pointLabel.numberOfLines = 1;
    pointLabel.backgroundColor=[UIColor lightGrayColor];
    return pointLabel;
}
- (UILabel *)contentttLab{
    
    UILabel *contentttLab = [[UILabel alloc] init];
    contentttLab.font = [UIFont systemFontOfSize:15];
    contentttLab.numberOfLines = 2;
    contentttLab.textColor=[UIColor lightGrayColor];
    return contentttLab;
}
- (UIImageView *)img1{
    if (!_img1) {
        _img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cantask"]];
    }
    return _img1;
}
- (UIImageView *)img2{
    if (!_img2) {
        _img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time"]];
    }
    return _img2;
}
- (UIImageView *)img3{
    if (!_img3) {
        _img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TaskDetail_phone"]];
    }
    return _img3;
}

- (CustomIOSAlertView *)successAlert:(NSString *)imgStr andtitle:(NSString *)title andmsg:(NSString *)msg andButtonItem:(NSMutableArray *)item{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 40, HEIGHT/4)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
    UILabel *lab_titile = [[UILabel alloc] init];
    lab_titile.font = [UIFont systemFontOfSize:16];
//    lab_titile.textColor = UIColorFromRGB(0x666666);
    lab_titile.textColor = [UIColor blackColor];

    lab_titile.textAlignment = NSTextAlignmentCenter;
    UILabel*lab_msg = [[UILabel alloc] init];
    lab_msg.font = [UIFont systemFontOfSize:14];
//    lab_msg.textColor = UIColorFromRGB(0x888888);
    lab_msg.textColor = [UIColor  darkGrayColor];

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
