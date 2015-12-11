//
//  EditInfoImgCell.h
//  RRDT1.0
//
//  Created by riverman on 15/12/7.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditInfoImgCellClick)(NSInteger index);

@interface EditInfoImgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img0;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;

@property(copy)EditInfoImgCellClick editInfoBlock;

-(void)layoutViewsss:(NSInteger)count;
@end
