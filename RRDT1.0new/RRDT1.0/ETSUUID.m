//
//  ETSUUID.m
//  etaoshi3.0
//
//  Created by Maxwell on 14/11/28.
//  Copyright (c) 2014年 etaostars. All rights reserved.
//

#import "ETSUUID.h"
#import "SFHFKeychainUtils.h"

NSString * const kETSUUIDUniqueDeviceKey = @"kETSUUIDUniqueDeviceKey";
NSString * const kETSUUIDServiceName = @"kETSUUIDServiceName";

@implementation ETSUUID
/// 获得设备唯一标示
+ (NSString *)uniqueDeviceID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (BOOL)storeUniqueDeviceIDToKeychain{
    
    return [SFHFKeychainUtils storeUsername:kETSUUIDUniqueDeviceKey andPassword:[self uniqueDeviceID] forServiceName:kETSUUIDServiceName updateExisting:YES error:nil];
}

+ (NSString *)getUniqueDeviceIDFromKeychain{
    return [SFHFKeychainUtils getPasswordForUsername:kETSUUIDUniqueDeviceKey andServiceName:kETSUUIDServiceName error:nil];
}

@end
