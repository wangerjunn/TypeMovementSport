//
//  ReviewQuestionView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/16.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ReviewQuestionView.h"

//vc
#import "WrongQuestionsViewController.h"
#import "AnswerListViewController.h"

//view
#import "ReviewQuestionCell.h"
#import "MJRefresh.h"
#import "EmptyView.h"
#import "EmptyPlaceholderTipsView.h"

//model
#import "ExamModel.h"
#import "QuestionModel.h"

@interface ReviewQuestionView () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *listTable;
        NSMutableArray *dataArr;
        NSInteger pageNum;
        NSInteger pageSize;
}

@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) EmptyPlaceholderTipsView *tipsView;
@property (nonatomic, assign) BOOL isFromMine;


@end

@implementation ReviewQuestionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initReviewQuestionViewByFrame:(CGRect)frame isFromMine:(BOOL)isFromMine {
    if (self = [super initWithFrame:frame]) {
        
        self.isFromMine = isFromMine;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    pageNum = 0;
    pageSize = 10;
    dataArr = [NSMutableArray array];
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        listTable.estimatedRowHeight = 0;
        listTable.estimatedSectionHeaderHeight = 0;
        listTable.estimatedSectionFooterHeight = 0;
        listTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:listTable];
    
    listTable.backgroundColor = LaneCOLOR;
    
    __weak typeof(self) weakSelf = self;
    listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->pageNum = 0;
        [weakSelf getUserExamRecordsList];
    }];
    
    [self startLoadingAnimation];
    [self getUserExamRecordsList];
}

- (EmptyView *)emptyView {
    if (!self.isFromMine) {
        if (!_emptyView) {
            _emptyView = [[EmptyView alloc] initEmptyViewByFrame:listTable.bounds placeholderImage:nil placeholderText:nil];
            [listTable addSubview:_emptyView];
        }
    }
    return _emptyView;
}

- (EmptyPlaceholderTipsView *)tipsView {
    if (_tipsView == nil) {
        
        TO_WEAK(self, weakSelf);
        NSString *info = @"您还没有任何错题";
        _tipsView = [[EmptyPlaceholderTipsView alloc] initWithFrame:self.bounds title:nil info:info block:^{
            //点击占位view
            [weakSelf.viewController.navigationController.tabBarController setSelectedIndex:1];
            [weakSelf.viewController.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    
    return _tipsView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    
    ReviewQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[ReviewQuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    QuestionModel *model = dataArr[indexPath.section];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击进入试题回顾详情页
    QuestionModel *model = dataArr[indexPath.section];
    [self userExamRecordsGetById:model.id];
}

#pragma mark -- 获取考试记录
- (void)getUserExamRecordsList {
    NSDictionary *para = @{
                           @"offset":@(pageNum*pageSize),
                           @"max":@(pageSize)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserExamRecordsList parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (strongSelf->pageNum == 0) {
                [strongSelf->dataArr removeAllObjects];
            }
            
            NSArray *list = dict[@"list"];
            
            if (list.count >= 10) {
                strongSelf->pageNum += 1;
                if (strongSelf->listTable.mj_footer == nil) {
                    strongSelf->listTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [strongSelf getUserExamRecordsList];
                    }];
                }
            }else{
                strongSelf->listTable.mj_footer = nil;
            }
            
            for (NSDictionary *tmp in list) {
                QuestionModel *model = [[QuestionModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->dataArr addObject:model];
            }
            
            [strongSelf->listTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [strongSelf->listTable.mj_header endRefreshing];
        if (strongSelf->listTable.mj_footer) {
            [strongSelf->listTable.mj_footer endRefreshing];
        }
        
        [weakSelf handlePlaceholderView];
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->listTable.mj_header endRefreshing];
        if (strongSelf->listTable.mj_footer) {
            [strongSelf->listTable.mj_footer endRefreshing];
        }
        
        [weakSelf handlePlaceholderView];
        [weakSelf stopLoadingAnimation];
    }];
}

- (void)handlePlaceholderView {
    if (dataArr.count < 1) {
        if (self.isFromMine) {
            [self addSubview:self.tipsView];
        }else {
            self.emptyView.hidden = NO;
        }
    }else {
        if (self.isFromMine) {
            [self.tipsView removeFromSuperview];
        }else {
            self.emptyView.hidden = YES;
        }
    }
}

#pragma mark -- 获取考试记录详情和对应的试题
- (void)userExamRecordsGetById:(NSInteger)testId {
    NSDictionary *para = @{
                           @"id":@(testId?testId:0)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserExamRecordsGet parms:para viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            //获取已经答题的答案
            NSString *answerStr = dict[@"detail"][@"answer"];
            
            NSDictionary *answerDic = [answerStr objectFromJSONString];
            NSArray *list = dict[@"list"];
            NSMutableArray *allKeysArr ;
            if (answerDic) {
                allKeysArr  = [NSMutableArray arrayWithArray:answerDic.allKeys];
            }
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
            
            NSInteger rightNum = 0;
            for (NSDictionary *tmp in list) {
                @autoreleasepool {
                    ExamModel *model = [[ExamModel alloc] initWithDictionary:tmp error:nil];
                    
                    if (allKeysArr.count > 0) {
                        NSString *modelId = [NSString stringWithFormat:@"%ld",model.id];
                        if ([allKeysArr containsObject:modelId]) {
                            if ([answerDic[modelId] isEqualToString:model.answer]) {
                                rightNum += 1;
                            }
                            model.ownAnswer = answerDic[modelId];
                            [allKeysArr removeObject:modelId];
                        }
                    }
                    [arr addObject:model];
                }
            }
            
            AnswerListViewController *answerList = [[AnswerListViewController alloc]init];
            answerList.testQuestionsEnum = TestQuestionsReview;
            answerList.examDataArr = arr;
            answerList.rightNum = rightNum;
            [weakSelf.viewController.navigationController pushViewController:answerList animated:YES];
//            WrongQuestionsViewController *wrongQuestion = [[WrongQuestionsViewController alloc]init];
//            wrongQuestion.testQuestionsEnum = TestQuestionsReview;
//            wrongQuestion.examDataArr = arr;
//            if (dict[@"errorCount"]) {
//                wrongQuestion.rightNum = [dict[@"errorCount"] integerValue];
//            }
//
//            if (dict[@"successCount"]) {
//                wrongQuestion.wrongNum = [dict[@"successCount"] integerValue];
//            }
//            [strongSelf.viewController.navigationController pushViewController:wrongQuestion animated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [strongSelf->listTable.mj_header endRefreshing];
        if (strongSelf->listTable.mj_footer) {
            [strongSelf->listTable.mj_footer endRefreshing];
        }
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->listTable.mj_header endRefreshing];
        if (strongSelf->listTable.mj_footer) {
            [strongSelf->listTable.mj_footer endRefreshing];
        }
    }];
}
@end
