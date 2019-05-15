//
//  HomeViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/24.
//  Copyright © 2018年 XDH. All rights reserved.
//

#define kIS_SHOW_COUPON_VIEW @"kIS_SHOW_COUPON_VIEW"
static NSString *kTitle = @"title";
static NSString *kIsEnableEdit = @"isEnableEdit";
static NSString *kType = @"type";
static NSString *kContent = @"content";
static NSString *kTitles = @"titles";
static NSString *kElements = @"element";
static NSString *kIsMultiple = @"isMultiple";

#import "HomeViewController.h"
#import "ApplyJobViewController.h"//我要求职
#import "CerOrRecordQueryViewController.h"//证书|成绩查询
#import "ElectronicCardViewController.h"//电子名片
#import "IncreaseTrainViewController.h"//增值培训
#import "RecruitmentViewController.h"//我要招聘
#import "TabbarViewController.h"
#import "CourseViewController.h"//课程
#import "BaseNavigationViewController.h"
#import "AnswerListViewController.h"//考试
#import "PlayerVideoViewController.h"//播放
#import "ArticleDetailViewController.h"//文章详情
#import "MessageViewController.h"//消息
#import "LoginViewController.h"
#import "ResumeBasicInfoViewController.h"
#import "TestViewController.h"

//view
#import "HP_btnCollectionViewCell.h"
#import "HP_videoCollectionViewCell.h"
#import "HP_videoTableHeaderView.h"
#import "HP_videoTableViewCell.h"
#import "ArticleListCell.h"//文章
#import "AppDelegate.h"
#import "WebViewController.h"
#import "HW3DBannerView.h"
#import "HP_couponView.h"


//model
#import "ArticleListModel.h"
#import "QuestionModel.h"
#import "UserModel.h"

@interface HomeViewController () <
    UIAlertViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource> {
        UITableView *homeTable;
//        NSMutableArray *increaseVideoArray;//增值视频数组
//        NSMutableArray *actOpeVideoArray;//国职实操
        NSMutableArray *examArray;//考试数组
        NSMutableArray *articleArray;//文章数组
        NSArray *middleBtnArray;//按钮数组
        NSArray *bannerArray;//banner条数组
}

@property (nonatomic, strong) NSMutableArray *dynamiacArr;//动态数据展示
@property (nonatomic, strong) NSArray *couponDataArr;//优惠券数据

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavBarColor:[UIColor whiteColor]];
   
    if ([Tools isLoginAccount]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        NSString *recordLocalDay = [userDefault objectForKey:kIS_SHOW_COUPON_VIEW];
        
        NSDate *todayDate = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        NSString *getCurrentDay = [df stringFromDate:todayDate];
        if (recordLocalDay == nil || ![recordLocalDay isEqualToString:getCurrentDay]) {
            [userDefault setObject:getCurrentDay forKey:kIS_SHOW_COUPON_VIEW];
            [userDefault synchronize];
            //获取优惠券数据
            [self getCouponData];
            
        }
    }
    
}


#pragma mark -- 消息
- (void)dispalyMessage {
    
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    
    MessageViewController *message = [[MessageViewController alloc] init];
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}

#pragma mark -- 显示优惠券view
- (void)showCouponView {
    
    HP_couponView *couponView = [[HP_couponView alloc] initCouponViewByData:self.couponDataArr];
    [couponView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@""];
    
    UIImageView * iconImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.navigationItem.titleView.width - 38)/2.0, 0, 38, 27)];
    iconImg.image = [UIImage imageNamed:@"hp_icon"];
    [self.navigationItem.titleView addSubview:iconImg];

    [self setNavItemWithImage:@"hp_message"
                       imageHightLight:@"hp_message"
                                           isLeft:NO
                                          target:self
                                         action:@selector(dispalyMessage)];
    
    [self hiddenBackBtn ];
    
    self.dynamiacArr = [NSMutableArray array];
    examArray = [NSMutableArray array];
    articleArray = [NSMutableArray array];
    
    [self createUI];
    
}

