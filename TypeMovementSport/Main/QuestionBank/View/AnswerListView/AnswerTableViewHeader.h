//
//  AnswerTableViewHeader.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamModel.h"

@interface AnswerTableViewHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *typeLabel;//单选，多选，判断
@property (nonatomic, strong) UIImageView *markKeyPointImg;//标记为重点
@property (nonatomic, strong) UILabel *themeLabel;//题目内容
@property (nonatomic, strong) UIView *actionView;//底部点击view  标记重点 | 忽略此题 |  试题反馈
@property (nonatomic, strong) UIButton *markBtn;//标为重点按钮
@property (nonatomic, strong) UIButton *feedbackBtn;//反馈按钮
@property (nonatomic, strong) UIButton *ignoreBtn;//忽略按钮

//0：标记重点，1：忽略此题，2：试题反馈
@property (nonatomic, copy) void (^ClickBottomActionBlock)(NSInteger index);

@property (nonatomic, strong) ExamModel *model;

@end
