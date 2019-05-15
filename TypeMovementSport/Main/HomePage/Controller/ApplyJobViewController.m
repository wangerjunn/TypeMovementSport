//
//  ApplyJobViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ApplyJobViewController.h"
#import "PositionDetailViewController.h"
#import "ResumeManagementViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "PersonalResumeViewController.h"

//view
#import "ApplyJobListCell.h"
#import "HP_CityMenuView.h"//城市view
#import "HP_SalaryMenuView.h"//薪资
#import "HP_RequireMenuView.h"//要求
#import "MJRefresh.h"
#import "EmptyView.h"

//model
#import "PositionModel.h"
#import "ResumeModel.h"

@interface ApplyJobViewController () <
    UITableViewDelegate,
    UITableViewDataSource> {
    UITableView *mainTable;
    NSInteger pageNum;
    NSInteger pageSize;
    NSMutableArray *dataArr;
        
        UIButton *cityBtn;//城市
        UIButton *salaryBtn;//薪资按钮
        UIButton *requireBtn;//要求按钮
        
        NSString *seleCity;//选择城市
        NSIndexPath *seleIndex;//选择城市的下标
        
        NSString *seleSalaray;//选择薪资
        NSMutableArray *seleRequireArr;//提交数据时便利数组
        
}

@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) HP_CityMenuView *cityMenuView;
@property (nonatomic, strong) HP_SalaryMenuView *salaryMenuView;
@property (nonatomic, strong) HP_RequireMenuView *requireMenuView;
@property (nonatomic, copy) NSString *testCon;

@end

@implementation ApplyJobViewController

- (void)goBack {
    
    [super goBack];
    
    if (_cityMenuView) {
        [_cityMenuView removeFromSuperview];
    }
    
    if (_salaryMenuView) {
        [_salaryMenuView removeFromSuperview];
    }
    
    if (_requireMenuView) {
        [_requireMenuView removeFromSuperview];
    }    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_cityMenuView) {
        [_cityMenuView removeFromSuperview];
    }
    
    if (_salaryMenuView) {
        [_salaryMenuView removeFromSuperview];
    }
    
    if (_requireMenuView) {
        [_requireMenuView removeFromSuperview];
    } 
}

# pragma mark -- 简历管理
- (void)resumeManage {
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    [self resumeFind];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"我要求职"];
    [self setNavItemWithTitle:@"简历管理" isLeft:NO target:self action:@selector(resumeManage)];
    
    [self createUI];
}

- (UIView *)createTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.shadowColor = k210Color.CGColor;
    topView.layer.shadowOffset = CGSizeMake(0, 5);//偏移距离
    topView.layer.shadowOpacity = 0.43;//不透明度
    topView.layer.shadowRadius = 5.0;//半径
    
    NSArray *titlesArr = @[@"城市",@"薪资",@"要求"];
    
    CGFloat btnWdt = kScreenWidth/titlesArr.count;
    for (int i = 0; i < titlesArr.count; i++) {
        UIButton *btn = [ButtonTool createButtonWithTitle:nil titleColor:k46Color titleFont:Font(14) addTarget:self action:@selector(showMenuView:)];
        btn.frame = CGRectMake(btnWdt * i, 0, btnWdt-1, topView.height);
        btn.tag = 100 + i;
        [btn setTitleColor:kOrangeColor forState:UIControlStateSelected];
        [topView addSubview:btn];
        if (i < 2) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btnWdt*(i+1), topView.height/2.0-7, 1, 14)];
            line.backgroundColor = k46Color;
            [topView addSubview:line];
        }
        
        
        UILabel *label = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
        label.text = titlesArr[i];
        [label sizeToFit];
        
        label.frame = CGRectMake(btn.width/2.0-label.width/2.0, 0, label.width, btn.height);
        label.tag = 1000;
        [btn addSubview:label];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(label.right+5, btn.height/2.0-4, 8, 8)];
        icon.tag = 1001;
        icon.image = [UIImage imageNamed:@"general_pulldown"];
        [btn addSubview:icon];
        
        switch (i) {
            case 0:
                cityBtn = btn;
                break;
            case 1:
                salaryBtn = btn;
                break;
            case 2:
                requireBtn = btn;
                break;
                
            default:
                break;
        }
    }
    return topView;
}

