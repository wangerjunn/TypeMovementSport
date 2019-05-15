//
//  KeyChainStore.h
//  TypeMovementSport
//
//  Created by 小二郎 on 2019/5/5.
//  Copyright © 2019年 小二郎. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
+ (NSString *)getUUID;
@end

NS_ASSUME_NONNULL_END
