//
//  ArticleDetailViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/15.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleCommentDetailViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"

//model
#import "ArticleListModel.h"
#import "ArticleCommentModel.h"

//view
#import <WebKit/WebKit.h>
#import "ShareView.h"
#import "ArticleCommentView.h"
#import "ArticleCommentCell.h"
#import "WebViewController.h"
#import "MJRefresh.h"

@interface ArticleDetailViewController ()<
    UITextFieldDelegate,
//    WKNavigationDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIWebViewDelegate> {
        
        UIView *allCommentsView;
        UIView *placeHolderView;
        UIWebView *_webView;
//        WKWebView *_webView;
        UIView *_collectionView;
        UIView *_commentView;
        NSInteger pageNum;
        NSInteger pageSize;
        NSMutableArray *commentsArr;
        
        UIView *mainHeaderView;
        UITableView *mainTable;
        CGSize size0;//Cell 中评论内容的高度
}

@property (nonatomic, strong) ArticleListModel *model;

@end

@implementation ArticleDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setMyTitle:_navTitle?_navTitle:@"体育圈头条"];
    pageNum = 0;
    pageSize = 10;
    
    commentsArr = [NSMutableArray array];
    
    [self createView];
}

- (void)createView {
    UIView *footerView = [self createBtnView];
    
    [self.view addSubview:footerView];
    
    [self tableHeader];
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,footerView.top) style:UITableViewStylePlain];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.tableHeaderView = mainHeaderView;
    [self.view addSubview:mainTable];
    
    [self startLoadingAnimation];
    
    [self getArticleDetail:[Tools isLoginAccount]];
    [self getArticleCommentList];
}

#pragma mark --创建头视图
- (void)tableHeader{
    mainHeaderView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
////    //以下代码适配大小
//    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//    [wkUController addUserScript:wkUScript];
//
//    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//    wkWebConfig.userContentController = wkUController;
   
//    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, mainHeaderView.width, mainTable.height) configuration:wkWebConfig];
//    _webView.navigationDelegate = self;
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, mainHeaderView.width, 100)];
//    NSMutableURLRequest *request;
   _webView.delegate = self;
//    _webView.scalesPageToFit = YES;
    
//    NSString *url = [NSString stringWithFormat:@"%@%zi",kWebArticle,self.articleId];
//    request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]
//                                          cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
//    request.HTTPShouldHandleCookies = YES;
//
//    [_webView loadRequest:request];
//    [_webView loadHTMLString:_model.content baseURL:nil];
    _webView.backgroundColor = [UIColor whiteColor];
    mainHeaderView.backgroundColor = [UIColor whiteColor];
    [mainHeaderView addSubview:_webView];
    
    allCommentsView =  [[UIView alloc] initWithFrame:CGRectMake(0, _webView.bottom + 10, kScreenWidth, FIT_SCREEN_HEIGHT(50))];
    [mainHeaderView addSubview:allCommentsView];
    
    UILabel * allCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 24)];
    allCommentLabel.textColor = [UIColor colorWithHexString:@"464646"];
    allCommentLabel.font = BoldFont(22);
    allCommentLabel.text = @"全部评论";
    [allCommentsView addSubview:allCommentLabel];
    
    UIView *laneView = [[UIView alloc] initWithFrame:CGRectMake(10, FIT_SCREEN_HEIGHT(50) - 1, kScreenWidth - 20, 0.5)];
    laneView.backgroundColor = LaneCOLOR;
    [allCommentsView addSubview:laneView];
    
    //占位view
    placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, allCommentsView.bottom, kScreenWidth, FIT_SCREEN_HEIGHT(150))];
    [mainHeaderView addSubview:placeHolderView];
    UILabel *showLab =[LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_12)];
    showLab.frame = CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(150));
    showLab.textAlignment = NSTextAlignmentCenter;
    showLab.text = @"快去说点什么吧！";
    [placeHolderView addSubview:showLab];
    
}


