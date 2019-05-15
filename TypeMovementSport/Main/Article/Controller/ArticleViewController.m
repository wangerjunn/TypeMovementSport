
//
//  ArticleViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/24.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ArticleViewController.h"
#import "WJItemsControlView.h"

//view
#import "ArticleView.h"
#import "BoldNavigationTitleView.h"

//model
#import "ArticleChannelModel.h"

@interface ArticleViewController ()<UIScrollViewDelegate>{
    WJItemsControlView *_itemControlView;
    NSMutableArray *titlesArr;
    NSMutableArray *articlehannelsArr;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *searchKeys;

@end

@implementation ArticleViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavBarColor:[UIColor whiteColor]];
    
    if (titlesArr == nil) {
        titlesArr = [NSMutableArray array];
        [self startLoadingAnimation];
        [self getArticleChannel];
    }
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hiddenBackBtn];
    
}

- (void)configData {

    UIView *topView = [[BoldNavigationTitleView alloc] initBoldNavigationTitleView:@"Article 文章" boldPart:@"Article"];
    
    self.navigationItem.titleView = topView;
    
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    
    _itemControlView = [[WJItemsControlView alloc]initWithFrame:
                        CGRectMake(5, 0, kScreenWidth-10, 44)];
    _itemControlView.backgroundColor = [UIColor whiteColor];
    config.selectedColor = kOrangeColor;
    config.linePercent = 1.2;
    config.itemFont = [UIFont systemFontOfSize:14];
    _itemControlView.tapAnimation = YES;
    _itemControlView.config = config;
    _itemControlView.titleArray = titlesArr;
    
    TO_WEAK(self.mainScrollView, weakScrollView);
    TO_WEAK(self, weakSelf);
    [_itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        TO_STRONG(weakSelf, strongSelf);
        ArticleView *articleView = (ArticleView *)[weakScrollView viewWithTag:1000+index];
        ArticleChannelModel *model = strongSelf->articlehannelsArr[index];
        if (!model.isGetData) {
            [articleView loadData];
            model.isGetData = YES;
        }
        [weakScrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];
    }];
    
    [self.view addSubview:_itemControlView];
    
    [self createUI];
}

- (void)createUI {
    [self.view addSubview:self.mainScrollView];
    
    for (int i = 0; i < titlesArr.count; i++) {
        ArticleChannelModel *model = articlehannelsArr[i];
        ArticleView *articleView = [[ArticleView alloc] initArticleViewWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, _mainScrollView.height) articleChannelId:model.id isFromCollection:NO];
        if (i == 0) {
            model.isGetData = YES;
            [articleView loadData];
        }
        articleView.tag = i+1000;
        [self.mainScrollView addSubview:articleView];
    }
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:
                           CGRectMake(0, _itemControlView.height,
                                      kScreenWidth, kScreenHeight - kNavigationBarHeight -
                                      kTabBarHeight - _itemControlView.height)];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth * titlesArr.count, _mainScrollView.height);
    }
    return _mainScrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = _mainScrollView.contentOffset.x / kScreenWidth;
    [_itemControlView moveToIndex:index];
}

#pragma mark -- 获取文章频道
- (void)getArticleChannel {
        
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kArticleChannel parms:nil viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            TO_STRONG(weakSelf, strongSelf);
            NSArray *arr = dict[@"list"];
            if (!strongSelf->articlehannelsArr) {
                strongSelf->articlehannelsArr = [NSMutableArray array];
            }
            for (NSDictionary *tmp in arr) {
                ArticleChannelModel *model = [[ArticleChannelModel alloc] initWithDictionary:tmp error:nil];
                
                [strongSelf->articlehannelsArr addObject:model];
                if (model.name) {
                    [strongSelf->titlesArr addObject:model.name];
                }
                
            }
            
            [strongSelf configData];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        
        [weakSelf loadingAnimationTimeOutHandle:^{
            [weakSelf getArticleChannel];
        }];
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
