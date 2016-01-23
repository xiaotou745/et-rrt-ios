//
//  TabBarView.h
//  ChildrenOnline
//
//  Created by riverman on 15/7/3.
//  Copyright (c) 2015年 riverman. All rights reserved.
//

#import <UIKit/UIKit.h>


#define DEF_TAB_ITEM_TAG 20000
#define DEF_TAB_LABEL_TAG 30000
#define DEF_TAB_ICON_TAG 10000

@class TabBarView;

/**
 *  TabBarView的委托协议
 */
@protocol TabBarViewDelegate <NSObject>

/**
 *  TabBarView被选中的item
 *
 *  @param tabBarView 当前TabBarView对象
 *  @param index      被选中的item的index
 */
- (void)tabBarView:(TabBarView *)tabBarView didSelectAtIndex:(int)index;

@end

/**
 *  App下导航栏
 */
@interface TabBarView : UIView

/**
 *  TabBarView对象
 */
@property (nonatomic, weak) id<TabBarViewDelegate> delegate;

@property (nonatomic,strong)UIButton *preBtn;
@property (nonatomic,strong)UIButton *curkBtn;
@property(nonatomic, strong)UILabel *messageIcon;

- (void)itemClick:(UIButton *)item;



-(void)showMessageIcon;
-(void)hiddenMessageIcon;
@end

