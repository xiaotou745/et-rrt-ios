//
//  TabBarView.m
//  ChildrenOnline
//
//  Created by riverman on 15/7/3.
//  Copyright (c) 2015年 riverman. All rights reserved.
//

#import "TabBarView.h"

/**
 *  tabBar count
 */
#define DEF_TAB_ITEM_COUNT 3


#define DEF_TABBAR_SELECT_COLOR [UIColor colorWithRed:0.18 green:0.81 blue:0.89 alpha:1]
#define DEF_TABBAR_UNSELECT_COLOR [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1]

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// tabBar上每个item的宽度
        float itemWidth = DEF_SCEEN_WIDTH/DEF_TAB_ITEM_COUNT;
        
        // 未选中图片名
        NSArray *normalArray = @[@"taBar_wait",@"taBar_current",@"taBar_center"];
        
        // 选中图片
        NSArray *selectedArray = @[@"taBar_wait_select",@"taBar_current_select",@"taBar_center_select"];
        
        NSArray *titles=@[@"可接任务",@"我的任务",@"个人中心"];
        // item
        /// 创建每个item
        for (int i=0; i<DEF_TAB_ITEM_COUNT; i++)
        {
            //            UIButton *bgButtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            bgButtn.frame = CGRectMake(itemWidth*i, 0, itemWidth, DEF_HEIGHT(self));
            UIButton *bgButtn = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, self.height)];
            bgButtn.userInteractionEnabled = YES;
            [bgButtn addTarget:self action:@selector(itemBGBTNClick:) forControlEvents:UIControlEventTouchUpInside];
            bgButtn.tag = DEF_TAB_ITEM_TAG+i;
            
//            CGFloat ofSetX=4 *(2-i);
            CGFloat ofSetX=0;
            UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 20, 20)];
            itemButton.center=CGPointMake(itemWidth/2+ofSetX, 18);

        //    自定义
            if (i == DEF_TAB_ITEM_COUNT-1) {
                self.messageIcon=[ManFactory createLabelWithFrame:CGRectMake(0, 0, 7, 7) Font:10 Text:@""];
                self.messageIcon.center=CGPointMake(itemButton.width, 2);
                self.messageIcon.backgroundColor=[UIColor redColor];
//                self.messageIcon.textColor=[UIColor whiteColor];
                self.messageIcon.textAlignment=NSTextAlignmentCenter;
                self.messageIcon.layer.cornerRadius=self.messageIcon.width/2;
                self.messageIcon.layer.masksToBounds=YES;
                self.messageIcon.hidden=YES;
                [itemButton addSubview:self.messageIcon];
            }
//            UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,itemWidth, IOS_TAB_BAR_HEIGHT)];
            //            itemButton.adjustsImageWhenHighlighted = NO;
            [itemButton setImage:[UIImage imageNamed:normalArray[i]] forState:UIControlStateNormal];
            [itemButton setImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateSelected];
            [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            itemButton.tag = DEF_TAB_ICON_TAG+i;
        
            UILabel *label = [ManFactory createLabelWithFrame:CGRectMake(0, itemButton.bottom, itemWidth, 49-itemButton.bottom) Font:12 Text:titles[i]];
            label.tag=DEF_TAB_LABEL_TAG+i;
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=DEF_TABBAR_UNSELECT_COLOR;
            
            [bgButtn addSubview:itemButton];
            [bgButtn addSubview:label];
            [self addSubview:bgButtn];
            
            if (i == 0) {
                label.textColor=DEF_TABBAR_SELECT_COLOR;
                
                itemButton.selected = YES;
                self.curkBtn=itemButton;
    
            }
        }
        
        // 添加分割线
        UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEF_SCEEN_WIDTH, 0.5)];
        lineLb.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:lineLb];
    }
    return self;
}
-(void)itemBGBTNClick:(UIButton *)BGBTN
{

    UIButton *item=(UIButton *)[self viewWithTag:BGBTN.tag-DEF_TAB_ITEM_TAG+DEF_TAB_ICON_TAG];
    [self itemClick:item];
}

- (void)itemClick:(UIButton *)item
{
    self.preBtn=self.curkBtn;
    self.curkBtn=item;
    for (int i=0; i<DEF_TAB_ITEM_COUNT; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:DEF_TAB_ICON_TAG+i];
        button.selected = NO;
        UILabel *label=(UILabel *)[self viewWithTag:DEF_TAB_LABEL_TAG+i];
        label.textColor=DEF_TABBAR_UNSELECT_COLOR;
    }
    item.selected = YES;
    
    UILabel *label=(UILabel *)[self viewWithTag:item.tag-DEF_TAB_ICON_TAG+DEF_TAB_LABEL_TAG];
    label.textColor=DEF_TABBAR_SELECT_COLOR;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarView:didSelectAtIndex:)]) {
        [self.delegate tabBarView:self didSelectAtIndex:item.tag-DEF_TAB_ICON_TAG];
    }
 
}

-(void)showMessageIcon{
    [_messageIcon setHidden:NO];
}
-(void)hiddenMessageIcon{
    [_messageIcon setHidden:YES];
}
@end

