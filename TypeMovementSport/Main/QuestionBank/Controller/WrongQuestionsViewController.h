//
//  WrongQuestionsViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

typedef enum {
    TestQuestionsBrowse = 0,//试题浏览
    TestQuestionsExam = 1,//试题考试
    TestQuestionsReview = 2//试题复习
} TestQuestionsEnum;

#import "BaseViewController.h"
#import "ExamModel.h"

@interface WrongQuestionsViewController : BaseViewController

@property (nonatomic, copy) void(^submitBlock)(void);
@property (nonatomic, assign) TestQuestionsEnum testQuestionsEnum;
@property (nonatomic, copy) void (^ClickItemNum)(NSInteger itemNo);//选择题目
@property (nonatomic, strong) NSMutableArray <ExamModel *>*examDataArr;
@property (nonatomic, assign) NSInteger rightNum;//正确题数量
@property (nonatomic, assign) NSInteger wrongNum;//错误题数量
@property (nonatomic, copy) NSString *examTitle;

@end
