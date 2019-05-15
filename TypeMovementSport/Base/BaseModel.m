//
//  BaseModel.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
/* 这是 JSONModel的方法
 mapperFromUnderscoreCaseToCamelCase mapper from underscore case to Camel Case
 从underscore(下划线)方式 转化成Camel(骆驼)方法
 */
//+ (JSONKeyMapper*)keyMapper {
//    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
//}


/* 属性都是可选的  如果Model中属性多了 也不会崩溃 */
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return  YES;
}
@end