- (void)createUI {
    
     [self startLoadingAnimation];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HP_btnConfig" ofType:@"plist"];
    middleBtnArray = [NSArray arrayWithContentsOfFile:path];
    homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    homeTable.delegate = self;
    homeTable.dataSource = self;
    homeTable.showsVerticalScrollIndicator = NO;
    homeTable.showsHorizontalScrollIndicator = NO;
    homeTable.tableFooterView = [self createFooterView];
    
    if (@available(iOS 11.0,*)) {
        homeTable.estimatedRowHeight = 0;
        homeTable.estimatedSectionHeaderHeight = 0;
        homeTable.estimatedSectionFooterHeight = 0;
        homeTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    [self.view addSubview:homeTable];
    
    //客服
    CGFloat wdtBtn = 75;
    
    UIImageView *bgCircleView = [[UIImageView alloc] initWithFrame:
                                 CGRectMake(kScreenWidth - wdtBtn,
                                            kScreenHeight - kNavigationBarHeight - kTabBarHeight - wdtBtn - 20,
                                            wdtBtn, wdtBtn)];
    
    bgCircleView.image = [UIImage imageNamed:@"general_purchase"];
    bgCircleView.userInteractionEnabled = YES;
    [self.view addSubview:bgCircleView];
    
    //客服按钮
    CGFloat serviceBtnWidth = 55;
    UIButton *serviceBtn = [[UIButton alloc] initWithFrame:
                            CGRectMake(bgCircleView.width/2.0 - serviceBtnWidth/2.0,
                                       bgCircleView.height/2.0-serviceBtnWidth/2.0,
                                       serviceBtnWidth, serviceBtnWidth)];
    [serviceBtn setImage:[UIImage imageNamed:@"HP_serviceTele"]
                forState:UIControlStateNormal];
    [serviceBtn addTarget:self
                   action:@selector(callServiceTell)
         forControlEvents:UIControlEventTouchUpInside];
    [bgCircleView addSubview:serviceBtn];
    [self.view bringSubviewToFront:bgCircleView];
    [self getHomePageData];
}

- (UIView *)createTableViewHeaderView {
    //Screen_width/2.2
    //FIT_SCREEN_HEIGHT(190)
    UIView *tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2.2)];
    tableViewHeaderView.backgroundColor = RGBACOLOR(243, 245, 247, 1);

    HW3DBannerView *bannerView = [HW3DBannerView initWithFrame:CGRectMake(0, 16, kScreenWidth, tableViewHeaderView.height - 16 - 17) imageSpacing:10 imageWidth:kScreenWidth - 50];
    bannerView.initAlpha = 0.5; // 设置两边卡片的透明度
    bannerView.autoScrollTimeInterval = 3;
    bannerView.imageRadius = 10; // 设置卡片圆角
    bannerView.imageHeightPoor = 10; // 设置中间卡片与两边卡片的高度差
    bannerView.placeHolderImage = [UIImage imageNamed:holdImage];
    
    NSMutableArray *bannerUrlAarry = [NSMutableArray array];
    for (NSDictionary *tmp in bannerArray) {
        if (tmp[@"imgUrl"]) {
            [bannerUrlAarry addObject:tmp[@"imgUrl"]];
        }
        
    }
    bannerView.data = bannerUrlAarry;
    TO_WEAK(self, weaskSelf);
    bannerView.clickImageBlock = ^(NSInteger currentIndex) { // 点击中间图片的回调
        TO_STRONG(weaskSelf, strongSelf);
        /*
         {
             id = 4;
             imgUrl = "http://xdh-banner.oss-cn-hangzhou.aliyuncs.com/ykb.jpg";
             isJump = 0;
             url = "http://test.xingdongsport.com/web/train/1";
         }
         */
        if ([(strongSelf->bannerArray[currentIndex][@"isJump"]) integerValue] == 1) {
            WebViewController *web = [[WebViewController alloc]init];
            NSString *url = strongSelf->bannerArray[currentIndex][@"url"];
            NSLog(@"%ld",(long)currentIndex);
            web.httpUrl = url;
            web.hidesBottomBarWhenPushed = YES;
            [weaskSelf.navigationController pushViewController:web animated:YES];
        }
        
    };
    [tableViewHeaderView addSubview:bannerView];
    
    return tableViewHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= 1) {
        return FIT_SCREEN_HEIGHT(64);
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 45;
    }
    return 0.001;
}

