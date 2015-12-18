//
//  SCMsgListCell.m
//  SupermanC
//
//  Created by riverman on 15/6/18.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "SCMsgListCell.h"

@implementation SCMsgListCell

- (void)awakeFromNib {
//    self.titleLabel.backgroundColor=[UIColor orangeColor];
//    self.contentLabel.backgroundColor=[UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MsgModel *)model{
    /*
     {
     createDate = "2015-12-10 00:00:00";
     hasRead = 0;
     id = 11;
     msg = fasdfasd;
     taskId = 0;
     title = aaaa;
     },
     */
    self.titleLabel.text=model.title;
    self.contentLabel.text=model.msg;
    self.timeLab.text= [MyTools timeString:model.createDate];
    if (model.hasRead) {
        self.titleLabel.textColor=[UIColor grayColor];
        self.timeLab.textColor=[UIColor grayColor];
        self.contentLabel.textColor=[UIColor lightGrayColor];
    }
    
}
@end
