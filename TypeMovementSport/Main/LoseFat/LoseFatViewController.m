//
//  LoseFatViewController.m
//  TypeMovementSport
//
//  Created by 小二郎 on 2019/7/11.
//  Copyright © 2019年 小二郎. All rights reserved.
//

#import "LoseFatViewController.h"
#import "CourseDetailListViewController.h"
#import "CourseListViewController.h"
#import "BaseNavigationViewController.h"
#import "ActOpeListViewController.h"

#import "BoldNavigationTitleView.h"
#import "EmptyView.h"
#import "ParamFile.h"
#import "Course_theoryHeaderCell.h"
#import "Course_theoryPlayCell.h"
#import "Course_theoryHeaderView.h"
#import "SimulatedExerciseCell.h"
#import "MJRefresh.h"

@interface LoseFatViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *loseFatTable;
    NSMutableArray *_dataArr;
}

@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation LoseFatViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavBarColor:[UIColor whiteColor]];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hiddenBackBtn];
    UIView *topView = [[BoldNavigationTitleView alloc] initBoldNavigationTitleView:@"LoseFat 减脂" boldPart:@"LoseFat"];
    
    self.navigationItem.titleView = topView;
    _dataArr = [NSMutableArray array];
    [self createUI];
}

- (void)createUI {
    loseFatTable = [[UITableView alloc]initWithFrame:
                    CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStyleGrouped];
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
    [self.view addSubview:loseFatTable];
    
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
//    if (section == _dataArr.count-1 && _dataArr.count > 0) {
//        return 60;
//    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == _dataArr.count-1 && _dataArr.count > 0) {
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
//        UILabel *label = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_10)];
//        label.textAlignment = NSTextAlignmentCenter;
//        [footerView addSubview:label];
//        label.text = @"此模块为线上国职健身教练专业理论课视频辅助课件由专业的国家职业资格培训师录制";
//        label.numberOfLines = 0;
//        label.lineBreakMode = NSLineBreakByCharWrapping;
//        label.frame = CGRectMake(FIT_SCREEN_WIDTH(73), 20, kScreenWidth-FIT_SCREEN_WIDTH(73)*2, 40);
//
//        return footerView;
//    }
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
        courseList.EnglishTitle = @"LoseFat";
        courseList.totalPrice = model.price/100;
        courseList.videoEnum = Course_theoryVideo;
        [courseList setModel:model];
        TO_WEAK(self, weakSelf);
        courseList.PaySuccessCallbackBlock = ^{
            [weakSelf getVideoDataList];
        };
        [self.navigationController pushViewController:courseList animated:YES];
    }else {
            ActOpeListViewController *actOpeList = [[ActOpeListViewController alloc] init];
            actOpeList.hidesBottomBarWhenPushed = YES;
            actOpeList.videoTypeId = model.id;
            actOpeList.viewTitle = model.name;
            actOpeList.videoEnum = Course_actOpeVideo;
            [self.navigationController pushViewController:actOpeList animated:YES];
    }
    
    
}

#pragma mark -- 获取分页数据
- (void)getVideoDataList {
    
    NSDictionary *para = @{
                           @"id":@(266)
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
