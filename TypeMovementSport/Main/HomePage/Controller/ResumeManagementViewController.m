//
//  ResumeManagementViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/26.
//  Copyright © 2018年 XDH. All rights reserved.
//
static NSString *kTitle = @"title";
static NSString *kIsEnableEdit = @"isEnableEdit";
static NSString *kType = @"type";
static NSString *kContent = @"content";
static NSString *kTitles = @"titles";
static NSString *kElements = @"element";
static NSString *kIsMultiple = @"isMultiple";

#import "ResumeManagementViewController.h"
#import "PositionDetailViewController.h"
#import "ResumeDetailViewController.h"
#import "PublishPositionViewController.h"
#import "EaseUI.h"

//view
#import "ApplyJobListCell.h"
#import "RecruitmentListCell.h"
#import "MJRefresh.h"
#import <HyphenateLite/HyphenateLite.h>

//
#import "EMChatView.h"
#import "ResumeManagementView.h"
#import "PositionManagementView.h"
#import "ResumeBasicInfoViewController.h"

//model

@interface ResumeManagementViewController () {
    UIScrollView *mainScrollView;
    UIView *topView;
    UIImageView *faceImg;//头像|公司logo
    UILabel *labName;//title
    UILabel *labContentDesp;//content描述
    UIView *lane;//线
    UIView *btnView;//按钮view
    NSArray *btnTitlesArr;
}


@end

@implementation ResumeManagementViewController

# pragma mark -- 更新简历 | 发布职位
- (void)updateReusmeOrPublishRecruitment {
    if (self.isEnterpriseManagement) {
        //发布职位
        PublishPositionViewController *publishPosition = [[PublishPositionViewController alloc] init];
        TO_WEAK(self, weakSelf);
        publishPosition.RightBarItemBlock = ^(NSDictionary *dict){
            //发布职位，更新UI
            TO_STRONG(weakSelf, strongSelf);
            if (strongSelf->mainScrollView.subviews.count > 2 && [strongSelf->mainScrollView.subviews[2] isKindOfClass:[PositionManagementView class]]) {
                PositionManagementView *publishView = (PositionManagementView *)strongSelf->mainScrollView.subviews[2];
                [publishView reloadData];
            }
        };
        [self.navigationController pushViewController:publishPosition animated:YES];
        return;
    }
    ResumeDetailViewController *resumeDetail = [[ResumeDetailViewController alloc] init];
    resumeDetail.resumeEnum = EditPersonalResume;
    resumeDetail.resumeId = self.resumeModel.id;
    TO_WEAK(self, weakSelf);
    resumeDetail.UpdateResumeBlock = ^(ResumeModel *model) {
        TO_STRONG(weakSelf, strongSelf);
        strongSelf.resumeModel = model;
        //更新信息
        [strongSelf updateTopInfo:model];
    };
    [self.navigationController pushViewController:resumeDetail animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setMyTitle:self.isEnterpriseManagement?@"企业管理":@"简历管理"];
    
    [self setNavItemWithTitle:self.isEnterpriseManagement?@"发布职位":@"修改简历"
                       isLeft:NO
                       target:self
                       action:@selector(updateReusmeOrPublishRecruitment)];
    
    [self createNewUI];
}

- (void)createNewUI {
    topView = [self createHeaderView];
    [self.view addSubview:topView];
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topView.bottom, kScreenWidth, kScreenHeight - topView.height - kNavigationBarHeight)];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.scrollEnabled = NO;
    
    if (@available(iOS 11.0,*)) {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:mainScrollView];
    
