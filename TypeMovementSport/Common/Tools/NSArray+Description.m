//
//  NSArray+Description.m
//  BeStudent_Teacher
//
//  Created by XDH on 2017/3/28.
//  Copyright © 2017年 XDH. All rights reserved.
//

#import "NSArray+Description.h"

@implementation NSArray (Description)
-(NSString *)my_description{
    NSString *desc = [self description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}
@end
