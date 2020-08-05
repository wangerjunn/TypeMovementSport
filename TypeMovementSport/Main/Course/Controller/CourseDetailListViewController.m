//
//  CourseDetailListViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/10/9.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "CourseDetailListViewController.h"
#import "OrderPayViewController.h"
#import "PlayerVideoViewController.h"
#import "AppDelegate.h"

//view
#import "Course_theoryPlayCell.h"
#import "Course_theoryHeaderView.h"
#import "PurchaseListView.h"
#import "CustomAlertView.h"
#import "ShareView.h"

@interface CourseDetailListViewController () <
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *mainTableView;
}

@end

@implementation CourseDetailListViewController

# pragma mark -- 分享到平台
- (void)shareToPlatform {
    ShareView  *share = [[ShareView alloc]initShareViewBySharePlaform:@[@0,@1,@2] viewTitle:@"" shareTitle:@"分享标题" shareDesp:@"分享内容" shareLogo:@"" shareUrl:@"htttps://www.baidu.com"];
    
    [share show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:self.navTitle];
    
    if (self.isShowNavBtn) {
        [self setNavItemWithImage:@"HP_train_share"
                  imageHightLight:@"HP_train_share"
                           isLeft:NO
                           target:self
                           action:@selector(shareToPlatform)];
    }
    
    [self createUI];
}

- (void)createUI {
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    if (@available(iOS 11.0,*)) {
        mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainTableView.estimatedRowHeight = 0;
        mainTableView.estimatedSectionHeaderHeight = 0;
        mainTableView.estimatedSectionFooterHeight = 0;
    }
    mainTableView.rowHeight = 40;
    mainTableView.sectionHeaderHeight = 52;
    mainTableView.sectionFooterHeight = 0.001;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    mainTableView.tableHeaderView = [self createTableViewHeader];
    [mainTableView registerClass:Course_theoryHeaderView.class forHeaderFooterViewReuseIdentifier:@"header"];
    [self.view addSubview:mainTableView];
    
    //    __weak typeof(self) weakSelf = self;
    //    mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //    }];
    
    UIImageView *purchaseIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 100,
                                                                  kScreenHeight - 100 - kNavigationBarHeight,
                                                                  90, 90)];
    
    purchaseIcon.image = [UIImage imageNamed:@"general_purchase"];
    purchaseIcon.userInteractionEnabled = YES;
    [self.view addSubview:purchaseIcon];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPurchase)];
    [purchaseIcon addGestureRecognizer:tap];
}

- (UIView *)createTableViewHeader {
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2.5)];
    
    tableViewHeader.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:tableViewHeader.frame];
    [bgImg setContentMode:UIViewContentModeScaleAspectFill];
    bgImg.clipsToBounds = YES;
    [bgImg sd_setImageWithURL:[NSURL URLWithString:kTestHoldImgUrl] placeholderImage:[UIImage imageNamed:holdImage]];
    [tableViewHeader addSubview:bgImg];
    
    UIView *views  = [[UIView alloc] initWithFrame:tableViewHeader.frame];
    views.backgroundColor = [UIColor blackColor];
    views.alpha = 0.5;
    [tableViewHeader addSubview:views];
    
    UILabel * titLab = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:BoldFont(21)];
    titLab.frame = CGRectMake(74, 35, kScreenWidth - 74-73, 29);
    [tableViewHeader addSubview:titLab];
    titLab.text = self.navTitle;
    titLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *subTitleLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(K_TEXT_FONT_10)];
    subTitleLabel.frame = CGRectMake(titLab.left, 64, titLab.width, 18);
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.text = @"11项";
    [tableViewHeader addSubview:subTitleLabel];
    
    return tableViewHeader;
}

#pragma mark - UITableViewDelegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Course_theoryHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!headerView) {
        headerView = [[Course_theoryHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    }
    
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.themeLabel.text = [NSString stringWithFormat:@"人体运动的结构与功能基础%ld",(long)section];
    headerView.purchaseStatusLabel.text = @"未购买";
    [headerView showMoreIcon];
    headerView.clickFolderBlock = ^{
        
    };
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Course_theoryPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (!cell) {
        cell = [[Course_theoryPlayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
    }
    
    cell.titleLabel.text = @"第一节";
    
    cell.tryWatchLabel.text = [NSString stringWithFormat:@"分享试看%ld分钟",indexPath.row+1];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != 0) {
        
        NSMutableDictionary *dic = @{
                              @"share_describe":@"分享好友",
                              @"share_pic":kShareDefaultLogo,
                              @"share_title":kShareDefaultText,
                              @"share_url":kShareDefaultRespondUrl
                              }.mutableCopy;
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        appDelegate.isRotation = YES;
        PlayerVideoViewController *play = [[PlayerVideoViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        play.liveUrl = @"http://v.xingdongsport.com/68705d42120b4e01b5685107c4f69978/4e7a977787014050a90051955dbce37d-5456d705cfd07e668f702e78be66cb6f.mp4";
        play.fromWhere = @"No";
        play.shareInfoDic = dic;
        play.videoId = @"20";
        play.time_limit_flag = 0;
        play.VideoType = @"star";
        play.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:play animated:YES completion:nil];
        return;
    }
}


#pragma mark -- 点击购买
- (void)clickPurchase {
    
//    TO_WEAK(self, weakSelf);
//    PurchaseListView *purchase = [[PurchaseListView alloc] initPurchaseViewByTitle:@"这是显示的标题" dataArr:nil purchaseBlock:^{
//        OrderPayViewController *orderPay = [[OrderPayViewController alloc]init];
//        orderPay.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:orderPay animated:YES];
//    }];
//    [purchase show];
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