//    EaseConversationListViewController *messageView = [[EaseConversationListViewController alloc] init];
//    messageView.view.frame = CGRectMake(0, 0, mainScrollView.width, mainScrollView.height);
    
    EMChatView *messageView = [[EMChatView alloc] initWithFrame:CGRectMake(0, 0, mainScrollView.width, mainScrollView.height)];
    [mainScrollView addSubview:messageView];
    
    if (self.isEnterpriseManagement) {
        mainScrollView.contentSize = CGSizeMake(kScreenWidth*4, mainScrollView.height);
        //企业管理
        //收到的简历，发布的职位，收藏的简历
        NSInteger companyId = [[NSString stringWithFormat:@"%@",_companyInfoDic[@"id"]?_companyInfoDic[@"id"]:@"0"] integerValue];
        NSDictionary *para = @{
                               @"companyId":@(companyId)
                               };
        ResumeManagementView *receiveResumeView = [[ResumeManagementView alloc] initResumeManagementView:ReceiveResume frame:CGRectMake(messageView.right, messageView.top, messageView.width, messageView.height) requestPara:para];
        [mainScrollView addSubview:receiveResumeView];
        
        //发布的职位
        PositionManagementView *publishView = [[PositionManagementView alloc] initPositionManagementView:CompanyPublishPosition frame:CGRectMake(receiveResumeView.right, receiveResumeView.top, receiveResumeView.width, receiveResumeView.height) requestPara:para];
        
        [mainScrollView addSubview:publishView];
        
        //收藏的简历
        ResumeManagementView *collectionResumeView = [[ResumeManagementView alloc] initResumeManagementView:CollectionResume frame:CGRectMake(publishView.right, publishView.top, publishView.width, publishView.height) requestPara:nil];
        [mainScrollView addSubview:collectionResumeView];
        
    }else{
        
        mainScrollView.contentSize = CGSizeMake(kScreenWidth*3, mainScrollView.height);
        //简历管理
        //投递的职位，收藏的职位
        NSDictionary *para = @{
                               @"userId":@(_resumeModel.userId?_resumeModel.userId:0)
                               };
      
        PositionManagementView *sendView = [[PositionManagementView alloc] initPositionManagementView:UserSendToCompanyPosition frame:CGRectMake(messageView.right, messageView.top, messageView.width, messageView.height) requestPara:para];
        
        [mainScrollView addSubview:sendView];
        
        //收藏的职位
        PositionManagementView *collectionView = [[PositionManagementView alloc] initPositionManagementView:UserSendToCompanyPosition frame:CGRectMake(sendView.right, sendView.top, sendView.width, sendView.height) requestPara:nil];
        
        [mainScrollView addSubview:collectionView];
    }
}

- (UIView *)createHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    faceImg = [[UIImageView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(15), 10, 40, 40)];
    faceImg.layer.masksToBounds = YES;
    faceImg.layer.cornerRadius = 20;
    [headerView addSubview:faceImg];
    
    //名称
   labName = [LabelTool createLableWithTextColor:k46Color font:BoldFont(K_TEXT_FONT_14)];
    labName.frame = CGRectMake(faceImg.right + 15, 14, headerView.width - faceImg.right - 15-faceImg.left*2, 15);
    
    [headerView addSubview:labName];
    //公司
    labContentDesp = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
    labContentDesp.frame = CGRectMake(labName.left, labName.bottom + 10, labName.width, 12);
    labContentDesp.numberOfLines = 0;
    [headerView addSubview:labContentDesp];
    
    if (self.isEnterpriseManagement) {
        faceImg.userInteractionEnabled = YES;
        labName.userInteractionEnabled = YES;
        labContentDesp.userInteractionEnabled = YES;
        
        labName.text = _companyInfoDic[@"companyName"];
        labContentDesp.text = _companyInfoDic[@"companyIntroduction"];
        [faceImg sd_setImageWithURL:[NSURL URLWithString:_companyInfoDic[@"companLogo"]] placeholderImage:[UIImage imageNamed:holdImage]];
        UIImageView *moreIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general_rightArrow"]];
        moreIcon.left = headerView.width - faceImg.left - 17;
        moreIcon.size = CGSizeMake(11, 17);
        moreIcon.centerY = faceImg.centerY;
        moreIcon.userInteractionEnabled = YES;
        [headerView addSubview:moreIcon];
        
        UITapGestureRecognizer *tap_edit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editCompanyInfo)];
        UITapGestureRecognizer *tap_edit2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editCompanyInfo)];
        UITapGestureRecognizer *tap_edit3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editCompanyInfo)];
        UITapGestureRecognizer *tap_edit4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editCompanyInfo)];
        [labName addGestureRecognizer:tap_edit];
        [labContentDesp addGestureRecognizer:tap_edit2];
        [faceImg addGestureRecognizer:tap_edit3];
        [moreIcon addGestureRecognizer:tap_edit4];
    }else {
        labName.text = _resumeModel.name;
        labContentDesp.text = _resumeModel.introduction;
        [faceImg sd_setImageWithURL:[NSURL URLWithString:_resumeModel.headImg] placeholderImage:[UIImage imageNamed:holdFace]];
    }
    
    
    CGSize size = [UITool sizeOfStr:labContentDesp.text?labContentDesp.text:@""
                                 andFont:Font(K_TEXT_FONT_12)
                              andMaxSize:CGSizeMake(labContentDesp.width, MAXFLOAT)
                        andLineBreakMode:NSLineBreakByCharWrapping];
    if (size.height > 12) {
        labContentDesp.height = size.height;
    }
    
    lane = [[UIView alloc] initWithFrame:CGRectMake(faceImg.left, labContentDesp.bottom + 5, kScreenWidth-faceImg.left*2, 0.5)];
    lane.backgroundColor = k75Color;
    [headerView addSubview:lane];
    
    btnView = [[UIView alloc] initWithFrame:CGRectMake(0, lane.bottom+5, headerView.width, 40)];
    btnView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:btnView];
    btnTitlesArr = @[@"我的消息",@"投递的职位",@"收藏的职位"];
    if (self.isEnterpriseManagement) {
        btnTitlesArr = @[@"我的消息",@"收到的简历",@"发布的职位",@"收藏的简历"];
    }
    for (int i = 0; i < btnTitlesArr.count; i++) {
        UIButton *btn = [ButtonTool createButtonWithTitle:btnTitlesArr[i]
                                               titleColor:k46Color
                                                titleFont:Font(K_TEXT_FONT_12)
                                                addTarget:self action:@selector(chooseViewType:)];
        btn.tag = 100 + i;
        
        btn.frame = CGRectMake(kScreenWidth/btnTitlesArr.count*i, 0, kScreenWidth/btnTitlesArr.count-1, 40);
        
        [btnView addSubview:btn];
        
        [btn setTitleColor:kOrangeColor forState:UIControlStateSelected];
        [btn setTitleColor:k46Color forState:UIControlStateNormal];
        if (i == 0) {
            btn.selected = YES;
        }else {
            btn.selected = NO;
        }
        if (i < btnTitlesArr.count - 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.right, btn.top+14, 1, 12)];
            line.backgroundColor = k46Color;
            [btnView addSubview:line];
        }
        
    }

    btnView.backgroundColor = [UIColor whiteColor];
    btnView.layer.shadowColor = k210Color.CGColor;
    btnView.layer.shadowOffset = CGSizeMake(0, 5);//偏移距离
    btnView.layer.shadowOpacity = 0.43;//不透明度
    btnView.layer.shadowRadius = 5.0;//半径
    
    if (btnView.bottom > 120) {
        headerView.height = btnView.bottom+5;
    }
    return headerView;
}