- (void)createUI {
    
    pageNum = 0;
    pageSize = 10;
    dataArr = [NSMutableArray array];
    
    UIView *topView = [self createTopView];
    
    [self.view addSubview:topView];
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.bottom, kScreenWidth, kScreenHeight - topView.bottom - kNavigationBarHeight) style:UITableViewStylePlain];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    if (@available(iOS 11.0,*)) {
        mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainTable.estimatedRowHeight = 0;
        mainTable.estimatedSectionHeaderHeight = 0;
        mainTable.estimatedSectionFooterHeight = 0;
    }
    mainTable.rowHeight = 140;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    
    __weak typeof(self) weakSelf = self;
    mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->pageNum = 0;
                [weakSelf getPositionList];
    }];
    [self.view bringSubviewToFront:topView];
    
    [self startLoadingAnimation];
    [self getPositionList];
    
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:mainTable.bounds placeholderImage:nil placeholderText:nil];
        [mainTable addSubview:_emptyView];
    }

    return _emptyView;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApplyJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[ApplyJobListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    PositionModel *model = dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    PositionModel *model = dataArr[indexPath.row];
    PositionDetailViewController *cell = [[PositionDetailViewController alloc] init];
    cell.positionId = model.id;

    [self.navigationController pushViewController:cell animated:YES];
}

# pragma mark -- 显示菜单view 城市 | 薪资 | 要求
- (void)showMenuView:(UIButton *)btn {
    
    UIView *topView = (UIView *)[btn superview];
    for (int i = 0; i < 3; i++) {
        UIButton *tmpBtn = (UIButton *)[topView viewWithTag:100+i];
        UILabel *label = (UILabel *)[tmpBtn viewWithTag:1000];
        UIImageView *icon = (UIImageView *)[tmpBtn viewWithTag:1001];
        
        label.textColor = k46Color;
        icon.image = [UIImage imageNamed:@"general_pulldown"];
    }
    
    UILabel *label = (UILabel *)[btn viewWithTag:1000];
    UIImageView *icon = (UIImageView *)[btn viewWithTag:1001];
    label.textColor = kOrangeColor;
    icon.image = [UIImage imageNamed:@"general_pullup"];

    switch (btn.tag) {
        case 100:{
            //城市
            if (_salaryMenuView) {
                [_salaryMenuView removeFromSuperview];
                _salaryMenuView = nil;
            }
            
            if (_requireMenuView) {
                [_requireMenuView removeFromSuperview];
                _requireMenuView = nil;
            }
            [self.cityMenuView show];
            
            
            
        }
            break;
        case 101:{
            //薪资
            if (_cityMenuView) {
                [_cityMenuView removeFromSuperview];
                _cityMenuView = nil;
            }
            
            if (_requireMenuView) {
                [_requireMenuView removeFromSuperview];
                _requireMenuView = nil;
            }
            [self.salaryMenuView show];
            
        }
            break;
        case 102:{
            //要求
            if (_cityMenuView) {
                [_cityMenuView removeFromSuperview];
                _cityMenuView = nil;
            }
            if (_salaryMenuView) {
                [_salaryMenuView removeFromSuperview];
                _salaryMenuView = nil;
            }
            
            [self.requireMenuView show];
        }
            break;
            
        default:
            break;
    }
}

