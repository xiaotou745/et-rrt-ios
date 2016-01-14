//
//  OrderByTypeView.m
//  RRDT1.0
//
//  Created by riverman on 16/1/13.
//  Copyright © 2016年 RRDT002. All rights reserved.
//

#import "OrderByTypeView.h"

@implementation OrderByTypeView
- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(WIDTH/2,0, WIDTH/2, 44*5) style:UITableViewStylePlain];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        self.dataSource = self;
        self.delegate = self;

        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.layer.borderWidth=0.5f;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled=NO;
        
        self.backgroundColor = UIColorFromRGB(0xe8e8e8);
        
        titles =[NSMutableArray array];
        [titles addObject:[self orderByDescription:1]];
        [titles addObject:[self orderByDescription:2]];
        [titles addObject:[self orderByDescription:3]];
        [titles addObject:[self orderByDescription:4]];
        [titles addObject:[self orderByDescription:5]];
        
        images =[NSMutableArray arrayWithArray:@[@"TaskDetail_pass",@"",@"",@"",@""]];

    }
    return self;
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
    cell.textLabel.text=titles[indexPath.row];
    
    UIImageView *rightIcon=[ManFactory createImageViewWithFrame:CGRectMake(self.width-30, 12, 20, 20) ImageName:images[indexPath.row]];
    [cell.contentView addSubview:rightIcon];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    images =[NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@""]];
    [images replaceObjectAtIndex:indexPath.row withObject:@"TaskDetail_pass"];
    [self reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:OrderByTypeView_select object:@(indexPath.row+1)];
}

-(NSString *)orderByDescription:(orderByType)orderType{
    
    ////orderBy	排序方式 1是佣金，2是审核周期，3是预计用时，4是参与人数，5是发布时间（int类型）
    
    switch (orderType) {
            
        case orderByAverageTime:
            return @"预计用时";
            return @"预计用时最短";
            break;
        case orderByCommission:
            return @"佣金";
            return @"佣金最高";

            break;
        case orderByCreateTime:
            return @"发布时间";
            return @"发布时间最新";

            break;
        case orderByCycle:
            return @"审核周期";
            return @"审核最快";

            break;
        case orderByJoinNumbers:
            return @"参与人数";
            return @"参与人数最多";

            break;
        default:
            break;
    }
    return nil;
}

@end