#pragma mark -- 更新头部信息
- (void)updateTopInfo:(id)updateValue {
    
    NSString *labNameContent = @"";
    NSString *iconUrl = @"";
    NSString *labContentDespStr = @"";
    if ([updateValue isKindOfClass:[NSDictionary class]]) {
        //公司信息
        iconUrl = _companyInfoDic[@"companLogo"];
        labNameContent = _companyInfoDic[@"companyName"];
        labContentDespStr = _companyInfoDic[@"companyIntroduction"];
        
    }else if ([updateValue isKindOfClass:[ResumeModel class]]) {
        //简历信息
        iconUrl = _resumeModel.headImg;
        labNameContent = _resumeModel.name;
        labContentDespStr = _resumeModel.introduction;
    }
    
    TO_WEAK(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        TO_STRONG(weakSelf, strongSelf);
        [strongSelf->faceImg sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:holdImage]];
        strongSelf->labName.text = labNameContent;
        strongSelf->labContentDesp.text = labContentDespStr;
        
        CGSize size = [UITool sizeOfStr:strongSelf->labContentDesp.text?strongSelf->labContentDesp.text:@""
                                andFont:Font(K_TEXT_FONT_12)
                             andMaxSize:CGSizeMake(strongSelf->labContentDesp.width, MAXFLOAT)
                       andLineBreakMode:NSLineBreakByCharWrapping];
        if (size.height > 12) {
            strongSelf->labContentDesp.height = size.height;
        }
        
        strongSelf->lane.top = strongSelf->labContentDesp.bottom + 5;
        
        strongSelf->btnView.top = strongSelf->lane.bottom + 5;
        
        if (strongSelf->btnView.bottom > 120) {
            strongSelf->topView.height = strongSelf->btnView.bottom+5;
        }else {
            strongSelf->topView.height = 120;
        }
        strongSelf->mainScrollView.top = strongSelf->topView.bottom;
        strongSelf->mainScrollView.height = kScreenHeight - strongSelf->topView.height - kNavigationBarHeight;
        for (UIView *view in strongSelf->mainScrollView.subviews) {
            view.height = strongSelf->mainScrollView.height;
            if ([view isKindOfClass:[ResumeManagementView class]]) {
                ResumeManagementView *resume = (ResumeManagementView *)view;
                [resume setTableHeight:view.height];
            }else if ([view isKindOfClass:[PositionManagementView class]]) {
                PositionManagementView *position = (PositionManagementView *)view;
                [position setTableHeight:view.height];
            }
            
        }
    });
}
# pragma mark -- 我的消息 | 投递的职位 | 收藏的职位
- (void)chooseViewType:(UIButton *)btn {
    
//    TO_WEAK(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
//        TO_STRONG(weakSelf, strongSelf);
        for (int i = 0; i < self->btnTitlesArr.count; i++) {
            UIButton *tmpBtn = (UIButton *)[btn.superview viewWithTag:100+i];
            tmpBtn.selected = NO;
        }
        btn.selected = YES;
    });
    
    [mainScrollView setContentOffset:CGPointMake(kScreenWidth*(btn.tag-100), 0) animated:YES];
}

