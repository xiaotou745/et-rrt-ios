//
//  TaskDetailCell.m
//  RRDT1.0
//
//  Created by riverman on 15/12/4.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "TaskDetailCell.h"
#import "CoreLabel.h"
#import "GRScrollView.h"

@interface TaskDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UILabel *contentText;

@property (weak, nonatomic) IBOutlet CoreLabel *taskName;
@property (weak, nonatomic) IBOutlet CoreLabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *taskStatus;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *refuseLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLab_constraintHeight;

@property (weak, nonatomic) IBOutlet UIImageView *img0;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;

@property(strong, nonatomic)GRScrollView *grScrollView;
@end

@implementation TaskDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TaskDetailModel *)model{

    _model=model;
    _createDate.text=[NSString stringWithFormat:@"提交时间 %@", [MyTools timeString:model.createDate]];

    _taskName.text=[NSString stringWithFormat:@""];
    _taskName.text =[NSString stringWithFormat:@" %@  %@",[MyTools getTasktype:model.taskType],model.taskName];
    
    [_taskName addAttr:CoreLabelAttrColor value:[UIColor whiteColor] range:NSMakeRange(0,4)];
    [_taskName addAttr:CoreLabelAttBackgroundColor value:[MyTools getTasktypeBGColor:model.taskType] range:NSMakeRange(0,4)];
    
    [_taskName addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(4,_taskName.text.length - 4)];
    
    
    _amount.text = [NSString stringWithFormat:@"￥%.2f/次",model.amount];
    
    [_amount addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(0,1)];
    [_amount addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(1,_amount.text.length - 3)];
    [_amount addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:10] range:NSMakeRange(_amount.text.length - 2,2)];
    [_amount addAttr:CoreLabelAttrColor value:UIColorFromRGB(0xf7585d) range:NSMakeRange(0,_amount.text.length - 2)];
    [_amount addAttr:CoreLabelAttrColor value:UIColorFromRGB(0x888888) range:NSMakeRange(_amount.text.length - 2,2)];
    
    NSString *refuseString;
    if (model.refuReason.length==0) refuseString=@"拒绝原因：无";
    else refuseString=[NSString stringWithFormat:@"拒绝原因：%@",model.refuReason];
    _refuseLabel.text=refuseString;
    _refuseLabel.textColor=UIColorFromRGB(0x888888);
    _taskStatus.text=model.taskStatusName;
    _taskStatus.textColor=UIColorFromRGB(0x00bcd5);
    if (GroupTypeText== model.groupType) {
        [_contentText setHidden:NO];
//        _contentText.text=[model.titlesList description];
        if (model.titlesList.count) _contentText.text=model.titlesList[0];
        

    }else{
        NSArray *images=model.titlesList;
        
        
        if (images.count>0) {
            [_img0 setHidden:NO];
            [_img0 sd_setImageWithURL:[NSURL URLWithString:images[0]]];
        }
    
        if (images.count>1){
            [_img1 setHidden:NO];
            [_img1 sd_setImageWithURL:[NSURL URLWithString:images[1]]];

        }
        if (images.count>2){
           
            [_img2 setHidden:NO];
            [_img2 sd_setImageWithURL:[NSURL URLWithString:images[2]]];

        }
        if (images.count>3){
            
            [_img3 setHidden:NO];
            [_img3 sd_setImageWithURL:[NSURL URLWithString:images[3]]];

        }
        if (images.count>4){
            [_img4 setHidden:NO];
            [_img4 sd_setImageWithURL:[NSURL URLWithString:images[4]]];

        }
    }
}

-(void)hideBottomViews{
    [_taskName setHidden:YES];
    [_taskStatus setHidden:YES];
    [_amount setHidden:YES];
    [_lineLab setHidden:YES];
    [_refuseLabel setHidden:YES];
    _lineLab_constraintHeight.constant=0;
}

-(void)showGRScrollView_index:(NSInteger)index{

    self.grScrollView=[[GRScrollView alloc]initWithImages:self.model.titlesList AddToView:self SelectIndex:index];
}
- (IBAction)imageView4_Tap:(id)sender {
    [self showGRScrollView_index:4];
//    _block(4);
}
- (IBAction)imageView3_Tap:(id)sender {
    [self showGRScrollView_index:3];
//    _block(3);
}
- (IBAction)imageView2_Tap:(id)sender {
    [self showGRScrollView_index:2];

//    _block(2);
}
- (IBAction)imageView1_Tap:(id)sender {
    [self showGRScrollView_index:1];

//    _block(1);
}
- (IBAction)imageView0_Tap:(id)sender {
    [self showGRScrollView_index:0];

//    _block(0);
}


@end