- (UIView *)createBtnView {
    
    CGFloat hgtView = 45;
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-hgtView-kNavigationBarHeight, kScreenWidth, hgtView)];
    btnView.backgroundColor = [UIColor whiteColor];
    CGFloat coorX = FIT_SCREEN_WIDTH(15);
    CGFloat hgt = 25;
    UILabel *field = [[UILabel alloc] initWithFrame:CGRectMake(coorX, btnView.height/2.0 - hgt/2.0,
                                                                       kScreenWidth/2.0 - coorX, hgt)];
    field.text = @"   写评论";
    field.textColor = k210Color;
    field.font = Font(K_TEXT_FONT_14);
    field.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    [field setCornerRadius:hgt/2.0];
    
    field.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_comment = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(displayCommentView)];
    [field addGestureRecognizer:tap_comment];
    [btnView addSubview:field];
    
    CGFloat distance = (kScreenWidth/2.0 -coorX*2 - btnView.height*3)/2.0;
    
    CGFloat coorX_btn  = field.right + coorX;
    NSArray *titles = @[@"评论",@"收藏",@"分享"];
    NSArray *icons = @[@"article_detail_comment",@"article_detail_un_collect",@"article_detail_share"];
    for (int i = 0; i < titles.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(coorX_btn, 0, btnView.height, btnView.height)];
        view.tag = 100+i;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((view.width - hgt)/2.0, view.height/2.0-hgt/2.0, hgt, hgt)];
        icon.image = [UIImage imageNamed:icons[i]];
        icon.tag = 1;
        [view addSubview:icon];
        
        coorX_btn += view.width + distance;
        
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBottomBtnAction:)];
        [view addGestureRecognizer:tap];
        switch (i) {
            case 1:
                _collectionView = view;
                break;
            case 0:
                _commentView = view;
                break;
                
            default:
                break;
        }
        [btnView addSubview:view];
    }
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 4)];
    img.image = [UIImage imageNamed:@"Taber阴影"];
    [btnView addSubview:img];
    return btnView;
}

#pragma mark -- tableView属性
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ArticleCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    ArticleCommentModel *model = commentsArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCommentModel *model = commentsArr[indexPath.row];
    return 130 + model.contentHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleCommentModel *model = commentsArr[indexPath.row];
    ArticleCommentDetailViewController *commentDetail = [[ArticleCommentDetailViewController alloc] init];
    commentDetail.commentId = model.id;
    commentDetail.model = model;
    commentDetail.articleId = self.articleId;
    
    TO_WEAK(self, weakSelf);
    commentDetail.CommentSuccessRefreshUIBlock = ^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->pageNum = 0;
        [weakSelf getArticleCommentList];
    };
    [self.navigationController pushViewController:commentDetail animated:YES];
}


# pragma mark -- 加载错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self stopLoadingAnimation];
}