#pragma mark -- 编辑公司信息
- (void)editCompanyInfo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PopDataConfig" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *titles = @[  @{
                              kTitle:@"姓名",
                              kIsEnableEdit:@"1",
                              kContent:_companyInfoDic[@"name"]?_companyInfoDic[@"name"]:@""
                              },@{
                              kTitle:@"手机号",
                              kIsEnableEdit:@"1",
                               kContent:_companyInfoDic[@"phone"]?_companyInfoDic[@"phone"]:@""
                              },@{
                              kTitle:@"验证码",
                              kIsEnableEdit:@"1",
                              kContent:@""
                              },@{
                              kTitle:@"我的职务",
                              kIsEnableEdit:@"1",
                               kContent:_companyInfoDic[@"position"]?_companyInfoDic[@"position"]:@""
                              },@{
                              kTitle:@"公司名称",
                              kIsEnableEdit:@"1",
                               kContent:_companyInfoDic[@"companyName"]?_companyInfoDic[@"companyName"]:@""
                              },@{
                              kTitle:@"公司简介",
                              kIsEnableEdit:@"1",
                               kContent:_companyInfoDic[@"companyIntroduction"]?_companyInfoDic[@"companyIntroduction"]:@""
                              },@{
                              kTitle:@"公司规模",
                              kIsEnableEdit:@"0",
                              kElements:dic[kCompanyScale],
                               kContent:_companyInfoDic[@"companyScale"]?_companyInfoDic[@"companyScale"]:@""
                              },@{
                              kTitle:@"公司福利",
                              kIsEnableEdit:@"0",
                              kElements:dic[kWelfare],
                               kContent:_companyInfoDic[@"companyWelfare"]?_companyInfoDic[@"companyWelfare"]:@"",
                              kIsMultiple:@"1"//多选
                              }];
    [self editBasicInfo:titles showInfoEnum:EditEnterpriseCertificationInfo navTitle:nil];
}

- (void)editBasicInfo:(NSArray *)titles showInfoEnum:(ShowInfoEnum)showInfoEnum navTitle:(NSString *)navTitle {
    ResumeBasicInfoViewController *basicInfo = [[ResumeBasicInfoViewController alloc] init];
    basicInfo.showInfoEnum = showInfoEnum;
    
    TO_WEAK(self, weakSelf);
    basicInfo.RightBarItemBlock = ^(NSDictionary *dict) {
       //更新信息
        TO_STRONG(weakSelf, strongSelf);
        
        strongSelf->_companyInfoDic = dict;
        [strongSelf updateTopInfo:dict];
    };
    NSMutableArray *conArr = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        NSDictionary *dic = titles[i];
        [mDic setObject:dic[kTitle] forKey:kTitle];
        [mDic setObject:dic[kIsEnableEdit] forKey:kIsEnableEdit];
        [mDic setObject:dic[kContent] forKey:kContent];
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
    if (_companyInfoDic[@"id"]) {
        basicInfo.itemId = [_companyInfoDic[@"id"] integerValue];
    }
    
    if (_companyInfoDic[@"companLogo"]) {
        basicInfo.companyLogo = _companyInfoDic[@"companLogo"];
    }
    if (_companyInfoDic[@"companyLicense"]) {
        basicInfo.companyLicense = _companyInfoDic[@"companyLicense"];
    }
    
    if (_companyInfoDic[@"headImg"]) {
        basicInfo.imgUrl = _companyInfoDic[@"headImg"];
    }
    [self.navigationController pushViewController:basicInfo animated:YES];
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
