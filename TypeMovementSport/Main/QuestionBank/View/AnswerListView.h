//
//  AnswerListView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"
#import "WrongQuestionsViewController.h"

//model
#import "ExamModel.h"

@interface AnswerListView : BaseView

- (instancetype)initWithFrame:(CGRect)frame
                     testQuestionType:(TestQuestionsEnum)type
                                            data:(NSMutableArray <ExamModel*>*)examDataArr;

@property (nonatomic, copy) void(^submitBlock)(NSDictionary *info);
@property (nonatomic, assign) NSInteger classesId;
@property (nonatomic, strong) NSMutableArray <ExamModel*>*examDataArr;

//设置当前考题题库名字
- (void)setExamTitle:(NSString *)examTitle;
//答对多少到题,试题浏览时传递数据
- (void)setRightNum:(NSInteger)rightNum;

//根据下标选择考题
- (void)chooseExamTestByIndex:(NSInteger)index;
//获取未答题数量
- (NSInteger)getNoAnswerCount;
//提交答卷
- (void)submitTestQuestion;

- (void)reloadData;

//提交考题
//- (void)submitTestQuestion;
@end
