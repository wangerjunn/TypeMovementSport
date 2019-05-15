//
//  NSObject+isNotEmpty.h
//  SalesCompetition
//
//  Created by 吕海瑞 on 16/7/22.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (isNotEmpty)
/**
 *  判断一个对象是否为空
 *
 *  @return 不为空返回Yes
 */
- (BOOL)isNotEmpty;



/**
 转成String
 */
- (NSString *)toString;



@end
