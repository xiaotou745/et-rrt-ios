//
//  OrderByBGView.m
//  RRDT1.0
//
//  Created by riverman on 16/1/27.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "OrderByBGView.h"

@implementation OrderByBGView

-(id)init{


    self=[super initWithFrame:CGRectMake(0, 0, DEF_SCEEN_WIDTH, DEF_SCEEN_HEIGHT)];
    
    if (self) {
        
        [self  configUI];
    }
    
    return  self;
    
}

-(void)configUI{
    
    self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
//    UISwipeGestureRecognizer *swip=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
//    [self addGestureRecognizer:swip];
//    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
//    [self addGestureRecognizer:pan];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
    tap.delegate=self;
        [self addGestureRecognizer:tap];
    
        _orderByTypeView=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH/2,64, WIDTH/2, 46*5) style:UITableViewStylePlain];

        _orderByTypeView.backgroundColor = [UIColor grayColor];

        _orderByTypeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _orderByTypeView.layer.borderWidth=0.5f;
        _orderByTypeView.userInteractionEnabled=YES;
        _orderByTypeView.showsHorizontalScrollIndicator = NO;
        _orderByTypeView.showsVerticalScrollIndicator = NO;
        //        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderByTypeView.scrollEnabled=NO;
        
        _orderByTypeView.backgroundColor = UIColorFromRGB(0xe8e8e8);

        _orderByTypeView.delegate=self;
        _orderByTypeView.dataSource=self;
        [self addSubview:_orderByTypeView];
    
    titles =[NSMutableArray array];
    [titles addObject:[self orderByDescription:1]];
    [titles addObject:[self orderByDescription:2]];
    [titles addObject:[self orderByDescription:3]];
    [titles addObject:[self orderByDescription:4]];
    [titles addObject:[self orderByDescription:5]];
    
    images =[NSMutableArray arrayWithArray:@[@"TaskDetail_pass",@"",@"",@"",@""]];
    colors =[NSMutableArray arrayWithArray:@[UIColorFromRGB(0x00bcd5),[UIColor darkGrayColor],[UIColor darkGrayColor],[UIColor darkGrayColor],[UIColor darkGrayColor]]];

}
-(void)tapHandle{

    [self setHidden:YES];
}
#pragma mark table代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idenifier = @"UITableViewCell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    //    if (!cell) {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    }
    
    
    UIColor *textColor=colors[indexPath.row];
    cell.textLabel.textColor=textColor;
    cell.textLabel.text=titles[indexPath.row];
    
    
    UIImageView *rightIcon=[ManFactory createImageViewWithFrame:CGRectMake(_orderByTypeView.width-30, 12, 20, 20) ImageName:images[indexPath.row]];
    [cell.contentView addSubview:rightIcon];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    images =[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@""]];
    [images replaceObjectAtIndex:indexPath.row withObject:@"TaskDetail_pass"];
    colors =[NSMutableArray arrayWithArray:@[[UIColor darkGrayColor],[UIColor darkGrayColor],[UIColor darkGrayColor],[UIColor darkGrayColor],[UIColor darkGrayColor],[UIColor darkGrayColor]]];
    [colors replaceObjectAtIndex:indexPath.row withObject:UIColorFromRGB(0x00bcd5)];
    
    [_orderByTypeView reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:OrderByTypeView_select object:@(indexPath.row+1)];
}

-(NSString *)orderByDescription:(orderByType)orderType{
    
    ////orderBy	排序方式 1是佣金，2是审核周期，3是预计用时，4是参与人数，5是发布时间（int类型）
    
    switch (orderType) {
            
        case orderByAverageTime:
            //            return @"预计用时";
            return @"预计用时最短";
            break;
        case orderByCommission:
            //            return @"佣金";
            return @"佣金最高";
            
            break;
        case orderByCreateTime:
            //            return @"发布时间";
            return @"发布时间最新";
            
            break;
        case orderByCycle:
            //            return @"审核周期";
            return @"审核最快";
            
            break;
        case orderByJoinNumbers:
            //            return @"参与人数";
            return @"参与人数最多";
            
            break;
        default:
            break;
    }
    return nil;
}
#pragma  mark  处理冲突的手势 
//场景是 tableview作为view 的子视图    现象是 点击tableview   触发了 半透明层的手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[UITableView class]])
//    {
//        return NO;
//    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件 
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
@end
