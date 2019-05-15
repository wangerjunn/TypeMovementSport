//
//  GetExamResultViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"

@interface GetExamResultViewController : BaseViewController

@property (nonatomic, copy) NSString *examLevelName;//考试级别
@property (nonatomic, assign) NSInteger fullScore;//满分
@property (nonatomic, assign) NSInteger passScore;//及格分
@property (nonatomic, assign) NSInteger actualScore;//考的分数
@property (nonatomic, assign) CGFloat sumTime;//总时长，单位分钟
@property (nonatomic, assign) CGFloat useTime;//用时长,单位秒

@end
