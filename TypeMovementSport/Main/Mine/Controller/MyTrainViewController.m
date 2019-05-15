//
//  MyTrainViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "MyTrainViewController.h"
#import "IncreaseTrainViewController.h"

//view
#import "MyTrainListCell.h"
#import "MJRefresh.h"
#import "EmptyPlaceholderTipsView.h"

//model
#import "TrainModel.h"

@interface MyTrainViewController () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *mainTableView;
        NSInteger pageNum;
        NSInteger pageSize;
        NSMutableArray *dataArr;
        
}

@property (nonatomic, strong) EmptyPlaceholderTipsView *tipsView;

@end

@implementation MyTrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"我的培训"];
    
    dataArr = [NSMutableArray array];
    
    [self createTabelView];
}


- (void)createTabelView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    if (@available(iOS 11.0,*)) {
        mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainTableView.estimatedRowHeight = 0;
        mainTableView.estimatedSectionHeaderHeight = 0;
        mainTableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:mainTableView];

    mainTableView.rowHeight = kScreenWidth/2.5;
    mainTableView.sectionFooterHeight = 0.001;
    mainTableView.sectionHeaderHeight = 0.001;
    
     __weak typeof(self) weakSelf = self;
    mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->pageNum = 0;
        
        [weakSelf getTrainListData];
    }];
    
    [self startLoadingAnimation];
    [self getTrainListData];
}

- (EmptyPlaceholderTipsView *)tipsView {
    if (_tipsView == nil) {
        
        TO_WEAK(self, weakSelf);
        NSString *info = @"您暂时还没有报名任何培训课程，有更多的课程去选择，快去报名参加吧！";
        _tipsView = [[EmptyPlaceholderTipsView alloc] initWithFrame:self.view.bounds title:nil info:info block:^{
            //点击占位view
            NSArray *viewControllers = weakSelf.navigationController.viewControllers;
            
            if (viewControllers.count > 1) {
                UIViewController *viewController = viewControllers[viewControllers.count-2];
                if ([viewController isKindOfClass:IncreaseTrainViewController.class]) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else {
                    IncreaseTrainViewController *increaseTrain = [[IncreaseTrainViewController alloc] init];
                    [weakSelf.navigationController pushViewController:increaseTrain animated:YES];
                }
            }
        }];
    }
    
    return _tipsView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTrainListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MyTrainListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.model = dataArr[indexPath.row];

    return cell;
    
}

# pragma mark -- 评价交易
- (void)commentTradoAction:(UIButton *)btn {
    
}

#pragma mark -- 获取增值培训列表
- (void)getTrainListData {
    NSDictionary *para = @{
                           @"offset":@(pageNum*pageSize),
                           @"max":@(pageSize)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserTrainList parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (strongSelf->pageNum == 0) {
                [strongSelf->dataArr removeAllObjects];
            }
            
            NSArray *list = dict[@"list"];
            
            if (list.count >= 10) {
                strongSelf->pageNum += 1;
                if (strongSelf->mainTableView == nil) {
                    strongSelf->mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf getTrainListData];
                    }];
                }
            }else{
                strongSelf->mainTableView.mj_footer = nil;
            }
            for (NSDictionary *tmp in list) {
                TrainModel *model = [[TrainModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->dataArr addObject:model];
            }
            
            if (strongSelf->dataArr.count < 1) {
                [self.view addSubview:self.tipsView];
            }else {
                [strongSelf->mainTableView reloadData];
            }
            
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [strongSelf->mainTableView.mj_header endRefreshing];
        if (strongSelf->mainTableView.mj_footer) {
            [strongSelf->mainTableView.mj_footer endRefreshing];
        }
        
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->mainTableView.mj_header endRefreshing];
        if (strongSelf->mainTableView.mj_footer) {
            [strongSelf->mainTableView.mj_footer endRefreshing];
        }
        
        [weakSelf stopLoadingAnimation];
        if (strongSelf->dataArr.count < 1) {
            [self.view addSubview:self.tipsView];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    if ([mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
