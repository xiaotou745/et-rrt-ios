//
//  ETSUUID.h
//  etaoshi3.0
//
//  Created by Maxwell on 14/11/28.
//  Copyright (c) 2014年 etaostars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETSUUID : NSObject

/// 将设备唯一标示存入keychain()
+ (BOOL)storeUniqueDeviceIDToKeychain;
/// 从keychain取出设备唯一标示
+ (NSString *)getUniqueDeviceIDFromKeychain;

@end
