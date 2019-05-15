//
//  NSObject+isNotEmpty.m
//  SalesCompetition
//
//  Created by 吕海瑞 on 16/7/22.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "NSObject+isNotEmpty.h"
@implementation NSObject (isNotEmpty)

- (BOOL)isNotEmpty
{
    return !(self == nil
             || [self isKindOfClass:[NSNull class]]
             || ([self respondsToSelector:@selector(length)]
                 && [(NSData *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));
    
}


/**
 转成String
 
 */
- (NSString *)toString{
    if ([self isNotEmpty]) {
        return  [NSString stringWithFormat:@"%@",self];
    }else{
        return @"";
    }
    
}









@end
