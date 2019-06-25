//
//  Course_increaseVideoSubView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/12.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "Course_increaseVideoSubView.h"
#import "SimulatedExerciseCell.h"
#import "EmptyView.h"
#import "IncreaseVideoPayOrFreeView.h"
#import "MJRefresh.h"

//vc
#import "CourseListViewController.h"
#import "BaseNavigationViewController.h"
#import "ActOpeListViewController.h"

//model
#import "QuestionModel.h"

@interface Course_increaseVideoSubView () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    UITableView *increaseTable;//增值视频table
    NSInteger _videoTypeId;
    NSMutableArray *_dataArr;
    NSString *_searchText;
    UITapGestureRecognizer *tap;
}

@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation Course_increaseVideoSubView

- (instancetype)initWithFrame:(CGRect)frame videoTypeId:(NSInteger)videoTypeId{
    if (self = [super initWithFrame:frame]) {
        _videoTypeId = videoTypeId;
        _dataArr = [NSMutableArray array];
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    increaseTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    increaseTable.delegate = self;
    increaseTable.dataSource = self;
    increaseTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        increaseTable.estimatedRowHeight = 0;
        increaseTable.estimatedSectionHeaderHeight = 0;
        increaseTable.estimatedSectionFooterHeight = 0;
        increaseTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    increaseTable.rowHeight = FIT_SCREEN_HEIGHT(105);
//    increaseTable.tableHeaderView = [self createTableViewHeader];
    [self addSubview:increaseTable];
    
    TO_WEAK(self, weakSelf);
    increaseTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getVideoDataList];
    }];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenKeyboard)];
    
    [self startLoadingAnimation];
    [self getVideoDataList];
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initEmptyViewByFrame:increaseTable.bounds placeholderImage:nil placeholderText:nil];
        [increaseTable addSubview:_emptyView];
    }
    return _emptyView;
}

- (void)hidenKeyboard {
    [self endEditing:YES];
}

- (UIView *)createTableViewHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(170))];
    
    CGFloat coorX = FIT_SCREEN_WIDTH(20);
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(coorX, FIT_SCREEN_HEIGHT(20), headerView.width-coorX*2, FIT_SCREEN_HEIGHT(30))];
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView setCornerRadius:15];
    
    
    UIButton *btn = [ButtonTool createButtonWithTitle:nil titleColor:k75Color titleFont:Font(14) addTarget:self action:@selector(showMenuView)];
    btn.frame = CGRectMake(16, 0,80, searchView.height);
    [searchView addSubview:btn];
    
    UILabel *label = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
    label.text = @"全部品类";
    [label sizeToFit];
    
    label.frame = CGRectMake(btn.width/2.0-label.width/2.0, 0, label.width, btn.height);
    label.tag = 1000;
    [btn addSubview:label];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(label.right+5, btn.height/2.0-4, 8, 8)];
    icon.tag = 1001;
    icon.image = [UIImage imageNamed:@"general_pulldown"];
    [btn addSubview:icon];
    
    [headerView addSubview:searchView];
    
    //搜索view
    CGFloat hgt_Searchbar = FIT_SCREEN_HEIGHT(20);
    CGFloat wdt_searchBar = FIT_SCREEN_WIDTH(200);
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:
              CGRectMake(searchView.width-wdt_searchBar-10,
                         (searchView.height-hgt_Searchbar)/2.0,
                         wdt_searchBar,
                         hgt_Searchbar)];
    
    searchBar.backgroundColor = UIColorFromRGB(0xf7f7f7);
    searchBar.placeholder = @"请输入关键字";
    searchBar.text = _searchText;
    [searchBar setCornerRadius:searchBar.height/2.0];
    [searchView addSubview:searchBar];
    //    [search setImage:[UIImage imageNamed:@"搜索"]
    //    forSearchBarIcon:UISearchBarIconSearch
    //               state:UIControlStateNormal];
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    
    searchBar.barTintColor = [UIColor orangeColor];
    searchBar.delegate = self;
    UIView *view = searchBar.subviews[0];
    
    UITextField *searchField = [view.subviews lastObject];
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            
            searchField = (UITextField*)v;
            searchField.font = Font(K_TEXT_FONT_12);
            searchField.textColor = k75Color;
