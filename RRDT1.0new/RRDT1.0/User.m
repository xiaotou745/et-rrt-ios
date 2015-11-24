//
//  User.m
//  RRDT1.0
//
//  Created by RRDT002 on 15/9/24.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "User.h"
static User *myuser = nil;
@implementation User
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userId        forKey:@"userId"];
    [aCoder encodeBool:self.isLogin         forKey:@"isLogin"];
    [aCoder encodeObject:self.userPhoneNo   forKey:@"userPhoneNo"];
    [aCoder encodeObject:self.userName      forKey:@"userName"];
    [aCoder encodeObject:self.fullHeadImage forKey:@"fullHeadImage"];

}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.userId         = [aDecoder decodeObjectForKey:@"userId"];
        self.isLogin        = [aDecoder decodeBoolForKey:@"isLogin"];
        self.userPhoneNo    = [aDecoder decodeObjectForKey:@"userPhoneNo"];
        self.fullHeadImage  = [aDecoder decodeObjectForKey:@"fullHeadImage"];
        self.userName   = [aDecoder decodeObjectForKey:@"userName"];
    }
    return self;
}
+(id)create//实现创建对象的方法
{
    @synchronized (self)//防止多线程操作冲突
    {
        if (myuser == nil) {
            myuser = [[User alloc]init];//如果对象为空的话，就创建新对象，否则返回，保证只有一个对象
        }
        return myuser;
    }
}
//重写alloc和new的创建对象方法
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self)
    {
        if (myuser == nil) {
            myuser = [[super allocWithZone:zone]init];//如果对象为空的话，就创建新对象，否则返回，保证只有一个对象
        }
        return myuser;
    }
}
//重写浅拷贝方法
-(id)copyWithZone:(NSZone *)zone
{
    return myuser;
}
//重写深拷贝方法
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return myuser;
}
@end