- (UIView *)createFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *endLab = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_10)];
    
    endLab.text = @"- End -";
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.frame = CGRectMake(0, 0, footerView.width, 30);
    
    [footerView addSubview:endLab];
    
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section >= 1) {
        
        static NSString *headerSectionID = @"headerSectionID";
        HP_videoTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
        if (headerView == nil) {
            headerView = [[HP_videoTableHeaderView alloc] initWithReuseIdentifier:headerSectionID];
        }
        [headerView.gradientView.layer addSublayer:[UIColor setPayGradualChangingColor:headerView.gradientView fromColor:@"FF6B00" toColor:@"F98617"]];

        headerView.userInteractionEnabled = YES;
        headerView.tag = section+1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(jumpToSceneView:)];
        
        [headerView addGestureRecognizer:tap];
        
        headerView.frame = CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(50));
        headerView.fireIcon.hidden = YES;
        
        if (section == 1) {
            headerView.titleLabel.text = [NSString stringWithFormat:@"国职认证模拟练习"];
            headerView.fireIcon.hidden = NO;
        }else if (section == (self.dynamiacArr.count + 2)) {
            headerView.titleLabel.text = [NSString stringWithFormat:@"精选文章"];
        }else {
            NSDictionary *dicInfo = self.dynamiacArr[section -2];
            headerView.titleLabel.text = [NSString stringWithFormat:@"%@",dicInfo[@"name"]?dicInfo[@"name"]:@""];
        }
        return headerView;
    }
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8.5)];
        img.image = [UIImage imageNamed:@"general_shadow.png"];
        [footerView addSubview:img];
        
        UILabel *lab = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_16)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.frame = CGRectMake(0, img.bottom+5, footerView.width, 16);
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"免 费 体 验 区"];
        [result addAttribute:NSForegroundColorAttributeName value:kOrangeColor range:NSMakeRange(0, 3)];
        lab.attributedText = result;
        [footerView addSubview:lab];
        
        
        UILabel *lanss = [LabelTool createLableWithTextColor:k75Color font:Font(8)];
        lanss.frame = CGRectMake(0, lab.bottom + 6, kScreenWidth, 8);
        lanss.textAlignment = NSTextAlignmentCenter;
        lanss.text = @"FREE EXPERIENCE";
        [footerView addSubview:lanss];
        
        return footerView;
    }
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + self.dynamiacArr.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.dynamiacArr.count + 2) {
        //文章数据
        return articleArray.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return FIT_SCREEN_HEIGHT(200);
    }
    
    if (indexPath.section == self.dynamiacArr.count + 2) {
        return FIT_SCREEN_HEIGHT(141);
    }
    
    return FIT_SCREEN_HEIGHT(118+23);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //按钮数组
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstBtnCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
        lay.itemSize = CGSizeMake(FIT_SCREEN_WIDTH(66), FIT_SCREEN_HEIGHT(95));
        lay.minimumLineSpacing = 0;
        lay.minimumInteritemSpacing = FIT_SCREEN_WIDTH(52);
        
        UICollectionView *btnCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(200)) collectionViewLayout:lay];
        btnCollectionView.delegate = self;
        btnCollectionView.dataSource = self;
        btnCollectionView.scrollEnabled = NO;
        btnCollectionView.showsVerticalScrollIndicator = NO;
        btnCollectionView.showsHorizontalScrollIndicator = NO;
        btnCollectionView.backgroundColor = [UIColor whiteColor];
        btnCollectionView.contentInset = UIEdgeInsetsMake(0, FIT_SCREEN_WIDTH(36), 0, FIT_SCREEN_WIDTH(36));
        btnCollectionView.tag = 100;
        [btnCollectionView registerClass:[HP_btnCollectionViewCell class] forCellWithReuseIdentifier:@"btnCell"];
        
        [cell.contentView addSubview:btnCollectionView];
        
        return cell;
    }
    
    if (indexPath.section == self.dynamiacArr.count + 2) {
        ArticleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[ArticleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor clearColor];
        }
        
        ArticleListModel *model = articleArray[indexPath.row];
        cell.model = model;
        return cell;
    }
    
    HP_videoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
    if (!cell) {
        cell = [[HP_videoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 1) {
        //模拟练习
        [cell updateData:examArray type:indexPath.section];
    }else {
        if (self.dynamiacArr.count < indexPath.section - 2) {
            return cell;
        }
        NSDictionary *dicInfo = self.dynamiacArr[indexPath.section - 2];
        NSArray *dataArr = dicInfo[@"videoList"];
        [cell updateData:dataArr type:indexPath.section];
    }
    TO_WEAK(self, weakSelf);
    cell.ClickHomeVideoBlock = ^(NSInteger index) {
        TO_STRONG(weakSelf, strongSelf);
        if (indexPath.section == 1) {
            //模拟练习
            QuestionModel *model = strongSelf->examArray[index];
            [weakSelf getTestData:model];
        }else {
            if (weakSelf.dynamiacArr.count < indexPath.section - 2) {
                return;
            }
            NSDictionary *dicInfo = weakSelf.dynamiacArr[indexPath.section - 2];
            NSString *tmpId = [NSString stringWithFormat:@"%@",dicInfo[@"id"]?dicInfo[@"id"]:@""];
            if ([tmpId isEqualToString:@"39"] || [tmpId isEqualToString:@"44"]) {
                NSArray *dataArr = dicInfo[@"videoList"];
                if (dataArr.count > index) {
                     [weakSelf playerView:dataArr[index]];
                }
            }
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dynamiacArr.count + 2) {
        ArticleDetailViewController *articleDetail = [[ArticleDetailViewController alloc] init];
        ArticleListModel *model = articleArray[indexPath.row];
        articleDetail.articleId = model.id;
        articleDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:articleDetail animated:YES];
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return middleBtnArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HP_btnCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"btnCell" forIndexPath:indexPath];
    
    NSDictionary *itemDic = middleBtnArray[indexPath.item];
    cell.icon.image = [UIImage imageNamed:itemDic[@"icon"]];
    cell.titleLabel.text = itemDic[@"title"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    NSDictionary *itemDic = middleBtnArray[indexPath.item];
    NSString *action = itemDic[@"action"];
    SEL sel = NSSelectorFromString(action);
    
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel withObject:nil afterDelay:0];
    }
}