- (HP_CityMenuView *)cityMenuView {
    if (!_cityMenuView) {
        
        TO_WEAK(self, weakSelf);
        _cityMenuView = [[HP_CityMenuView alloc] initCityMenuViewByFrame:CGRectMake(0, mainTable.top+kNavigationBarHeight, kScreenWidth, mainTable.height) seleIndex:seleIndex seleBlock:^(NSString *seleCon, NSIndexPath *index) {
            TO_STRONG(weakSelf, strongSelf);
            strongSelf->seleCity = seleCon;
            strongSelf->seleIndex = index;
            UILabel *label = (UILabel *)[strongSelf->cityBtn viewWithTag:1000];
            UIImageView *icon = (UIImageView *)[strongSelf->cityBtn viewWithTag:1001];
            label.textColor = k46Color;
            icon.image = [UIImage imageNamed:@"general_pulldown"];
            
            label.text = seleCon;
            
            [label sizeToFit];
            
            if (label.width > (strongSelf->cityBtn.width - 5 - 8)) {
                label.width = strongSelf->cityBtn.width - 13;
            }
            
            label.frame = CGRectMake((strongSelf->cityBtn.width-13)/2.0-label.width/2.0, 0, label.width, strongSelf->cityBtn.height);
            icon.left = label.right + 5;
            
            [strongSelf getPositionList];
        }];
    }
    
    return _cityMenuView;
    
}

- (HP_SalaryMenuView *)salaryMenuView {
    if (!_salaryMenuView) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PopDataConfig" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *arr = dic[kHopeSalary];
        
        TO_WEAK(self, weakSelf);
        _salaryMenuView = [[HP_SalaryMenuView alloc]initCityMenuViewByFrame:CGRectMake(0, mainTable.top+kNavigationBarHeight, kScreenWidth, mainTable.height) arr:arr seleContent:seleSalaray seleBlock:^(NSString *seleCon) {
            TO_STRONG(weakSelf, strongSelf);
            strongSelf->seleSalaray = seleCon;
            UILabel *label = (UILabel *)[strongSelf->salaryBtn viewWithTag:1000];
            UIImageView *icon = (UIImageView *)[strongSelf->salaryBtn viewWithTag:1001];
            
            label.text = seleCon;
            label.textColor = k46Color;
            icon.image = [UIImage imageNamed:@"general_pulldown"];
            
            [label sizeToFit];
            
            if (label.width > (strongSelf->cityBtn.width - 5 - 8)) {
                label.width = strongSelf->cityBtn.width - 13;
            }
            
            label.frame = CGRectMake((strongSelf->cityBtn.width-13)/2.0-label.width/2.0, 0, label.width, strongSelf->cityBtn.height);
            icon.left = label.right + 5;
            
            [strongSelf getPositionList];
        }];
    }
    
    return _salaryMenuView;
}

- (HP_RequireMenuView *)requireMenuView {
    if (!_requireMenuView) {
        
        if (!seleRequireArr) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"PopDataConfig" ofType:@"plist"];
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
            NSArray *arr_work = dic[kWorkExpYears];
            NSArray *arr_edu = dic[kEducation];
            
            NSArray *titles = @[@{@"工作经验":arr_work},
                                @{@"学历":arr_edu}
                                ];
            seleRequireArr = [NSMutableArray array];
            for (int i = 0; i < titles.count; i++) {
                
                NSDictionary *temp = titles[i];
                NSMutableArray *arr = [NSMutableArray array];
                NSArray *elements = temp.allValues.firstObject;
                for (int j = 0; j < elements.count; j++) {
                    NSString *con = elements[j];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:con forKey:@"title"];
//                    if (j == 0) {
//                        [dic setObject:@"1" forKey:@"isSele"];
//                    }else {
                        [dic setObject:@"0" forKey:@"isSele"];
//                    }
                    
                    [arr addObject:dic];
                }
                
                
                NSDictionary *tmpDic = @{
                                         @"title":temp.allKeys.firstObject,
                                         @"titles":arr
                                         };
                [seleRequireArr addObject:tmpDic];
            }
            
        }
        
        
        TO_WEAK(self, weakSelf);
        _requireMenuView = [[HP_RequireMenuView alloc]initCityMenuViewByFrame:CGRectMake(0, mainTable.top+kNavigationBarHeight, kScreenWidth, mainTable.height) arr:seleRequireArr seleBlock:^(NSMutableArray *arr) {
            TO_STRONG(weakSelf, strongSelf);
            
            strongSelf->seleRequireArr = arr;
            UILabel *label = (UILabel *)[strongSelf->requireBtn viewWithTag:1000];
            UIImageView *icon = (UIImageView *)[strongSelf->requireBtn viewWithTag:1001];
            label.textColor = k46Color;
            icon.image = [UIImage imageNamed:@"general_pulldown"];
            
            [strongSelf getPositionList];
        }];
    }
    
    return _requireMenuView;
}

