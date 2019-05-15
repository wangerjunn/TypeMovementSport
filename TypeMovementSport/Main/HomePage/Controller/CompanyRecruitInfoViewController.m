//
//  CompanyRecruitInfoViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "CompanyRecruitInfoViewController.h"
#import "PositionDetailViewController.h"

//view
#import "PositionDetailCompanyCell.h"
#import "ApplyJobListCell.h"
#import "MJRefresh.h"

//model
#import "PositionModel.h"

@interface CompanyRecruitInfoViewController () <
    UITableViewDelegate,
    UITableViewDataSource>
{
    UITableView *mainTable;
    NSInteger pageNum;
    NSInteger pageSize;
    NSMutableArray *dataArr;
}

@property (nonatomic, strong) NSDictionary *companyDic;

@end

@implementation CompanyRecruitInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"职位列表"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    pageNum = 0;
    pageSize = 10;
    dataArr = [NSMutableArray array];
    
    [self createUI];
}

- (void)createUI {
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.backgroundColor = [UIColor clearColor];
    [mainTable registerClass:[ApplyJobListCell class] forCellReuseIdentifier:@"cell"];
    if (@available(iOS 11.0,*)) {
        mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainTable.estimatedRowHeight = 0;
        mainTable.estimatedSectionHeaderHeight = 0;
        mainTable.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:mainTable];
    
    [self startLoadingAnimation];
    [self getCompanyInfo];
    [self getPositionList];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *company_intro = [NSString stringWithFormat:@"%@",self.companyDic[@"companyIntroduction"]];
    CGSize lblSize = [UITool sizeOfStr:company_intro
                               andFont:Font(K_TEXT_FONT_12)
                            andMaxSize:CGSizeMake(kScreenWidth - FIT_SCREEN_WIDTH(28*2), 1000)
                      andLineBreakMode:NSLineBreakByCharWrapping
                             lineSpace:3];
    return lblSize.height + 15 + FIT_SCREEN_HEIGHT(65);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    PositionDetailCompanyCell *cell = [[PositionDetailCompanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.companyNameLabel.text = self.companyDic[@"companyName"]?self.companyDic[@"companyName"]:@"----/-----";
    cell.scaleLabel.text = [NSString stringWithFormat:@"%@人",self.companyDic[@"companyScale"]?self.companyDic[@"companyScale"]:@"--/--"];
    [cell.logoImg sd_setImageWithURL:[NSURL URLWithString:self.companyDic[@"companLogo"]] placeholderImage:[UIImage imageNamed:holdImage]];
    cell.frame = CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(65));
    [headerView addSubview:cell];
    
    NSString *company_intro = [NSString stringWithFormat:@"%@",self.companyDic[@"companyIntroduction"]];
    
    CGSize lblSize = [UITool sizeOfStr:company_intro
                               andFont:Font(K_TEXT_FONT_12)
                            andMaxSize:CGSizeMake(kScreenWidth - FIT_SCREEN_WIDTH(28*2), 1000)
                      andLineBreakMode:NSLineBreakByCharWrapping
                             lineSpace:3];
    UILabel *introLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_12)];
    introLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(28), cell.bottom+5, lblSize.width, lblSize.height+10);
    introLabel.numberOfLines = 0;
    introLabel.text = company_intro;
    [UITool label:introLabel andLineSpacing:3 andColor:k75Color];
    
    [headerView addSubview:introLabel];

    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[ApplyJobListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    PositionModel *model = dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PositionDetailViewController *detail = [[PositionDetailViewController alloc] init];
    PositionModel *model = dataArr[indexPath.row];
    detail.positionId = model.id;
    detail.isHidenCompanyInfo = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -- 获取职位列表
- (void)getPositionList {
    
    NSDictionary *para = @{
                           @"companyId":@(self.companyId?self.companyId:0),
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
        
        if (strongSelf->mainTable.mj_footer) {
            [strongSelf->mainTable.mj_footer endRefreshing];
        }
        
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        if (strongSelf->mainTable.mj_footer) {
            [strongSelf->mainTable.mj_footer endRefreshing];
        }
        
         [weakSelf stopLoadingAnimation];
    }];
}

#pragma mark -- 获取公司信息
- (void)getCompanyInfo {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kPublicCompanyGet parms:@{@"id":@(_companyId?_companyId:0)} viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            strongSelf.companyDic = dict[@"detail"];
            
            /*
             "userId": "用户id",
             "headImg": "头像",
             "name": "姓名",
             "phone": "手机号",
             "position": "职位",
             "companyName": "公司名称",
             "companyScale": "公司规模",
             "companyWelfare": "公司福利",
             "companyIntroduction": "公司简介",
             "companLogo": "公司logo",
             "companyLicense": "公司执照",
             "state": "审核状态     NEW | PASS | NOT"
             */
            
            [strongSelf->mainTable reloadData];
        }else{
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