# pragma mark -- 加载完成时
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
////    __block CGFloat htmlWidth = 0;
   __block  CGFloat htmlHeight = 0;

    TO_WEAK(self, weakSelf);
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable resp, NSError * _Nullable error) {
        if (!error) {
            htmlHeight = [resp floatValue];

            [weakSelf updateWebViewByHeight:htmlHeight];
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //HTML5的高度
    NSString *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    
    
    [self updateWebViewByHeight:[htmlHeight floatValue]];
    
}


- (void)updateWebViewByHeight:(CGFloat)htmlHeight {
    
     _webView.height = htmlHeight;
    
    if (commentsArr.count > 0) {
        mainHeaderView.height =htmlHeight + allCommentsView.height + 10;
        placeHolderView.hidden = YES;
    }else {
        placeHolderView.hidden = NO;
        mainHeaderView.height =htmlHeight + placeHolderView.height + 10 + allCommentsView.height;
    }
   
    allCommentsView.top =_webView.bottom;
    placeHolderView.top =allCommentsView.bottom;
    mainTable.tableHeaderView = mainHeaderView;
    
    UIScrollView *tempView = (UIScrollView *)[_webView.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    
    [mainTable reloadData];
    
    [self stopLoadingAnimation];
}
#pragma mark --  评论 ,收藏，分享
- (void)clickBottomBtnAction:(UITapGestureRecognizer *)tap {
    
    if (tap.view.tag != 102) {
        if (![Tools isLoginAccount]) {
            [self displayLoginView];
            return;
        }
    }
    switch (tap.view.tag) {
        case 100:{
            //评论,滑动到全部评论
            if (commentsArr.count > 0) {
                 [mainTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }else {
                [mainTable setContentOffset:CGPointMake(0, _webView.size.height) animated:YES];
            }
           
//            [self displayCommentView];
            }
            break;
        case 101:{
            //收藏
            [self articleCollectionToggle];
        }
            break;
        case 102:{
            //分享
            
            NSString *url = [NSString stringWithFormat:@"%@%zi",kWebArticle,self.articleId];
            ShareView *share = [[ShareView alloc]initShareViewBySharePlaform:@[@0,@1,@2] viewTitle:@"" shareTitle:_model.name shareDesp:kShareDefaultText shareLogo:kShareDefaultLogo shareUrl:url];
            
            [share show];
        }
            break;
            
        default:
            break;
    }
}

- (void)displayCommentView {
    
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    TO_WEAK(self, weakSelf);
    ArticleCommentView *commentView = [[ArticleCommentView alloc] initArticleCommentViewByViewTitle:nil block:^(NSString *commentContent) {
        [weakSelf sendArticleComment:commentContent parentId:0];
    }];
    
    [commentView show];
}

#pragma mark -- 去登录
- (void)displayLoginView {
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- 获取文章详情
- (void)getArticleDetail:(BOOL)isLogin {
    NSString *url = kPublicArticleGet;
    if (isLogin) {
        url = kApiArticleGet;
    }
    
    TO_WEAK(self, weakSelf);
    
    [WebRequest PostWithUrlString:url parms:@{@"id":@(self.articleId)} viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            strongSelf.model = [[ArticleListModel alloc]initWithDictionary:dict[@"detail"] error:nil];
            
//            NSMutableURLRequest *request;
            
//            request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:strongSelf.model.shareUrl?strongSelf.model.shareUrl:@"https://www.baidu.com"]
//                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
//            request.HTTPShouldHandleCookies = YES;
//            [strongSelf->_webView loadRequest:request];
            [strongSelf->_webView loadHTMLString:strongSelf.model.content baseURL:nil];
            
            if (strongSelf.model.isCollection) {
                UIImageView *icon = (UIImageView *)[strongSelf->_collectionView viewWithTag:1];
//                UILabel *conLabel = (UILabel *)[strongSelf->_collectionView viewWithTag:2];
                
                icon.image = [UIImage imageNamed:@"article_detailCollected"];
//                conLabel.text = @"已收藏";
            }
            
            //评论内容
//            UILabel *commentLabel = (UILabel *)[strongSelf->_commentView viewWithTag:2];
//            commentLabel.text = [NSString stringWithFormat:@"评论%ld",strongSelf.model.commentCount];
        }else{
             [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
//         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
         [weakSelf stopLoadingAnimation];
    }];
}

#pragma mark -- 关注 | 取消关注
- (void)articleCollectionToggle {
    
    TO_WEAK(self, weakSelf);
    
    [WebRequest PostWithUrlString:kArticleCollectionToggle parms:@{@"articleId":@(self.articleId)} viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            UIImageView *icon = (UIImageView *)[strongSelf->_collectionView viewWithTag:1];
//            UILabel *conLabel = (UILabel *)[strongSelf->_collectionView viewWithTag:2];
            strongSelf.model.isCollection = !strongSelf.model.isCollection;
            if (strongSelf.model.isCollection) {
                icon.image = [UIImage imageNamed:@"article_detail_collect"];
//                conLabel.text = @"已收藏";
            }else{
                icon.image = [UIImage imageNamed:@"article_detail_un_collect"];
//                conLabel.text = @"收藏";
            }
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
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
            [strongSelf getArticleCommentList];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 获取文章评论列表
- (void)getArticleCommentList {
    NSDictionary *para = @{
                           @"articleId":self.articleId?@(_articleId):@0,
                           @"offset":@(pageNum*pageSize),
                           @"max":@(pageSize)
                           };
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kArticleCommentList parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            
            if (strongSelf->pageNum == 0) {
                [strongSelf->commentsArr removeAllObjects];
            }
            
            if (list.count >= 10) {
                if (!strongSelf->mainTable.mj_footer) {
                    strongSelf->mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf getArticleCommentList];
                    }];
                }
            }else {
                strongSelf->mainTable.mj_footer = nil;
            }
            
            for (NSDictionary *tmp in list) {
                ArticleCommentModel *model = [[ArticleCommentModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->commentsArr addObject:model];
            }
            
//            if (commentsArr.count > 0) {
//                mainHeaderView.height =htmlHeight + allCommentsView.height + 10;
//                placeHolderView.hidden = YES;
//            }else {
//                placeHolderView.hidden = NO;
//                mainHeaderView.height =htmlHeight + placeHolderView.height + 10 + allCommentsView.height;
//            }
            if (strongSelf->commentsArr.count > 0) {
                strongSelf->placeHolderView.hidden = YES;
                strongSelf->mainHeaderView.height = strongSelf->_webView.height + strongSelf->allCommentsView.height + 10;
            }else {
                strongSelf->placeHolderView.hidden = NO;
                strongSelf->mainHeaderView.height = strongSelf->_webView.height + strongSelf->allCommentsView.height + 10 + strongSelf->placeHolderView.height;
            }
            
            [strongSelf->mainTable reloadData];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        if (strongSelf->mainTable.mj_footer) {
            [strongSelf->mainTable.mj_footer endRefreshing];
        }
//         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        
        TO_STRONG(weakSelf, strongSelf);
        NSLog(@"%@", error);
        if (strongSelf->mainTable.mj_footer) {
            [strongSelf->mainTable.mj_footer endRefreshing];
        }
//        [weakSelf stopLoadingAnimation];
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
