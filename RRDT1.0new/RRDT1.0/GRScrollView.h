//
//  GRScrollView.h
//  ChildrenOnline
//
//  Created by riverman on 15/8/4.
//  Copyright (c) 2015年 riverman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GRCancelBlock)(void);

@interface GRScrollView : UIView<UIScrollViewDelegate>

{
    NSUInteger selectIndex;
    NSArray *imageArray;
    
    UIImageView *cancelImageV;
    
}
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UILabel *indexText;

@property(copy)GRCancelBlock grCancelBock;

-(id)initWithImages:(NSArray *)images AddToView:(UIView *)view SelectIndex:(NSUInteger)index;

-(void)hideIndexText;



@end