#pragma mark -- 我要求职
- (void)wantToJob {
    
    [MobClick event:@"首页，我要求职"];
    ApplyJobViewController *applyJob = [[ApplyJobViewController alloc]init];
    applyJob.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:applyJob animated:YES];
}

#pragma mark -- 我要招聘
- (void)wantToRecruit {
    
    [MobClick event:@"首页，我要招聘"];
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    
    NSData *data = UserDefaultsGet(kUserModel);
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (userModel.isRegisterEnterprise) {
        RecruitmentViewController *recruitment = [[RecruitmentViewController alloc]init];
        recruitment.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recruitment animated:YES];
    }else {
        [self isExistCompanyInterface:userModel];
    }
    
}


#pragma mark -- 增值视频
- (void)increaseTrain {
    [MobClick event:@"首页，增值视频"];
    IncreaseTrainViewController *increaseTrain = [[IncreaseTrainViewController alloc]init];
    increaseTrain.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:increaseTrain animated:YES];
}

#pragma mark -- 国职认证
- (void)certificateQuery {
    [MobClick event:@"首页，国职认证"];
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    CourseViewController *course = [[CourseViewController alloc] init];
    course.hidesBottomBarWhenPushed = YES;
//    course.isFromHomePageCountryProfession = YES;
    [self.navigationController pushViewController:course animated:YES];
}

#pragma mark -- 证书 | 成绩查询
- (void)gradeQuery {
    [MobClick event:@"首页，证书成绩查询"];
    [self query:NO];
}

