//
//  ArticleView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleView.h"
#import "ArticleListCell.h"
#import "ArticleDetailViewController.h"
#import "BaseNavigationViewController.h"
#import "ArticleViewController.h"

//view
#import "MJRefresh.h"
#import "EmptyPlaceholderTipsView.h"
#import "EmptyView.h"

//model
#import "ArticleListModel.h"

@interface ArticleView () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *articleTable;
        NSMutableArray *dataArr;
        NSInteger pageNum;
        BOOL isFromMyCollection;//我的收藏
}

@property (nonatomic, assign) NSInteger articleChannelId;//文章频道id
@property (nonatomic, strong) EmptyPlaceholderTipsView *tipsView;
@property (nonatomic, strong) EmptyView *emptyView;//空白view

@end

@implementation ArticleView

- (instancetype)initArticleViewWithFrame:(CGRect)frame
                        articleChannelId:(NSInteger)articleChannelId
                        isFromCollection:(BOOL)isFromCollection{
    if (self = [super initWithFrame:frame]) {
        
        isFromMyCollection = isFromCollection;
        pageNum = 0;
        dataArr = [NSMutableArray array];
        self.articleChannelId = articleChannelId;
        self.backgroundColor = [UIColor colorWithRed:248/256.0 green:248/256.0 blue:248/256.0 alpha:1];
        [self createUI];
    }
    
    return self;
    
}

- (void)createUI {
    articleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    
    articleTable.delegate = self;
    articleTable.dataSource = self;
    articleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        articleTable.estimatedRowHeight = 0;
        articleTable.estimatedSectionHeaderHeight = 0;
        articleTable.estimatedSectionFooterHeight = 0;
        articleTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    articleTable.backgroundColor = [UIColor colorWithRed:248/256.0 green:248/256.0 blue:248/256.0 alpha:1];
    [self addSubview:articleTable];
    
    __weak typeof(self) weakSelf = self;
    articleTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->pageNum = 0;
        [weakSelf getArticleList];
    }];
    
    if (!isFromMyCollection) {
        articleTable.tableFooterView = [self createFooterView];
    }else {
        [self startLoadingAnimation];
        [self getArticleList];
    }
    
    
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:articleTable.bounds placeholderImage:nil placeholderText:nil];
        [articleTable addSubview:_emptyView];
    }
    return _emptyView;
}

- (EmptyPlaceholderTipsView *)tipsView {
    if (_tipsView == nil) {
        
        TO_WEAK(self, weakSelf);
        NSString *info = @"您还没有收藏任何文字哦！";
        _tipsView = [[EmptyPlaceholderTipsView alloc] initWithFrame:self.bounds title:nil info:info block:^{
            //点击占位view
            ArticleViewController *articleVC = [ArticleViewController new];
            [weakSelf.viewController.navigationController pushViewController:articleVC animated:YES];
//            [weakSelf.viewController.navigationController.tabBarController setSelectedIndex:0];
//            [weakSelf.viewController.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    
    return _tipsView;
}

- (UIView *)createFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    UILabel *endLab = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_10)];
    endLab.text = @"- End -";
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.frame = CGRectMake(0, 0, footerView.width, 30);
    
    [footerView addSubview:endLab];
    
    return footerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FIT_SCREEN_HEIGHT(141);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
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
    ArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ArticleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    ArticleListModel *model = dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailViewController *articleDetail = [[ArticleDetailViewController alloc]init];
    articleDetail.hidesBottomBarWhenPushed = YES;
    if (isFromMyCollection) {
        TO_WEAK(self, weakSelf);
        articleDetail.articleCollectionResultBlock = ^{
            TO_STRONG(weakSelf, strongSelf);
            [strongSelf->articleTable.mj_header beginRefreshing];
        };
    }
    ArticleListModel *model = dataArr[indexPath.row];
    articleDetail.articleId = model.id;
    articleDetail.navTitle = model.name;
    [self.viewController.navigationController pushViewController:articleDetail animated:YES];
}

- (void)loadData {
    [articleTable.mj_header beginRefreshing];
    
    [self startLoadingAnimation];
}

#pragma mark -- 获取文章数据
- (void)getArticleList {
    
    NSString *url = kPublicArticleList;
    NSMutableDictionary *para = @{
                                  @"articleChannelId":_articleChannelId?@(_articleChannelId):@0,
                           @"offset":[NSString stringWithFormat:@"%ld",(long)pageNum*10],
                           @"max":@"10"
                           }.mutableCopy;
    
    if (isFromMyCollection) {
        //我的收藏
        [para removeObjectForKey:@"articleChannelId"];
        url = kArticleCollectionList;
    }
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:url parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
       
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            //成功
            if (strongSelf->pageNum == 0) {
                [strongSelf->dataArr removeAllObjects];
            }
            NSArray *list = dict[@"list"];
            
            strongSelf->pageNum += 1;
            if (list.count < 10) {
                //无分页
                strongSelf->articleTable.mj_footer = nil;
            }else {
                if (strongSelf->articleTable.mj_footer == nil) {
                    strongSelf->articleTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf getArticleList];
                    }];
                }
            }
            for (NSDictionary *tmp in list) {
                ArticleListModel *model = [[ArticleListModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->dataArr addObject:model];
            }
            
            [strongSelf->articleTable reloadData];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [strongSelf->articleTable.mj_header endRefreshing];
        if (strongSelf->articleTable.mj_footer) {
            [strongSelf->articleTable.mj_footer endRefreshing];
        }
        
        if (strongSelf->dataArr.count < 1) {
            
            strongSelf->articleTable.tableFooterView = nil;
            if (strongSelf->isFromMyCollection) {
                [weakSelf addSubview:strongSelf.tipsView];
            }else {
                weakSelf.emptyView.hidden = NO;
            }
            
        }else {
            
            if (strongSelf->articleTable.tableFooterView == nil) {
                strongSelf->articleTable.tableFooterView = [weakSelf createFooterView];
            }
            if (strongSelf->isFromMyCollection) {
                [strongSelf.tipsView removeFromSuperview];
            }else {
                weakSelf.emptyView.hidden = YES;
            }
        }
        
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->articleTable.mj_header endRefreshing];
        if (strongSelf->articleTable.mj_footer) {
            [strongSelf->articleTable.mj_footer endRefreshing];
        }
        
        if (strongSelf->dataArr.count < 1) {
            
            strongSelf->articleTable.tableFooterView = nil;
            if (strongSelf->isFromMyCollection) {
                [weakSelf addSubview:strongSelf.tipsView];
            }else {
                weakSelf.emptyView.hidden = NO;
            }
            
        }else {
            if (strongSelf->isFromMyCollection) {
                [strongSelf.tipsView removeFromSuperview];
            }else {
                weakSelf.emptyView.hidden = YES;
            }
        }
        [weakSelf stopLoadingAnimation];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
