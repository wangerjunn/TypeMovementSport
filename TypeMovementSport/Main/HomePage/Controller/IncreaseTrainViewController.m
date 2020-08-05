//
//  IncreaseTrainViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "IncreaseTrainViewController.h"
#import "IncreaseTrainDetailViewController.h"
#import "MyTrainViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "SYCitySelectionController.h"

//view
#import "IncreaseTrainListCell.h"
#import "MJRefresh.h"
#import "EmptyView.h"

//model
#import "TrainModel.h"

@interface IncreaseTrainViewController () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *mainTableView;
        NSInteger pageNum;
        NSInteger pageSize;
        NSString *seleCity;//选择城市
        NSMutableArray *dataArr;
        UIButton *cityBtn;
}

@property (nonatomic, strong) EmptyView *emptyView;
@end

@implementation IncreaseTrainViewController

# pragma mark -- 我的培训
- (void)myTrain {
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    MyTrainViewController *myTrain = [[MyTrainViewController alloc]init];
    [self.navigationController pushViewController:myTrain animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"增值培训"];
    [self setNavItemWithTitle:@"我的培训" isLeft:NO target:self action:@selector(myTrain)];
    
    
    [self createUI];
}


- (void)createUI {
    
    pageNum = 0;
    pageSize = 10;
    if (!dataArr) {
        dataArr = [NSMutableArray array];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    UILabel *cityLab = [LabelTool createLableWithTextColor:[UIColor blackColor] font:Font(17)];
    cityLab.frame = CGRectMake(19, 0, 100, headerView.height);
    cityLab.text = @"全部城市";
    [headerView addSubview:cityLab];
    
    cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, cityLab.top, 55, headerView.height)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 25, 25, 6, 4)];
    img.image = [UIImage imageNamed:@"HP_downArrow"];
    [headerView addSubview:img];
    
    [cityBtn setTitle:@"城市选择" forState:UIControlStateNormal];
    cityBtn.titleLabel.font = Font(13);
    [cityBtn setTitleColor:[UIColor colorWithRed:255/256.0 green:107/256.0 blue:0 alpha:1] forState:UIControlStateNormal];
    
    [headerView addSubview:cityBtn];
    [cityBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchDown];
    
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 5)];
    views.backgroundColor = [UIColor colorWithRed:240/256.0 green:240/256.0 blue:240/256.0 alpha:1];
    [headerView addSubview:views];
    [self.view addSubview:headerView];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, kScreenWidth, kScreenHeight - headerView.bottom - kNavigationBarHeight) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0,*)) {
        mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainTableView.estimatedRowHeight = 0;
        mainTableView.estimatedSectionHeaderHeight = 0;
        mainTableView.estimatedSectionFooterHeight = 0;
    }
    
    mainTableView.rowHeight = 130;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    
    __weak typeof(self) weakSelf = self;
    mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->pageNum = 0;
        [weakSelf getTrainListData];
    }];
    
    [self startLoadingAnimation];
    [self getTrainListData];
    
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:mainTableView.bounds placeholderImage:nil placeholderText:@"数据更新中..."];
        [mainTableView addSubview:_emptyView];
    }
    
    return _emptyView;
}

#pragma mark - UITableViewDelegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IncreaseTrainListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[IncreaseTrainListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.model = dataArr[indexPath.row];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    
    IncreaseTrainDetailViewController *detail = [[IncreaseTrainDetailViewController alloc] init];
    TrainModel *model = dataArr[indexPath.row];
    detail.trainModel = model;
//    detail.findURLString = model.url;
//    detail.navTitle = model.title;
//    detail.shareImgString = model.img;
//    detail.brandFlag = @"";
//    detail.thenPhone = @"";
//    detail.city = model.city;
//    detail.course_id = @"0";
//    detail.time = @"2018.08-2019.09";
    
    TO_WEAK(self, weakSelf);
    detail.PaySuccessCallbackBlock = ^{
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->mainTableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

# pragma mark -- 选择城市
- (void)chooseCity {
    SYCitySelectionController *city = [SYCitySelectionController new];
    
    TO_WEAK(self, weakSelf);
    city.selectCity = ^(NSString *city) {
        TO_STRONG(weakSelf, strongSelf);
        NSLog(@"%@", city);
        
        if (![city isEqualToString:strongSelf->seleCity]) {
            strongSelf->seleCity = city;
            [strongSelf->cityBtn setTitle:city forState:UIControlStateNormal];
            [weakSelf getTrainListData];
        }
        

    };
    city.openLocation =NO;
//    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
//    b.frame = CGRectMake(0, 0, 44, 44);
//
//    [b setImage:[UIImage imageNamed:@"general_back"] forState:UIControlStateNormal];
//    b.imageEdgeInsets =UIEdgeInsetsMake(0,-20,0,0);
//    b.backgroundColor = [UIColor clearColor];
//    city.backView = b;
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:city animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -- 去登录
- (void)displayLoginView {
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- 获取增值培训列表
- (void)getTrainListData {
    NSDictionary *para = @{
                           @"city":seleCity?seleCity:@"",
                           @"offset":@(pageNum*pageSize),
                           @"max":@(pageSize)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kPublicTrainList parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (strongSelf->pageNum == 0) {
                [strongSelf->dataArr removeAllObjects];
            }
            
            NSArray *list = dict[@"list"];
            
            if (list.count >= strongSelf->pageSize) {
                strongSelf->pageNum += 1;
                if (strongSelf->mainTableView.mj_footer == nil) {
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
            
            [strongSelf->mainTableView reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [strongSelf->mainTableView.mj_header endRefreshing];
        if (strongSelf->mainTableView.mj_footer) {
            [strongSelf->mainTableView.mj_footer endRefreshing];
        }
        
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);

        
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->mainTableView.mj_header endRefreshing];
        if (strongSelf->mainTableView.mj_footer) {
            [strongSelf->mainTableView.mj_footer endRefreshing];
        }
        
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);

         [weakSelf stopLoadingAnimation];
    }];
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
