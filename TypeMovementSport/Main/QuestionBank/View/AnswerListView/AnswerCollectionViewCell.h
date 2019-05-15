//
//  AnswerCollectionViewCell.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/17.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WrongQuestionsViewController.h"

//model
#import "ExamModel.h"

@interface AnswerCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) TestQuestionsEnum testQuestionEnum;//枚举

@property (nonatomic, assign) NSInteger serialNumber;//答案编号
@property (nonatomic, strong) UITableView *optionTableView;

//答题点击确认按钮
@property (nonatomic, copy) void (^clickConfirmButtonBlcok)(NSInteger index);
//答题选项选中
@property (nonatomic, copy) void (^chooseAnswerBlcok)(NSString * chooseItem);
//标为重点|忽略此题|试题反馈
@property (nonatomic, copy) void (^questionOperationBlcok)(NSInteger  index);


@property (nonatomic, strong) ExamModel *model;

@end