#pragma mark -- 获取职位列表
- (void)getPositionList {
    
    NSMutableString *seleEdu = [NSMutableString string];
    NSMutableString *seleExp = [NSMutableString string];
    
    NSDictionary *expDic = seleRequireArr.firstObject;
    NSDictionary *eduDic = seleRequireArr.lastObject;
    NSMutableArray *expArr = expDic[@"titles"];
    NSMutableArray *eduArr = eduDic[@"titles"];
    
    for (NSMutableDictionary *tmp in expArr) {
        if ([tmp[@"isSele"] isEqualToString:@"1"] ) {
            [seleExp appendString:tmp[@"title"]];
            [seleExp appendString:@","];
        }
    }
    
    if (seleExp.length > 0) {
        seleExp = (NSMutableString*)[seleExp substringToIndex:seleExp.length-1];
    }

    for (NSMutableDictionary *tmp in eduArr) {
        if ([tmp[@"isSele"] isEqualToString:@"1"] ) {
            [seleEdu appendString:tmp[@"title"]];
            [seleEdu appendString:@","];
        }
    }
    
    if (seleEdu.length > 0) {
        seleEdu = (NSMutableString*)[seleEdu substringToIndex:seleEdu.length-1];
    }
    
    NSDictionary *para = @{
                           @"city":seleCity?seleCity:@"",
                           @"hopealary":seleSalaray?seleSalaray:@"",
                           @"education":seleEdu,
                           @"exp":seleExp,
                           @"offset":@(pageNum*pageSize),
                           @"max":@(pageSize)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kPositionList parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (strongSelf->pageNum == 0) {
                [strongSelf->dataArr removeAllObjects];
            }
           
            NSArray *list = dict[@"list"];
            
            if (list.count >= 10) {
                strongSelf->pageNum += 1;
                if (strongSelf->mainTable.mj_footer == nil) {
                    strongSelf->mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [strongSelf getPositionList];
                    }];
                }
            }else{
                strongSelf->mainTable.mj_footer = nil;
            }
            for (NSDictionary *tmp in list) {
                PositionModel *model = [[PositionModel alloc] initWithDictionary:tmp[@"position"] error:nil];
                [strongSelf->dataArr addObject:model];
            }
            
            [strongSelf->mainTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [strongSelf->mainTable.mj_header endRefreshing];
        if (strongSelf->mainTable.mj_footer) {
            [strongSelf->mainTable.mj_footer endRefreshing];
        }
        
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);
        
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->mainTable.mj_header endRefreshing];
        if (strongSelf->mainTable.mj_footer) {
            [strongSelf->mainTable.mj_footer endRefreshing];
        }
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);
         [weakSelf stopLoadingAnimation];
    }];
}

#pragma mark -- 去登录
- (void)displayLoginView {
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- 是否创建简历
- (void)resumeFind {
    [WebRequest PostWithUrlString:kResumeFind parms:nil viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        if ([remindMsg integerValue] == 999) {
            ResumeModel *model = [[ResumeModel alloc] initWithDictionary:dict[@"resume"] error:nil];
            ResumeManagementViewController *resumeManagement = [[ResumeManagementViewController alloc]init];
            resumeManagement.resumeModel = model;
            [self.navigationController pushViewController:resumeManagement animated:YES];
        }else if ([remindMsg integerValue] == 440) {
            //未创建简历
            PersonalResumeViewController *personalResume = [[PersonalResumeViewController alloc] init];
//            personalResume.resumeModel = resumeModel;
            TO_WEAK(self, weakSelf);
//            personalResume.UpdateResumeInfoBlock = ^(ResumeModel *model) {
//                TO_STRONG(weakSelf, strongSelf);
//                strongSelf->resumeModel = model;
//                [strongSelf->resumeTable reloadData];
//                if (strongSelf.UpdateResumeBlock) {
//                    strongSelf.UpdateResumeBlock(strongSelf->resumeModel);
//                }
//            };
            [weakSelf.navigationController pushViewController:personalResume animated:YES];
        } else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
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
