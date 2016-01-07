//
//  NSString+addRMBcharacter.h
//  SupermanC
//
//  Created by riverman on 15/6/9.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (addRMBcharacter)

-(NSString *)addRMBcharacterAtPrefix;

-(BOOL)allCharacterIsChinese;

-(BOOL)validateCarNo;

-(NSString *)replaceNumberWithStar;
//-(NSString *)replaceNumberWithStar_alipayPhoneNo;
//-(NSString *)replaceNumberWithStar_alipayEmail;

@end
