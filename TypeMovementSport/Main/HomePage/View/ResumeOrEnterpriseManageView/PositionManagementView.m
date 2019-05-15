//
//  PositionManagementView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/11/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PositionManagementView.h"
#import "MJRefresh.h"
#import "ApplyJobListCell.h"
#import "EmptyView.h"

//model
#import "PositionModel.h"

//vc
#import "PositionDetailViewController.h"

@interface PositionManagementView () <
    UITableViewDelegate,
    UITableViewDataSource>
{
    UITableView *mainTable;
    NSInteger pageNum;
    NSInteger pageSize;
    NSMutableArray *dataArr;
}

@property (nonatomic, strong) NSDictionary *requestPara;
@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation PositionManagementView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initPositionManagementView:(PositionManamentEnum)positionEnum frame:(CGRect)frame requestPara:(NSDictionary *)requestPara {
    if (self = [super initWithFrame:frame]) {
        self.positionEnum = positionEnum;
        self.requestPara = requestPara;
        pageNum = 0;
        pageSize = 10;
        dataArr = [NSMutableArray array];
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0,*)) {
        mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainTable.estimatedRowHeight = 0;
        mainTable.estimatedSectionHeaderHeight = 0;
        mainTable.estimatedSectionFooterHeight = 0;
    }
    [self addSubview:mainTable];
    
    TO_WEAK(self, weakSelf);
    
    mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->pageNum = 0;
        switch (weakSelf.positionEnum) {
            case CompanyPublishPosition:{
                //公司发布的职位
                [weakSelf getPositionListByUrl:kPositionList];
            }
                break;
            case UserSendToCompanyPosition:{
                //投递的职位
                [weakSelf getPositionListByUrl:kDeliveryPositionList];
            }
                break;
            case UserCollectionPosition:{
                //收藏的职位
                [weakSelf getPositionListByUrl:kCollectionPositionList];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [mainTable.mj_header beginRefreshing];
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:mainTable.bounds placeholderImage:nil placeholderText:nil];
        [mainTable addSubview:_emptyView];
    }
    
    return _emptyView;
}

- (void)setTableHeight:(CGFloat)height {
    mainTable.height = height;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
//    CGSize size;
//    if (self.isEnterpriseManagement) {
//        if (_companyInfoDic[@"companyIntroduction"]) {
//            size = [UITool sizeOfStr:_companyInfoDic[@"companyIntroduction"]
//                             andFont:Font(K_TEXT_FONT_12)
//                          andMaxSize:CGSizeMake(kScreenWidth-70-FIT_SCREEN_WIDTH(15), MAXFLOAT)
//                    andLineBreakMode:NSLineBreakByCharWrapping];
//        }
//    }else {
//        if (_resumeModel.introduction) {
//            size = [UITool sizeOfStr:_resumeModel.introduction
//                             andFont:Font(K_TEXT_FONT_12)
//                          andMaxSize:CGSizeMake(kScreenWidth-70-FIT_SCREEN_WIDTH(15), MAXFLOAT)
//                    andLineBreakMode:NSLineBreakByCharWrapping];
//        }
//    }
//    if (size.height > 12) {
//        return 120 + size.height - 12;
//    }
//    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
//    return [self createHeaderView];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
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
    if (self.positionEnum == CompanyPublishPosition) {
        detail.isSelfPublishPosition = YES;
    }
    [self.viewController.navigationController pushViewController:detail animated:YES];
}


- (void)reloadData {
    pageNum = 0;
    switch (self.positionEnum) {
        case CompanyPublishPosition:{
            //公司发布的职位
            [self getPositionListByUrl:kPositionList];
        }
            break;
        case UserSendToCompanyPosition:{
            //投递的职位
            [self getPositionListByUrl:kDeliveryPositionList];
        }
            break;
        case UserCollectionPosition:{
            //收藏的职位
            [self getPositionListByUrl:kCollectionPositionList];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -- 获取职位列表
- (void)getPositionListByUrl:(NSString *)url {
    
    NSMutableDictionary *para = @{
                           @"offset":@(pageNum*10),
                           @"max":@10
                           }.mutableCopy;
    
    if (self.requestPara) {
        NSArray *allKeys = self.requestPara.allKeys;
        for (NSString *key in allKeys) {
            [para setObject:self.requestPara[key] forKey:key];
        }
    }
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:url parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (strongSelf->pageNum == 0) {
                [strongSelf->dataArr removeAllObjects];
            }
            /*
             "id": 2,
             "companyId": 1,
             "name": "教练22222222222",
             "city": "北京",
             "addr": "北京",
             "property": "自由发挥",
             "exp": "自由发挥",
             "duty": "自由发挥",
             "demand": "自由发挥",
             "hopealary": "自由发挥",
             "education": "自由发挥",
             "height": "自由发挥",
             "weight": "自由发挥",
             "state": "OPEN",
             "tips": {
             "name": "职位名称",
             "city": "工作城市",
             "addr": "工作地点",
             "property": "工作性质",
             "exp": "工作经验",
             "duty": "工作职责",
             "demand": "任职要求",
             "hopealary": "薪资要求",
             "education": "学历要求",
             "height": "身高要求",
             "weight": "体重要求",
             "state": "状态  OPEN | CLOSE"
             }
             */
            NSArray *list = dict[@"list"];
            
            if (list.count >= 10) {
                strongSelf->pageNum += 1;
                if (strongSelf->mainTable.mj_footer == nil) {
                    strongSelf->mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf getPositionListByUrl:url];
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

    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->mainTable.mj_header endRefreshing];
        if (strongSelf->mainTable.mj_footer) {
            [strongSelf->mainTable.mj_footer endRefreshing];
        }
        weakSelf.emptyView.hidden = !(strongSelf->dataArr.count < 1);

    }];
}

@end
