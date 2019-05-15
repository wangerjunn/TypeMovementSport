//
//  ResumeManagementView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/11/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ResumeManagementView.h"
#import "ResumeDetailViewController.h"

#import "MJRefresh.h"
#import "RecruitmentListCell.h"
#import "EmptyView.h"

//model
#import "ResumeModel.h"


@interface ResumeManagementView () <
UITableViewDelegate,
UITableViewDataSource>
{
    UITableView *mainTable;
    NSInteger pageNum;
    NSInteger pageSize;
    NSMutableArray *dataArr;
}

@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) NSDictionary *requestPara;
@end

@implementation ResumeManagementView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initResumeManagementView:(ResumeManamentEnum)resumeEnum frame:(CGRect)frame requestPara:(NSDictionary *)requestPara {
    if (self = [super initWithFrame:frame]) {
        self.resumeEnum = resumeEnum;
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
        switch (weakSelf.resumeEnum) {
            case ReceiveResume:{
                //公司收到的简历
                [weakSelf getResumeListByUrl:kDeliveryPositionList];
            }
                break;
            case CollectionResume:{
                //收藏的简历
                [weakSelf getResumeListByUrl:kUserResumeList];
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
    return 98;
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
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecruitmentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[RecruitmentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    ResumeModel *model = dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResumeDetailViewController *resumeDetail = [[ResumeDetailViewController alloc] init];
    ResumeModel *model = dataArr[indexPath.row];
    resumeDetail.resumeId = model.id;
    resumeDetail.resumeEnum = BrowseRecruitmentResume;
    [self.viewController.navigationController pushViewController:resumeDetail animated:YES];
}


#pragma mark -- 获取简历列表
- (void)getResumeListByUrl:(NSString *)url {
    
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
            NSArray *list = dict[@"list"];
            
            if (list.count >= 10) {
                strongSelf->pageNum += 1;
                if (strongSelf->mainTable.mj_footer == nil) {
                    strongSelf->mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf getResumeListByUrl:url];
                    }];
                }
            }else{
                strongSelf->mainTable.mj_footer = nil;
            }
            for (NSDictionary *tmp in list) {
                ResumeModel *model = [[ResumeModel alloc] initWithDictionary:tmp[@"resume"] error:nil];
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
