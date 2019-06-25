//
//  ActOpeListViewController.m
//  TypeMovementSport
//
//  Created by 小二郎 on 2019/5/4.
//  Copyright © 2019年 小二郎. All rights reserved.
//

#import "ActOpeListViewController.h"
#import "CourseListViewController.h"
#import "BaseNavigationViewController.h"

#import "SimulatedExerciseCell.h"
#import "EmptyView.h"
#import "MJRefresh.h"
#import "BoldNavigationTitleView.h"

@interface ActOpeListViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView *actOpeTable;//实操table
    NSMutableArray *_dataArr;
}

@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation ActOpeListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavBarColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenBackBtn];
    _dataArr = [NSMutableArray array];
    
    NSString *navTitle = [NSString stringWithFormat:@"Course %@",_viewTitle];
    UIView *topView = [[BoldNavigationTitleView alloc] initBoldNavigationTitleView:navTitle boldPart:@"Course"];
    
    CGFloat wdtBtn = 15+10;
    UIButton *cancelBtn = [ButtonTool createButtonWithImageName:@"general_cancel" addTarget:self action:@selector(goBack)];
    cancelBtn.frame = CGRectMake(topView.width - 20 - wdtBtn, 0, wdtBtn, wdtBtn);
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [topView addSubview:cancelBtn];
    
    self.navigationItem.titleView = topView;
        
    [self createUI];
}

- (void)createUI {
    actOpeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    actOpeTable.delegate = self;
    actOpeTable.dataSource = self;
    actOpeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        actOpeTable.estimatedRowHeight = 0;
        actOpeTable.estimatedSectionHeaderHeight = 0;
        actOpeTable.estimatedSectionFooterHeight = 0;
        actOpeTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    actOpeTable.rowHeight = FIT_SCREEN_HEIGHT(105);
    [self.view addSubview:actOpeTable];
    
    TO_WEAK(self, weakSelf);
    actOpeTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getVideoDataList];
    }];
    
    [self startLoadingAnimation];
    [self getVideoDataList];
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:actOpeTable.bounds placeholderImage:nil placeholderText:nil];
        [actOpeTable addSubview:_emptyView];
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
    
//    if ([model.videoList isNotEmpty]) {
        //不为空
        CourseListViewController *courseList = [[CourseListViewController alloc] init];
        courseList.hidesBottomBarWhenPushed = YES;
        courseList.videoTypeId = model.id;
        courseList.viewTitle = model.name;
        courseList.EnglishTitle = self.viewTitle;
        courseList.videoEnum = self.videoEnum;
        courseList.totalPrice = model.price/100;
        [courseList setModel:model];
        TO_WEAK(self, weakSelf);
        courseList.PaySuccessCallbackBlock = ^{
            [weakSelf getVideoDataList];
        };
        [self.navigationController pushViewController:courseList animated:YES];
//    }else {
//        ActOpeListViewController *actOpeList = [[ActOpeListViewController alloc] init];
//        actOpeList.hidesBottomBarWhenPushed = YES;
//        actOpeList.videoTypeId = model.id;
//        actOpeList.viewTitle = model.name;
//        actOpeList.videoEnum = self.videoEnum;
//        [self.navigationController pushViewController:actOpeList animated:YES];
//    }
    
    
   
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
            
            [strongSelf->actOpeTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
        [strongSelf->actOpeTable.mj_header endRefreshing];
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [weakSelf stopLoadingAnimation];
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
        [strongSelf->actOpeTable.mj_header endRefreshing];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
