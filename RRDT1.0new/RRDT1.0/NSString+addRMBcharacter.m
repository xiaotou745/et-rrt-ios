//
//  NSString+addRMBcharacter.m
//  SupermanC
//
//  Created by riverman on 15/6/9.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "NSString+addRMBcharacter.h"

@implementation NSString (addRMBcharacter)

-(NSString *)addRMBcharacterAtPrefix
{

    return [NSString stringWithFormat:@"¥ %@",self];

}

-(BOOL)allCharacterIsChinese
{
    for (int i = 0; i < self.length; i ++) {
        NSString * subString = [self substringWithRange:NSMakeRange(i, 1)];
        unichar c = [subString characterAtIndex:0];
        if (c <0x4E00 || c >0x9FFF)
        {
            return NO;
        }

    }
    return YES;
}

-(BOOL)validateCarNo
{
    
    if (self.length!=7) {
        return NO;
    }
    
    NSString * chinese = [self substringWithRange:NSMakeRange(0, 1)];
    unichar c = [chinese characterAtIndex:0];
    //汉字编码区域
    if (c <0x4E00 || c >0x9FFF)
    {
            return NO;
    }
    
    NSString * capital =[self substringWithRange:NSMakeRange(1,1)];
    if (![capital validateCapital]) {
        return NO;
    }
    
    
    NSString *numberOrCharecter=[self substringWithRange:NSMakeRange(2, 5)];
    if (![numberOrCharecter isNumberCharacter]) {
        return NO;
    }
    
    return YES;

}


// 5位数字字母
- (BOOL)isNumberCharacter
{
    NSString *passWordRegex        = @"^[a-zA-Z0-9]{5}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
}

//[A-Z]
- (BOOL)validateCapital{
    NSString *passWordRegex        = @"[A-Z]";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
}
-(NSString *)replaceNumberWithStar
{
//    return [NSString stringWithFormat:@"****%@",[self substringFromIndex:self.length-4]];
    
    
    if ([self isRightPhoneNumberFormat]) {
        return [self replaceNumberWithStar_alipayPhoneNo];
        
    }else if ([self isValidateEmail]){
    
        return [self replaceNumberWithStar_alipayEmail];
    }else{
        return self;
    }
}

-(NSString *)replaceNumberWithStar_alipayPhoneNo{
    
  return  [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
-(NSString *)replaceNumberWithStar_alipayEmail{

    NSRange range=[self rangeOfString:@"@"];
    NSArray *arr=[self componentsSeparatedByString:@"@"];
    if (range.location<3) {
        return [NSString stringWithFormat:@"%@***@%@",arr[0],arr[1]];
    }else{
        return [NSString stringWithFormat:@"%@***@%@",[arr[0]substringToIndex:3],arr[1]];
    }
}
@end

