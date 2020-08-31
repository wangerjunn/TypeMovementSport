//
//  Course_lostFat.m
//  TypeMovementSport
//
//  Created by xslp on 2020/8/31.
//  Copyright © 2020 小二郎. All rights reserved.
//

#import "Course_lostFat.h"
#import "SimulatedExerciseCell.h"
#import "EmptyView.h"
#import "MJRefresh.h"

//vc
#import "CourseListViewController.h"
#import "BaseNavigationViewController.h"
#import "ActOpeListViewController.h"

//model
#import "QuestionModel.h"

@interface Course_lostFat () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *loseFatTable;//实操table
    NSInteger _videoTypeId;
    NSMutableArray *_dataArr;
}

@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation Course_lostFat

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame videoTypeId:(NSInteger)videoTypeId{
    if (self = [super initWithFrame:frame]) {
        _videoTypeId = videoTypeId;
        _dataArr = [NSMutableArray array];
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    loseFatTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    loseFatTable.delegate = self;
    loseFatTable.dataSource = self;
    loseFatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        loseFatTable.estimatedRowHeight = 0;
        loseFatTable.estimatedSectionHeaderHeight = 0;
        loseFatTable.estimatedSectionFooterHeight = 0;
        loseFatTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    loseFatTable.rowHeight = FIT_SCREEN_HEIGHT(105);
    [self addSubview:loseFatTable];
    
    TO_WEAK(self, weakSelf);
    loseFatTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getVideoDataList];
    }];
    
    [self startLoadingAnimation];
    [self getVideoDataList];
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:loseFatTable.bounds placeholderImage:nil placeholderText:nil];
        [loseFatTable addSubview:_emptyView];
    }
    
    return _emptyView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
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
   
    SimulatedExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (!cell) {
        cell = [[SimulatedExerciseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    QuestionModel *model = _dataArr[indexPath.section];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionModel *model = _dataArr[indexPath.section];
    if (!model.isOnline) {
        return;
    }

    if (!([model.classesCount isNotEmpty] && [model.classesCount integerValue] > 0)) {
        //不为空
        CourseListViewController *courseList = [[CourseListViewController alloc] init];
        courseList.hidesBottomBarWhenPushed = YES;
        courseList.videoTypeId = model.id;
        courseList.viewTitle = model.name;
        courseList.EnglishTitle = @"Lose Fat";
        courseList.videoEnum = Course_actOpeVideo;
        courseList.totalPrice = model.price/100;
        [courseList setModel:model];
        TO_WEAK(self, weakSelf);
        courseList.PaySuccessCallbackBlock = ^{
            [weakSelf getVideoDataList];
        };
        [self.viewController.navigationController pushViewController:courseList animated:YES];
    }else {
        ActOpeListViewController *actOpeList = [[ActOpeListViewController alloc] init];
        actOpeList.hidesBottomBarWhenPushed = YES;
        actOpeList.videoTypeId = model.id;
        actOpeList.viewTitle = model.name;
        actOpeList.videoEnum = Course_actOpeVideo;
        [self.viewController.navigationController pushViewController:actOpeList animated:YES];
    }

}

#pragma mark -- 获取分页数据
- (void)getVideoDataList {
    
    NSDictionary *para = @{
                           @"id":@(_videoTypeId?_videoTypeId:0)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kApiClassFindAllByParent parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            [strongSelf->_dataArr removeAllObjects];
            for (NSDictionary *tmp in list) {
                @autoreleasepool {
                    QuestionModel *model = [[QuestionModel alloc] initWithDictionary:tmp error:nil];
                    [strongSelf->_dataArr addObject:model];
                }
            }
            
            [strongSelf->loseFatTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
        [strongSelf->loseFatTable.mj_header endRefreshing];
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
         [weakSelf stopLoadingAnimation];
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
        [strongSelf->loseFatTable.mj_header endRefreshing];
    }];
}


@end
