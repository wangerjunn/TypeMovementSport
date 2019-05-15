//
//  QuestionListView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/15.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "QuestionListView.h"

//vc
#import "AnswerListViewController.h"//答题
#import "ExamInfoConfirmViewController.h"//考前信息确认页

//view
#import "QuestionListCell.h"
#import "EmptyView.h"
#import "MJRefresh.h"

//model
#import "QuestionModel.h"
#import "ExamModel.h"

@interface QuestionListView () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *listTable;
        NSMutableArray *dataArr;
}

@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation QuestionListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initQuestionListViewById:(NSInteger)questionId frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.questionId = questionId;
        dataArr = [NSMutableArray array];
        [self createUI];
    }
    return self;
}

- (void)createUI {
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
    
    if (kScreenWidth > 320) {
        listTable.rowHeight = FIT_SCREEN_HEIGHT(135);
    }else {
        listTable.rowHeight = FIT_SCREEN_HEIGHT(135) + 40;
    }
    
    [self addSubview:listTable];
    
    TO_WEAK(self, weakSelf);
    listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getClassesList];
    }];
    
    
    [self startLoadingAnimation];
    [self getClassesList];
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:listTable.bounds placeholderImage:nil placeholderText:nil];
        [listTable addSubview:_emptyView];
    }
    
    return _emptyView;
}

- (void)setIsPurchase:(BOOL)isPurchase {
    _isPurchase = isPurchase;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[QuestionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    QuestionModel *model = dataArr[indexPath.section];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.title?model.title:@""];

    cell.model = model;

    cell.StarView.tag = 1000 + indexPath.section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(IWantToTest:)];
    [cell.StarView addGestureRecognizer:tap];
    cell.StarView.userInteractionEnabled = YES;
    
    cell.LOOKView.tag = 100 + indexPath.section;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(testBrowse:)];
    [cell.LOOKView addGestureRecognizer:tap1];
    cell.LOOKView.userInteractionEnabled = YES;
    
    return cell;
}

#pragma mark -- 获取考题系列
- (void)getClassesList {
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kApiClassFindAllByParent parms:@{@"id":@(_questionId?_questionId:0)} viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            [strongSelf->dataArr removeAllObjects];
            
            NSArray *list = dict[@"list"];
            
            for (NSDictionary *tmp in list) {
                @autoreleasepool {
                    QuestionModel *model = [[QuestionModel alloc] initWithDictionary:tmp error:nil];
                    [strongSelf->dataArr addObject:model];
                }
            }
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);

        if (strongSelf->dataArr.count > 0) {
            QuestionModel *model = strongSelf->dataArr.lastObject;
            if (weakSelf.IsShowPurchaseIconBlock) {
                weakSelf.IsShowPurchaseIconBlock((model.expireTime == 0));
            }
        }
        
         [strongSelf->listTable reloadData];
        [strongSelf->listTable.mj_header endRefreshing];
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [weakSelf stopLoadingAnimation];
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);
         [strongSelf->listTable reloadData];
        [strongSelf->listTable.mj_header endRefreshing];
    }];
}

#pragma mark -- 我要考试
- (void)IWantToTest:(UITapGestureRecognizer *)tap {
    [MobClick event:@"题库，我要考试"];
    if (dataArr.count <= (tap.view.tag-1000)) {
        return;
    }
    QuestionModel *model = dataArr[tap.view.tag-1000];
    if (model.expireTime == 0 && !_isPurchase && model.price != 0) {
        //未购买|已过期
        NSString *toastCon = @"您还未购买此课件全套试题，请购买后再来答题吧！";
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:toastCon leftButtonTitle:nil rightButtonTitle:@"去购买" block:^(NSInteger index) {
            if (index == 1) {
                //去购买
                if (self.ClickPurchaseBlock) {
                    self.ClickPurchaseBlock();
                }
            }
        }];

        return;
    }
    ExamInfoConfirmViewController *examInfo = [[ExamInfoConfirmViewController alloc]init];
    examInfo.questionModel = model;
    examInfo.backViewController = self.viewController;
    [self.viewController.navigationController pushViewController:examInfo animated:YES];
}

#pragma mark -- 试题浏览
- (void)testBrowse:(UITapGestureRecognizer *)tap {
    if (dataArr.count <= (tap.view.tag-100)) {
        return;
    }
    QuestionModel *model = dataArr[tap.view.tag-100];
    if (model.expireTime == 0 && !_isPurchase && model.price != 0) {
        //未购买|已过期
        NSString *toastCon = @"您还未购买此课件全套试题，请购买后再来答题吧！";
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:toastCon leftButtonTitle:nil rightButtonTitle:@"去购买" block:^(NSInteger index) {
            if (index == 1) {
                //去购买
                if (self.ClickPurchaseBlock) {
                    self.ClickPurchaseBlock();
                }
            }
        }];

        return;
    }
    
    [self getTestData:model];
}

#pragma mark -- 获取考试题
- (void)getTestData:(QuestionModel *)model {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kQuestionFindAllByClass parms:@{@"classesId":@(model.id?model.id:0)} viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
//        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
            for (NSDictionary *tmp in list) {
                @autoreleasepool {
                    ExamModel *model = [[ExamModel alloc] initWithDictionary:tmp error:nil];
                    [arr addObject:model];
                }
            }
            
            if (list.count < 1) {
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"暂无试题" buttonTitle:nil block:nil];
                return;
            }
            AnswerListViewController *answerList = [[AnswerListViewController alloc]init];
            answerList.testQuestionsEnum = TestQuestionsBrowse;
            answerList.examDataArr = arr;
            answerList.questionModel = model;
            answerList.classesId = model.id;
            answerList.examLevelName = model.title;
            [weakSelf.viewController.navigationController pushViewController:answerList animated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

@end
