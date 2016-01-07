//
//  SCAlipayCell.h
//  SupermanC
//
//  Created by riverman on 15/9/29.
//  Copyright © 2015年 etaostars. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSCAlipayCell_title         @"kSCAlipayCell_title"
#define kSCAlipayCell_placeholder   @"kSCAlipayCell_placeholder"
#define kSCAlipayCell_text          @"kSCAlipayCell_text"


@interface SCAlipayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;


@property   (nonatomic,strong)NSDictionary *dic;
@end
