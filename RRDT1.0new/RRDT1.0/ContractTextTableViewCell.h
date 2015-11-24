//
//  ContractTextTableViewCell.h
//  RRDT1.0
//
//  Created by RRDT002 on 15/10/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractTextTableViewCell : UITableViewCell

@property (nonatomic,assign) NSInteger isChange;

@property (nonatomic,strong) UITextField *myTxt;

@property (nonatomic,strong) NSString    *myName;
@end
