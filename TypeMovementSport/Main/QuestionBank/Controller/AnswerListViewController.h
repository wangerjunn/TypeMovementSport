//
//  AnswerListViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "WrongQuestionsViewController.h"

//model
#import "ExamModel.h"
#import "QuestionModel.h"

@interface AnswerListViewController : BaseViewController

@property (nonatomic, assign) NSInteger rightNum;//答对多少道题
@property (nonatomic, copy) NSString *examLevelName;//试卷级别
@property (nonatomic, assign) TestQuestionsEnum testQuestionsEnum;
@property (nonatomic, strong) NSMutableArray <ExamModel *>*examDataArr;
@property (nonatomic, assign) NSInteger classesId;//对应的题库id
@property (nonatomic, assign) NSInteger chooseExamIndex;//选择的考题下标
@property (nonatomic, strong) QuestionModel *questionModel;

@end
