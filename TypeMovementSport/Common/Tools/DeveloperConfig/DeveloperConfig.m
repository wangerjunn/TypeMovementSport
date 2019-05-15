//
//  DeveloperConfig.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "DeveloperConfig.h"

@implementation DeveloperConfig

/**
 获取配置文件对应的可以值
 
 @param key 第三方平台的key值
 @return 对应的key值
 */
+(NSString *)getStringConfigurationForKey:(NSString *)key {
    
    NSInteger index = [[NSUserDefaults standardUserDefaults]integerForKey:Current_HttpUrl];
    NSArray *urls = [self getAllUrls];
    NSDictionary *urlInfo = urls[index];
    
    NSString *currentEnvironment = urlInfo[@"environment"];
    
    
    NSDictionary *configurationDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:currentEnvironment ofType:@"plist"]];    
    return configurationDic[key];
    
}

/**
 获取当前开发环境
 
 @return 当前URL
 */
+ (NSString *)getCurrentUrl {
    
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:Current_HttpUrl];
    NSArray *urls = [self getAllUrls];
    NSDictionary *urlInfo = urls[index];
    return urlInfo[@"url"];
}

/**
 获取所有服务列表
 
 @return 服务列表集合
 */
+ (NSArray *)getAllUrls {
    //获取plist文件内的URL
    NSArray *urls = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:HttpUrlsPlist ofType:@"plist"]];
    return urls;
}

/**
 修改当前开发URL
 
 @param index 选择要修改的URL的下标
 @return BOOL 是否修改成功
 */
+ (BOOL)changeCurrentConfigUrl:(NSInteger)index {
    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:Current_HttpUrl];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return YES;
}

@end
