//
//  AnswerTableViewCell.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ExamModel.h"

@interface AnswerTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;//选项内容
@property (nonatomic, strong) UIView *mainView;//选项背景

//@property (nonatomic, strong) ExamModel *model;

@end