#pragma mark -- 证书 | 成绩查询
- (void)query:(BOOL)isCer {
    CerOrRecordQueryViewController *cerOrRecord = [[CerOrRecordQueryViewController alloc]init];
    cerOrRecord.hidesBottomBarWhenPushed = YES;
    cerOrRecord.navTitle = @"国家职业资格教练认证成绩/成绩查询";
    
    [self.navigationController pushViewController:cerOrRecord animated:YES];
}

#pragma mark -- 播放视频view
- (void)playerView:(NSDictionary *)videoInfoDic {
    
    NSString *share_url = [NSString stringWithFormat:@"%@%@",kWebVideo,videoInfoDic[@"id"]];
    
    NSMutableDictionary *dic = @{
                                 @"share_describe":kShareDefaultText,
                                 @"share_pic":kShareDefaultLogo,
                                 @"share_title":videoInfoDic[@"name"]?videoInfoDic[@"name"]:@"",
                                 @"share_url":share_url
                                 }.mutableCopy;
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.isRotation = YES;
    PlayerVideoViewController *play = [[PlayerVideoViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    play.liveUrl = videoInfoDic[@"url"];
    play.fromWhere = @"Home";
    play.shareInfoDic = dic;
    play.videoId = [NSString stringWithFormat:@"%@",videoInfoDic[@"id"]];
    play.time_limit_flag = @"0";
    play.VideoType = @"star";
    if ([Tools isLoginAccount]) {
        NSData *data = UserDefaultsGet(kUserModel);
        UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        play.user_tel =userModel.phone;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:play animated:YES completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark -- 模拟练习 | 国职实操 | 进阶课程 | 精选文章
- (void)jumpToSceneView:(UITapGestureRecognizer *)tap {
    
    TabbarViewController *tabar = (TabbarViewController *)self.tabBarController;
    
    if (tap.view.tag-1 == 1) {
        //模拟练习
        [tabar setSelectedIndex:1];
    }else if (tap.view.tag-1 == self.dynamiacArr.count+2) {
        //精选文章
        [tabar setSelectedIndex:0];
    }else {
        //国职实操
        if (![Tools isLoginAccount]) {
            [self displayLoginView];
            return;
        }
        if (self.dynamiacArr.count < tap.view.tag-1 - 2) {
            return;
        }
        NSDictionary *dicInfo = self.dynamiacArr[tap.view.tag-1 - 2];
        NSString *tmpId = [NSString stringWithFormat:@"%@",dicInfo[@"id"]?dicInfo[@"id"]:@""];
        if ([tmpId isEqualToString:@"39"] || [tmpId isEqualToString:@"44"]) {
            BaseNavigationViewController *baseNav =  (BaseNavigationViewController *)tabar.viewControllers[3];
            if ([baseNav.viewControllers.firstObject isKindOfClass:[CourseViewController class]]) {
                CourseViewController *course = baseNav.viewControllers.firstObject;
                if ([tmpId isEqualToString:@"39"]) {
                    [course selectIndex:1];
                }else {
                    [course selectIndex:2];
                }
                
                [tabar setSelectedIndex:3];
            }
        }
    }
}

#pragma mark --进阶课程
- (void)showIncreaseVideo {
    
    [MobClick event:@"首页，进阶课程"];
    if (![Tools isLoginAccount]) {
        [self displayLoginView];
        return;
    }
    
    CourseViewController *course = [[CourseViewController alloc] init];
    course.hidesBottomBarWhenPushed = YES;
     [course selectIndex:2];
//    course.isFromHomePageIncreaseCourse = YES;
    [self.navigationController pushViewController:course animated:YES];
}

#pragma mark -- 去登录
- (void)displayLoginView {
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- 更新app
- (void)updateApp:(NSString *)updateUrl {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:updateUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
    }
}

#pragma mark -- 拨打客服电话
- (void)callServiceTell {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                [NSString stringWithFormat:@"tel://%@",@"15001338854"]]];
}

#pragma mark -- 获取首页接口数据
- (void)getHomePageData {
    
    TO_WEAK(self, weakSelf);
    NSDictionary *para = @{
                           @"versionNum":kVersion,
                           @"type":kFrom
                           };
    [WebRequest PostWithUrlString:kHomePage parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            
            TO_STRONG(weakSelf, strongSelf);
            //顶部banner条
            strongSelf->bannerArray = dict[@"bannerList"];
            
            if (strongSelf->bannerArray.count > 0) {
                strongSelf->homeTable.tableHeaderView = [weakSelf createTableViewHeaderView];
            }
            NSArray *examList = dict[@"examList"];
            for (NSDictionary *tmp in examList) {
                QuestionModel *model = [[QuestionModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->examArray addObject:model];
            }
            
            /*
             "videoList": [
             [
                 {
                     "id": 1,
                     "url": "http://v.sport-osta.cn/75e175eada4f429c818618ba39f322e4/d9563ed5c6c543f2af0e2ef6fe609818-1a3ecb63ef4bbe4c94a51c65730cf704.mp4",
                     "name": "公共理论  第1章",
                     "isAttempt": true,
                     "attemptSecond": -1,
                     "classes": {
                        "id": 49
                     },
                     "isDelete": false
                 }
             ],
             [],
             []
             ],
             */
            NSArray *videoList = dict[@"videoList"];
            
            for (id tmp in videoList) {
                if ([tmp isKindOfClass:NSDictionary.class]) {
                    [self.dynamiacArr addObject:tmp];
                }
            }
          
            NSArray *articleList = dict[@"articleList"];
            for (NSDictionary *tmp in articleList) {
                ArticleListModel *model = [[ArticleListModel alloc] initWithDictionary:tmp error:nil];
                [strongSelf->articleArray addObject:model];
            }
            
            /*
             {
                 "type": "1",
                 "remark": "",
                 "versionNum": "",
                 "updateUrl": "",
                 "tips": {
                     "type": "1:无更新, 2:非强制更新, 3:强制更新",
                     "remark": "提示信息",
                     "versionNum": "最新的版本号",
                     "updateUrl": "下载地址"
                 }
             }
             */
            //app更新信息
            NSDictionary *detailDict = dict[@"appVersion"];
            NSString *updateUrl = detailDict[@"updateUrl"];
            NSString *remark = detailDict[@"remark"];
            
            [weakSelf checkUpdateInfoByType:[detailDict[@"type"] integerValue]
                                  updateUrl:updateUrl
                                  updateCon:remark];
           
            [strongSelf->homeTable reloadData];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        [weakSelf loadingAnimationTimeOutHandle:^{
            [weakSelf getHomePageData];
        }];
    }];
}

#pragma mark -- 监测更新信息

/**
 监测更新信息

 @param type 3:强制更新，2:非强制更新
 @param updateUrl 更新链接
 @param updateCon 更新内容
 */
- (void)checkUpdateInfoByType:(NSInteger)type
                    updateUrl:(NSString *)updateUrl
                    updateCon:(NSString *)updateCon {
    if (type == 3) {
        //强制更新
        [[CustomAlertView shareCustomAlertView]
                                                  showTitle:nil
                                                  content:updateCon
                                                 buttonTitle:@"更新"
         block:^(NSInteger index) {
             
            [self updateApp:updateUrl];
        }];
    }else if (type == 2)  {
        //非强制更新
        [[CustomAlertView shareCustomAlertView] showTitle:nil
                                                  content:updateCon
                                          leftButtonTitle:nil
                                         rightButtonTitle:@"去更新"
                                                    block:^(NSInteger index) {
            if (index == 1) {
                [self updateApp:updateUrl];
            }
        }];
    }
}

#pragma mark -- 是否注册企业
- (void)isExistCompanyInterface:(UserModel *)userModel {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kCompanyIsExist parms:nil viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        
        if ([remindMsg integerValue] == 999) {
            if ([[dict[@"isExist"] stringValue] isEqualToString:@"1"]) {
                //已注册企业
                userModel.isRegisterEnterprise = YES;
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
                UserDefaultsSet(data, kUserModel);
                RecruitmentViewController *recruitment = [[RecruitmentViewController alloc]init];
                recruitment.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:recruitment animated:YES];
            }else{
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
            }
        }else if ([remindMsg isEqualToString:@"441"]) {
            //未注册企业
            NSString *path = [[NSBundle mainBundle] pathForResource:@"PopDataConfig" ofType:@"plist"];
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
            NSArray *titles = @[  @{
                                      kTitle:@"姓名",
                                      kIsEnableEdit:@"1"
                                      },@{
                                      kTitle:@"手机号",
                                      kIsEnableEdit:@"1"
                                      },@{
                                      kTitle:@"验证码",
                                      kIsEnableEdit:@"1"
                                      },@{
                                      kTitle:@"我的职务",
                                      kIsEnableEdit:@"1"
                                      },@{
                                      kTitle:@"公司名称",
                                      kIsEnableEdit:@"1"
                                      },@{
                                      kTitle:@"公司简介",
                                      kIsEnableEdit:@"1"
                                      },@{
                                      kTitle:@"公司规模",
                                      kIsEnableEdit:@"0",
                                      kElements:dic[kCompanyScale]
                                      },@{
                                      kTitle:@"公司福利",
                                      kIsEnableEdit:@"0",
                                      kElements:dic[kWelfare],
                                      kIsMultiple:@"1"//多选
                                      }];
            [weakSelf editBasicInfo:titles showInfoEnum:EditEnterpriseCertificationInfo navTitle:nil];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)editBasicInfo:(NSArray *)titles showInfoEnum:(ShowInfoEnum)showInfoEnum navTitle:(NSString *)navTitle {
    ResumeBasicInfoViewController *basicInfo = [[ResumeBasicInfoViewController alloc] init];
    basicInfo.hidesBottomBarWhenPushed = YES;
    basicInfo.showInfoEnum = showInfoEnum;
    
    NSMutableArray *conArr = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        NSDictionary *dic = titles[i];
        [mDic setObject:dic[kTitle] forKey:kTitle];
        [mDic setObject:dic[kIsEnableEdit] forKey:kIsEnableEdit];
        [mDic setObject:@"" forKey:kContent];
        if (dic[kElements]) {
            [mDic setObject:dic[kElements] forKey:kElements];
        }
        if (dic[kIsMultiple]) {
            [mDic setObject:dic[kIsMultiple] forKey:kIsMultiple];
        }
        [conArr addObject:mDic];
    }
    
    NSDictionary *tmpDic = @{
                             kTitles:conArr
                             };
    
    basicInfo.conDic = tmpDic;
    basicInfo.navTitle = navTitle;
    [self.navigationController pushViewController:basicInfo animated:YES];
}

#pragma mark -- 获取考试题
- (void)getTestData:(QuestionModel *)model {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kQuestionFindAllByClass parms:@{@"classesId":@(model.id?model.id:0)} viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        //        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSArray *list = dict[@"list"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:list.count];
            for (NSDictionary *tmp in list) {
                @autoreleasepool {
                    ExamModel *model = [[ExamModel alloc] initWithDictionary:tmp error:nil];
                    [arr addObject:model];
                }
            }
            if (list.count < 1) {
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"暂无试题" buttonTitle:nil block:nil];
                return;
            }
            AnswerListViewController *answerList = [[AnswerListViewController alloc]init];
            answerList.testQuestionsEnum = TestQuestionsExam;
            answerList.examDataArr = arr;
            answerList.hidesBottomBarWhenPushed = YES;
            answerList.classesId = model.id;
            answerList.questionModel = model;
            answerList.examLevelName = model.name;
            [weakSelf.navigationController pushViewController:answerList animated:YES];
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 获取当前用户优惠券
- (void)getCouponData {
    
    TO_WEAK(self, weakSelf);
    
    NSString *url = kUserCouponFindAll;
    [WebRequest PostWithUrlString:url parms:nil viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        if ([remindMsg integerValue] == 999) {
            
            NSDictionary *list = dict[@"list"];
            
            //获取订单优惠券
            //可用的优惠券
            weakSelf.couponDataArr = list[@"availableList"];
            
            if (weakSelf.couponDataArr.count > 0) {
                [weakSelf showCouponView];
            }
        }
    } failed:^(NSError *error) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:kIS_SHOW_COUPON_VIEW];
        [userDefaults synchronize];
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
