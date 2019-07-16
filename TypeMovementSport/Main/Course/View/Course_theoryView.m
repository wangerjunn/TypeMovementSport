//
//  Course_theoryView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/10.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "Course_theoryView.h"
#import "ParamFile.h"

#import "Course_theoryHeaderCell.h"
#import "Course_theoryPlayCell.h"
#import "Course_theoryHeaderView.h"
#import "SimulatedExerciseCell.h"
#import "EmptyView.h"
#import "MJRefresh.h"

//vc
#import "CourseDetailListViewController.h"
#import "CourseListViewController.h"
#import "BaseNavigationViewController.h"
#import "ActOpeListViewController.h"

@interface Course_theoryView () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *theoryTable;
    NSInteger _videoTypeId;
    NSMutableArray *_dataArr;
}

@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation Course_theoryView

- (instancetype)initWithFrame:(CGRect)frame videoTypeId:(NSInteger)videoTypeId {
    if (self = [super initWithFrame:frame]) {
        
        _videoTypeId = videoTypeId;
        _dataArr = [NSMutableArray array];
        
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    theoryTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) style:UITableViewStyleGrouped];
    theoryTable.delegate = self;
    theoryTable.dataSource = self;
    theoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        theoryTable.estimatedRowHeight = 0;
        theoryTable.estimatedSectionHeaderHeight = 0;
        theoryTable.estimatedSectionFooterHeight = 0;
        theoryTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    theoryTable.rowHeight = FIT_SCREEN_HEIGHT(105);
    [self addSubview:theoryTable];
    
    TO_WEAK(self, weakSelf);
    theoryTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getVideoDataList];
    }];
    
    [self startLoadingAnimation];
    [self getVideoDataList];
    
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:theoryTable.bounds placeholderImage:nil placeholderText:nil];
        [theoryTable addSubview:_emptyView];
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
    if (section == _dataArr.count-1 && _dataArr.count > 0) {
        return 60;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _dataArr.count-1 && _dataArr.count > 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        UILabel *label = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_10)];
        label.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:label];
        label.text = @"此模块为线上国职健身教练专业理论课视频辅助课件由专业的国家职业资格培训师录制";
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(FIT_SCREEN_WIDTH(73), 20, kScreenWidth-FIT_SCREEN_WIDTH(73)*2, 40);
        
        return footerView;
    }
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
        courseList.EnglishTitle = @"Basic";
        courseList.totalPrice = model.price/100;
        courseList.videoEnum = Course_theoryVideo;
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
            
            [strongSelf->theoryTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
        [strongSelf->theoryTable.mj_header endRefreshing];
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
         [weakSelf stopLoadingAnimation];
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);

        [strongSelf->theoryTable.mj_header endRefreshing];
        
    }];
}

@end
