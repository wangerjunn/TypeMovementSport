//
//  ExamModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

@interface ExamModel : BaseModel

/*
 a = "抗阻力量训练";
 answer = B;
 b = "身心的健康 ";
 c = "敏捷性和柔韧性";
 content = "健身教练运动计划的全面性原则是指（   ）。";
 d = "良好的耐力训练";
 id = 10;
 type = SELECT;
 ignore = 0;
 mark = 0;
 */

@property (nonatomic, assign) NSInteger id;//考题id
@property (nonatomic, copy) NSString *a;//考题选项
@property (nonatomic, copy) NSString *b;
@property (nonatomic, copy) NSString *c;
@property (nonatomic, copy) NSString *d;
@property (nonatomic, copy) NSString *content;//考题内容
@property (nonatomic, copy) NSString *answer;//正确答案
@property (nonatomic, copy) NSString *type;//考题类型
@property (nonatomic, copy) NSString *ownAnswer;//自己回答的选项，A、B、C、D
@property (nonatomic, assign) BOOL ignore;//是否忽略此题
@property (nonatomic, assign) BOOL mark;//是否标为重点

@property (nonatomic, assign) NSInteger curSeleIndex;//0-3对应的ABCD选项,初始化默认-1都未选择
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat aHeight;
@property (nonatomic, assign) CGFloat bHeight;
@property (nonatomic, assign) CGFloat cHeight;
@property (nonatomic, assign) CGFloat dHeight;

@end
