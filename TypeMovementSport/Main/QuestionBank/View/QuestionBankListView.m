//
//  QuestionBankListView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/10.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ParamFile.h"
#import "QuestionBankListView.h"

//VC
#import "QuestionListViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"

//view
#import "SimulatedExerciseCell.h"
#import "EmptyView.h"
#import "MJRefresh.h"

//model
#import "QuestionModel.h"

@interface QuestionBankListView () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *listTable;
        NSMutableArray *dataArr;
}

@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation QuestionBankListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    dataArr = [NSMutableArray array];
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTable.sectionFooterHeight = FIT_SCREEN_HEIGHT(15);
    listTable.rowHeight = FIT_SCREEN_HEIGHT(105);
    
    if (@available(iOS 11.0,*)) {
        listTable.estimatedRowHeight = 0;
        listTable.estimatedSectionHeaderHeight = 0;
        listTable.estimatedSectionFooterHeight = 0;
        listTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:listTable];
    
    TO_WEAK(self, weakSelf);
    listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCategoryList];
    }];
    
    [self startLoadingAnimation];
    [self getCategoryList];
    
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:listTable.bounds placeholderImage:nil placeholderText:nil];
        [listTable addSubview:_emptyView];
    }
    
    return _emptyView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return FIT_SCREEN_HEIGHT(175);
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.001;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return FIT_SCREEN_HEIGHT(15);
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    SimulatedExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[SimulatedExerciseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    QuestionModel *model = dataArr[indexPath.section];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MobClick event:@"题库，模拟练习"];
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    
    QuestionListViewController *listVC = [[QuestionListViewController alloc]init];
    listVC.hidesBottomBarWhenPushed = YES;
    QuestionModel *model = dataArr[indexPath.section];
    
    if (!model.isOnline) {
        return;
    }
    listVC.questionModel = model;
    
    TO_WEAK(self, weakSelf);
    listVC.PaySuccessCallbackBlock = ^{
        [weakSelf getCategoryList];
    };
    [self.viewController.navigationController pushViewController:listVC animated:YES];
}

#pragma mark -- 去登录
- (void)displayLoginView {
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
    [self.viewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- 获取考题列表
- (void)getCategoryList {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kClassesFindAllByRoot parms:@{@"type":@"EXAM"} viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            [strongSelf->dataArr removeAllObjects];
            for (NSDictionary *tmp in list) {
                QuestionModel *model = [[QuestionModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->dataArr addObject:model];
            }
            
            [strongSelf->listTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);
        
        [strongSelf->listTable.mj_header endRefreshing];
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        
        TO_STRONG(weakSelf, strongSelf);
        [weakSelf stopLoadingAnimation];
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);
        [strongSelf->listTable.mj_header endRefreshing];
    }];
}

@end
