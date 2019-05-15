//
//  ArticleCommentDetailViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/11/4.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleCommentDetailViewController.h"

//view
#import "ArticleCommentCell.h"
#import "ArticleCommentView.h"
#import "MJRefresh.h"

@interface ArticleCommentDetailViewController () {
    UIView *mainFooterView;
    NSMutableArray *commentsArr;
    NSInteger pageNum;
    NSInteger pageSize;
}

@end

@implementation ArticleCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setNeedsStatusBarAppearanceUpdate];
    
    self.model.isHidenTotalView = YES;
    pageNum = 0;
    pageSize = 10;
    commentsArr = [NSMutableArray array];
    [self tableFooter];
    [self initTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, mainFooterView.top) cellNibName:nil identifier:@"cell" style:UITableViewStylePlain];
    [self startLoadingAnimation];
    [self getCommentDetail];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}

#pragma mark --创建尾视图
- (void)tableFooter{
    mainFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50 - kNavigationBarHeight, kScreenWidth, 50)];
    mainFooterView.backgroundColor = [UIColor clearColor];
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    bgImg.image = [UIImage imageNamed:@"article_rect"];
    [mainFooterView addSubview:bgImg];
    UIImageView *penImg = [[UIImageView alloc] initWithFrame:CGRectMake(11 + 20 , (50 - 11.5)/2.0, 11.5, 11.5)];
    penImg.image = [UIImage imageNamed:@"article_detail_pen"];
    [mainFooterView addSubview:penImg];
    UITextField *teFild = [[UITextField alloc] initWithFrame:CGRectMake(31 + 11.5 + 11, (50 - 32.5)/2.0, kScreenWidth - 53.5 - 11 - 11, 32.5)];
    teFild.textColor = k75Color;
    teFild.font = Font(K_TEXT_FONT_12);
    teFild.placeholder = @"说点什么......";
    teFild.userInteractionEnabled = NO;
    [mainFooterView addSubview:teFild];
    [self.view addSubview:mainFooterView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentsAction)];
    [mainFooterView addGestureRecognizer:tap];
    mainFooterView.userInteractionEnabled = YES;
}

#pragma mark == 评论按钮事件
- (void)commentsAction{
    TO_WEAK(self, weakSelf);
    
    ArticleCommentView *commentView = [[ArticleCommentView alloc] initArticleCommentViewByViewTitle:nil block:^(NSString *commentContent) {
        [weakSelf sendArticleComment:commentContent parentId:weakSelf.commentId];
    }];
    
    [commentView show];
}


#pragma mark -- tableView属性
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentsArr.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return _model.contentHeight + 98;
    }
    
    ArticleCommentModel *sonModel = commentsArr[indexPath.row-1];
    return sonModel.contentHeight + 98;
//    if (indexPath.row == 0) {
//
//    }
//
//    if (_model.sonList.count < 1) {
//        return 0;
//    }
//    ArticleCommentModel *sonModel = [[ArticleCommentModel alloc] initWithDictionary:_model.sonList[indexPath.row-1] error:nil];
//    return 98 + sonModel.contentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ArticleCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }    
    if (indexPath.row == 0) {
        cell.model = _model;
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        ArticleCommentModel *sonModel = commentsArr[indexPath.row-1];
        sonModel.isHidenTotalView = YES;
        cell.model = sonModel;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

#pragma mark -- 获取文章评论详情
- (void)getCommentDetail {
    NSDictionary *para = @{
                           @"articleCommentId":self.commentId?@(self.commentId):@0,
                           @"offset":@(pageNum*pageSize),
                           @"max":@(pageSize)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kArticleCommentList parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            if (strongSelf->pageNum == 0) {
                 [strongSelf->commentsArr removeAllObjects];
            }
            
            NSArray *list = dict[@"list"];
            
            if (list.count >= 10) {
                if (!strongSelf.tableView.mj_footer) {
                    strongSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf getCommentDetail];
                    }];
                }
            }else {
                strongSelf.tableView.mj_footer = nil;
            }
            
            for (NSDictionary *tmp in list) {
                ArticleCommentModel *model = [[ArticleCommentModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->commentsArr addObject:model];
            }
            strongSelf.model.isHidenTotalView = YES;
            [strongSelf setMyTitle:[NSString stringWithFormat:@"%ld条回复",strongSelf->commentsArr.count]];
            [strongSelf.tableView reloadData];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        if (strongSelf.tableView.mj_footer) {
            [strongSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        TO_STRONG(weakSelf, strongSelf);
        [weakSelf stopLoadingAnimation];
        if (strongSelf.tableView.mj_footer) {
            [strongSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark -- 发送文章评论
- (void)sendArticleComment:(NSString *)commentContent parentId:(NSInteger)parentId {
    NSMutableDictionary *para = @{
                                  @"content":commentContent,
                                  @"articleId":[NSString stringWithFormat:@"%ld",(long)self.articleId]
                                  }.mutableCopy;
    if (parentId > 0) {
        [para setObject:@(parentId) forKey:@"parentId"];
    }
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kArticleComment parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            strongSelf->pageNum = 0;
            [strongSelf getCommentDetail];
            if (weakSelf.CommentSuccessRefreshUIBlock) {
                weakSelf.CommentSuccessRefreshUIBlock();
            }
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