//            v.layer.borderWidth = 0.5;
//            v.layer.borderColor = kOrangeColor.CGColor;
//            [v setCornerRadius:5];
//            v.layer.cornerRadius = searchBar.height/2.0;
//            v.layer.masksToBounds = YES;
            v.backgroundColor = UIColorFromRGB(0xf7f7f7);
        } else {
            //移除背景view
            [v removeFromSuperview];
            
        }
        
    }
    
    CGFloat typeViewWdt = FIT_SCREEN_WIDTH(160);
    CGFloat typeViewHgt = FIT_SCREEN_HEIGHT(105);
    
    UIImageView *payVideoView = [[UIImageView alloc] init];
    payVideoView.frame = CGRectMake(searchView.left,searchView.bottom + FIT_SCREEN_HEIGHT(14),typeViewWdt,typeViewHgt);
    payVideoView.tag = 100;
    [payVideoView setCornerRadius:15];
    payVideoView.backgroundColor = kOrangeColor;
    payVideoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_payView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoView:)];
    [payVideoView addGestureRecognizer:tap_payView];
    [headerView addSubview:payVideoView];
    
    UIImageView *freeVideoView = [[UIImageView alloc] init];
    freeVideoView.frame = CGRectMake(searchView.right-typeViewWdt,payVideoView.top,payVideoView.width,payVideoView.height);
    [freeVideoView setCornerRadius:15];
    freeVideoView.tag = 101;
    freeVideoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_freeView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoView:)];
    [freeVideoView addGestureRecognizer:tap_freeView];
    freeVideoView.backgroundColor = kOrangeColor;
    [headerView addSubview:freeVideoView];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
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
    
    SimulatedExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (!cell) {
        cell = [[SimulatedExerciseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    QuestionModel *model = _dataArr[indexPath.section];
    cell.model = model;
    
//    NSString *browseCount = [NSString stringWithFormat:@"%ld",(long)model.browseCount];
//
//    [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"class_icon.jpg"]];
//    cell.titleLabel.text = model.name;
//    cell.priceLabel.text = [NSString stringWithFormat:@"%@ 人已浏览",browseCount];
//    cell.priceLabel.textColor = k75Color;
//    cell.priceLabel.font = Font(K_TEXT_FONT_12);
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:cell.priceLabel.text];
//    [attr addAttribute:NSForegroundColorAttributeName value:k46Color range:NSMakeRange(0, browseCount.length)];
//    cell.priceLabel.attributedText = attr;
//
//    NSString *shareCount = [NSString stringWithFormat:@"%ld",(long)model.shareCount];
//    cell.buyNumberLabel.text = [NSString stringWithFormat:@"%@ 人已分享",shareCount];
//    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:cell.buyNumberLabel.text];
//    [attr2 addAttribute:NSForegroundColorAttributeName value:k46Color range:NSMakeRange(0, shareCount.length)];
//    cell.buyNumberLabel.attributedText = attr2;
//    cell.levelLabel.text = [NSString stringWithFormat:@"%@",model.count];
    
//    if (model.isShowPrice) {
//        if (model.price != 0) {
//            cell.priceLabel.textColor = kOrangeColor;
//            cell.priceLabel.font = Font(20);
//            cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price/100];
//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:cell.priceLabel.text];
//
//            [attr addAttribute:NSFontAttributeName value:Font(10) range:NSMakeRange(0, 1)];
//            cell.priceLabel.attributedText = attr;
//            cell.buyNumberLabel.text = [NSString stringWithFormat:@"%ld人已购买",(long)model.payCount];
//        }
//    }
    
    //即将上线
//    cell.maskView.hidden = model.isOnline;
//    cell.buyNumberLabel.hidden = !model.isOnline;
//    cell.priceLabel.hidden = !model.isOnline;
//    cell.levelLabel.hidden = !model.isOnline;
//    cell.attachView.hidden = !model.isOnline;
//
//    if (model.isOnline) {
//        cell.attachView.hidden = YES;
//        if ([model.pdf isNotEmpty] && model.expireTime > 0) {
//            cell.attachView.hidden = NO;
//        }
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionModel *model = _dataArr[indexPath.section];
    if (!model.isOnline) {
        return;
    }
    
//    if ([model.videoList isNotEmpty]) {
        //不为空
        CourseListViewController *courseList = [[CourseListViewController alloc] init];
        courseList.hidesBottomBarWhenPushed = YES;
        courseList.videoTypeId = model.id;
        courseList.viewTitle = model.name;
        courseList.totalPrice = model.price/100;
        courseList.EnglishTitle = @"Value Added";
        courseList.videoEnum = Course_increaseVideo;
        [courseList setModel:model];
        TO_WEAK(self, weakSelf);
        courseList.PaySuccessCallbackBlock = ^{
            [weakSelf getVideoDataList];
        };
        [self.viewController.navigationController pushViewController:courseList animated:YES];
//    }else {
//        ActOpeListViewController *actOpeList = [[ActOpeListViewController alloc] init];
//        actOpeList.hidesBottomBarWhenPushed = YES;
//        actOpeList.videoTypeId = model.id;
//        actOpeList.viewTitle = model.name;
//        actOpeList.videoEnum = Course_actOpeVideo;
//        [self.viewController.navigationController pushViewController:actOpeList animated:YES];
//    }
        
}

#pragma mark -- 全部品类
- (void)showMenuView {
}

#pragma mark -- 付费视频 | 免费视频
- (void)showVideoView:(UITapGestureRecognizer *)tap {
    
    [self endEditing:YES];
    BOOL isFree = NO;
    if (tap.view.tag == 101) {
        isFree = YES;
    }
    IncreaseVideoPayOrFreeView *videoView = [[IncreaseVideoPayOrFreeView alloc] initViewByFrame:self.bounds dataArr:@[] isFreeTypeVideo:isFree];
    [videoView showInView:self];
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _searchText = searchBar.text;
    [self hidenKeyboard];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [increaseTable addGestureRecognizer:tap];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [increaseTable removeGestureRecognizer:tap];
}


#pragma mark -- 获取分页数据
- (void)getVideoDataList {
    
    NSDictionary *para = @{
                           @"id":@(_videoTypeId?_videoTypeId:0)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kApiClassFindAllByParent parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            
            [strongSelf->_dataArr removeAllObjects];
            for (NSDictionary *tmp in list) {
                @autoreleasepool {
                    QuestionModel *model = [[QuestionModel alloc] initWithDictionary:tmp error:nil];
                    [strongSelf->_dataArr addObject:model];
                }
            }
            
            [strongSelf->increaseTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
        
         [weakSelf stopLoadingAnimation];
        
        [strongSelf->increaseTable.mj_header endRefreshing];
    } failed:^(NSError *error) {
        
        TO_STRONG(weakSelf, strongSelf);
        weakSelf.emptyView.hidden = !(strongSelf->_dataArr.count < 1);
         [weakSelf stopLoadingAnimation];
        [strongSelf->increaseTable.mj_header endRefreshing];
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
