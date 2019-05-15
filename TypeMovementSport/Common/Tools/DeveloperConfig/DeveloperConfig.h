//
//  DeveloperConfig.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#define Current_Runtime_Environment @"Current_Runtime_Environment" //当前运行环境
#define HttpUrlsPlist @"HttpUrls" //urls配置文件

#define Current_HttpUrl @"Current_HttpUrl" //当前url

#import <Foundation/Foundation.h>

@interface DeveloperConfig : NSObject


/**
 获取当前开发环境

 @return 当前URL
 */
+ (NSString *)getCurrentUrl;

/**
 获取所有服务列表

 @return 服务列表集合
 */
+ (NSArray *)getAllUrls;

/**
 修改当前开发URL

 @param index 选择要修改的URL的下标
 @return BOOL 是否修改成功
 */
+ (BOOL)changeCurrentConfigUrl:(NSInteger)index;


/**
 获取配置文件对应的可以值

 @param key 第三方平台的key值
 @return 对应的key值
 */
+(NSString *)getStringConfigurationForKey:(NSString *)key;

@end
