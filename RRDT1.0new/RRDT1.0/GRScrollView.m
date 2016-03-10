//
//  GRScrollView.m
//  ChildrenOnline
//
//  Created by riverman on 15/8/4.
//  Copyright (c) 2015年 riverman. All rights reserved.
//

#import "GRScrollView.h"
#import "AppDelegate.h"
@implementation GRScrollView

-(id)initWithImages:(NSArray *)images AddToView:(UIView *)view SelectIndex:(NSUInteger)index
{
    self=[super initWithFrame:CGRectMake(0, 0, DEF_SCEEN_WIDTH, DEF_SCEEN_HEIGHT)];
    if (self) {
        imageArray=[images copy];
        selectIndex=index;
        [self makeUI];
        
        AppDelegate *app=   (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:self];

    }
    return self;
}

-(void)makeUI
{
    self.userInteractionEnabled=YES;
    self.backgroundColor=[UIColor blackColor];
//    self.alpha=0.3;
    CGFloat originX=5;
    CGFloat imageWidth=DEF_SCEEN_WIDTH-10;
        _scrollView=[ManFactory createScrollViewWithFrame:CGRectMake(0, 0, DEF_SCEEN_WIDTH, DEF_SCEEN_WIDTH) andSize:CGSizeMake(DEF_SCEEN_WIDTH*imageArray.count, DEF_SCEEN_WIDTH)];
    _scrollView.delegate=self;
    _scrollView.center=self.center;
    [self addSubview:_scrollView];
    
    for (int i=0; i<imageArray.count; i++) {
        UIImageView *imageView=[ManFactory createImageViewWithFrame:CGRectMake(DEF_SCEEN_WIDTH*i+originX, 0, imageWidth, imageWidth) ImageName:@"default_image"];
        [imageView setImageWithURL:[NSURL URLWithString:imageArray[i]]];
        [_scrollView addSubview:imageView];
        
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
        [imageView addGestureRecognizer:tap];
    }

    _scrollView.contentOffset=CGPointMake(DEF_SCEEN_WIDTH*selectIndex, 0);
    
    cancelImageV=[ManFactory createImageViewWithFrame:CGRectMake(0,0, 30, 30) ImageName:@"image_delete"];
    cancelImageV.center=CGPointMake(DEF_SCEEN_WIDTH/2, _scrollView.bottom+25);
    cancelImageV.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick)];
    [cancelImageV addGestureRecognizer:tap];
    //[self addSubview:cancelImageV];
    
    _indexText=[ManFactory createLabelWithFrame:CGRectMake(0,0, 100, 20) Font:15 Text:@""];
    _indexText.center=CGPointMake(DEF_SCEEN_WIDTH/2, _scrollView.bottom+25);

    [self addSubview:_indexText];
//    indexText.text=[NSString stringWithFormat:@"%ld/%ld",selectIndex+1,imageArray.count];
    NSUInteger index=(NSUInteger)(_scrollView.contentOffset.x/DEF_SCEEN_WIDTH)+1;
    
//    NSMutableAttributedString *AttText=[[NSMutableAttributedString  alloc]initWithString:[NSString stringWithFormat:@"%ld/%ld",index,imageArray.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15] ,NSForegroundColorAttributeName:[UIColor whiteColor]}];

//    [AttText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17] ,NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(0, 1)];
   
    _indexText.text=[NSString stringWithFormat:@"%ld/%ld",index,imageArray.count];
    _indexText.textAlignment=NSTextAlignmentCenter;
    _indexText.textColor=[UIColor whiteColor];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger index=(NSUInteger)(scrollView.contentOffset.x/DEF_SCEEN_WIDTH)+1;
    _indexText.text=[NSString stringWithFormat:@"%ld/%ld",index,imageArray.count];

//    NSMutableAttributedString *AttText=[[NSMutableAttributedString  alloc]initWithString:[NSString stringWithFormat:@"%ld/%ld",index,imageArray.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15] ,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    [AttText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18] ,NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(0, 1)];
    
//    _indexText.attributedText=AttText;
    
}
-(void)tapHandle
{
    [self cancelClick];
}
-(void)cancelClick
{
    [self removeFromSuperview];
    //self.grCancelBock();
}

-(void)hideIndexText
{
    [_indexText setHidden:YES];
}
@end
