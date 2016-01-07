//
//  ManFactory.m
//  MANFactory
//
// Created by 满孝河 on 14-8-20.
//  Copyright (c) 2014年 manxiaohe. All rights reserved.
//

#import "ManFactory.h"
#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
@implementation ManFactory
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Text:(NSString*)text
{
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是白色
    label.textColor=[UIColor blackColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //图片与文字如果需要同时存在，就需要图片足够小 详见人人项目按钮设置
    // [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
    
    
}
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=YES;
    return imageView;
}
+(UIView*)viewWithFrame:(CGRect)frame
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    
    return view;
    
}
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder=placeholder;
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    textField.secureTextEntry=YESorNO;
    //边框
    //textField.borderStyle=UITextBorderStyleLine;
    //键盘类型
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //左图片
    textField.leftView=imageView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右图片
    textField.rightView=rightImageView;
    //编辑状态下一直存在
    textField.rightViewMode=UITextFieldViewModeWhileEditing;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor=[UIColor blackColor];
    return textField;
    
}
#pragma  mark 适配器方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName
{
    UITextField*text= [self createTextFieldWithFrame:frame placeholder:placeholder passWord:YESorNO leftImageView:imageView rightImageView:rightImageView Font:font];
    text.background=[UIImage imageNamed:imageName];
    return  text;
    
}
+(UITextView*)createTextViewWithFrame:(CGRect)frame textFont:(CGFloat)font textString:(NSString*)text isEditable:(BOOL)YESorNO
{
    UITextView *textView=[[UITextView alloc]initWithFrame:frame];
    textView.font=[UIFont systemFontOfSize:font];
    textView.text=text;
    //设置是否可以编辑
    textView.editable=YESorNO;
    return textView;
    
}
+(UIWebView*)createWebViewWithFrame:(CGRect)frame htmlString:(NSString *)htmlString
{
    UIWebView *webView=[[UIWebView alloc]initWithFrame:frame];
    [webView setUserInteractionEnabled:YES];//支持交互
    [webView setOpaque:NO];//默认为不透明  改为透明
    [webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlString]]];
    return webView;
}
+(UIScrollView*)createScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = size;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    return scrollView;
}
+(UIPageControl*)createPageControlWithFrame:(CGRect)frame
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    return pageControl;
}
+(UISlider*)createSliderWithFrame:(CGRect)frame AndImage:(UIImage*)image
{
    UISlider *slider = [[UISlider alloc]initWithFrame:frame];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider setThumbImage:image forState:UIControlStateNormal];
    slider.maximumTrackTintColor = [UIColor grayColor];
    slider.minimumTrackTintColor = [UIColor yellowColor];
    slider.continuous = YES;
    slider.enabled = YES;
    return slider;
}
+(UIStepper*)createStepperWithFrame:(CGRect)frame maxValue:(double)max minValue:(double)min stepValue:(double)step Target:(id)target Action:(SEL)action
{
    UIStepper *stepper=[[UIStepper alloc]initWithFrame:frame];
    stepper.maximumValue=max;
    stepper.minimumValue=min;
    stepper.stepValue=step;
    [stepper addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return stepper;
}
+(UISegmentedControl*)createSegmentWithFrame:(CGRect)frame itemsArray:(NSArray *)itemsArray Target:(id)target Action:(SEL)action
{
    UISegmentedControl *segment=[[UISegmentedControl alloc]initWithItems:itemsArray];
    segment.frame=frame;
    [segment addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    return segment;
}
+(NSString *)createStringFromDateWithHourAndMinute:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma -mark 判断导航的高度
+(float)isIOS7{
    
    float height;
    if (IOS7) {
        height=64.0;
    }else{
        height=44;
    }
    
    return height;
}


@end
