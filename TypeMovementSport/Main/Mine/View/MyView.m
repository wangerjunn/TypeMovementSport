//
//  MyView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/6.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "MyView.h"
#import "ParamFile.h"
#import "ShareView.h"

#import "UIColor+Hex.h"
#import "SettingViewController.h"//设置
#import "PerfectInfoViewController.h"//完善信息
#import "MySignViewController.h"//我的签到
#import "MyTrainViewController.h"//我的培训
#import "ReviewQuestionViewController.h"//试题回顾
#import "OnlineLeaveViewController.h"//线上留言
#import "ArticleCollectListViewController.h"//文章收藏
#import "DiscountCouponViewController.h"//优惠券
#import "BaseNavigationViewController.h"
#import "ElectronicCardViewController.h"//电子名片
#import "ElectronicCardSuccessViewController.h"//电子名片获取成功
#import "QrCodeViewController.h"//二维码扫码

//model
#import "UserModel.h"

@interface MyView () {
    NSArray *titlesArr;
    
    UserModel *userModel;
    
    
    UILabel *userNameLabel;//昵称
    UILabel *signLabel;//签名
    UILabel *numLabel;//积分
    UIImageView *sexImg;//性别
    UIImageView *img_head;//头像
    UILabel *tipsLabel;//积分title
}

@end

@implementation MyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginSuccess)
                                                     name:kLoginSuccessNotification object:nil];
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    //渐变背景色
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, FIT_SCREEN_HEIGHT(200))];
    
    [BgView.layer addSublayer:[UIColor setPayGradualChangingColor:BgView fromColor:@"FF6B00" toColor:@"F98617"]];
    
    [self addSubview:BgView];
    
    UILabel *navTitleLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17]];
        navTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 状态栏(statusbar)
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    navTitleLabel.frame = CGRectMake(60, StatusRect.size.height, kScreenWidth-60*2, kNavigationBarHeight - StatusRect.size.height);
    navTitleLabel.text = @"我的";
    [BgView addSubview:navTitleLabel];
    
    CGFloat wdtBtn = 45;
    UIButton *settingBtn = [ButtonTool createButtonWithImageName:@"mine_setting" addTarget:self action:@selector(setting)];
    settingBtn.frame = CGRectMake(kScreenWidth-wdtBtn-15, navTitleLabel.top+(navTitleLabel.height-wdtBtn)/2.0, wdtBtn, wdtBtn);
    [BgView addSubview:settingBtn];
    
    CGFloat coorX_rect = FIT_SCREEN_WIDTH(28);
    
    //个人信息view
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(coorX_rect, FIT_SCREEN_HEIGHT(80), kScreenWidth-coorX_rect*2, 50)];
    UITapGestureRecognizer *tap_info = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editUserInfo)];
    [infoView addGestureRecognizer:tap_info];
    [BgView addSubview:infoView];
    
    img_head = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , infoView.height, infoView.height)];
    img_head.image = [UIImage imageNamed:holdFace];
    img_head.layer.cornerRadius = img_head.height/2.0;
    img_head.layer.masksToBounds = YES;
    [infoView addSubview:img_head];
    
    //性别
    sexImg = [[UIImageView alloc]initWithFrame:CGRectMake(img_head.left + img_head.width - 9, img_head.top + img_head.height - 9, 9, 9)];
    [infoView addSubview:sexImg];
    
    sexImg.layer.cornerRadius = 4.5;
    
    //更多图标
    UIImageView *moreImg = [[UIImageView alloc]initWithFrame:CGRectMake(infoView.width -  23, img_head.top + FIT_SCREEN_HEIGHT(15), 23, 23)];
    moreImg.image = [UIImage imageNamed:@"mine_back"];
    [infoView addSubview:moreImg];
    
    userNameLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(18)];
    userNameLabel.frame = CGRectMake(img_head.right + FIT_SCREEN_WIDTH(19),  img_head.top+FIT_SCREEN_HEIGHT(10) , moreImg.left - img_head.right, 18);
    userNameLabel.text = @"我是昵称";
    [infoView addSubview:userNameLabel];
    
    //签名
    signLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(10)];
    signLabel.frame = CGRectMake(userNameLabel.left, userNameLabel.top + 18 + 5, userNameLabel.width, 10);
    signLabel.text = @"这家伙很懒, 什么都没留下...";
    [infoView addSubview:signLabel];
    
    
    //型动汇积分View
    
    CGFloat hgt_rect = FIT_SCREEN_HEIGHT(77);
    UIImageView *rectBgImg = [[UIImageView alloc]initWithFrame:CGRectMake(coorX_rect , BgView.height - hgt_rect/2.0, kScreenWidth-coorX_rect*2, hgt_rect)];
    rectBgImg.userInteractionEnabled = YES;
    rectBgImg.image = [UIImage imageNamed:@"mine_rect"];
    [self addSubview:rectBgImg];
    
    //积分
    numLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(34)];
    numLabel.text = @"0";
    
    CGSize size = [UITool sizeOfStr:numLabel.text andFont:Font(34) andMaxSize:CGSizeMake(kScreenWidth, kScreenHeight) andLineBreakMode:NSLineBreakByCharWrapping];
    
    // label的内容的宽度
    numLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(35), (rectBgImg.height - 34)/2.0, size.width+5, 34);
    [rectBgImg addSubview:numLabel];
    
    //提示
    tipsLabel = [LabelTool createLableWithTextColor:k46Color font:Font(9)];
    tipsLabel.text = @"型动汇\n积分";
    tipsLabel.numberOfLines = 0;
    tipsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    tipsLabel.frame = CGRectMake(numLabel.right+2, numLabel.top+2 , 50, numLabel.height);
    [rectBgImg addSubview:tipsLabel];
    
    //去签到
    CGFloat sign_wdt = 75;
    CGFloat sign_hgt = 50;
    UIButton *signBtn = [ButtonTool createButtonWithImageName:@"mine_sign" addTarget:self action:@selector(toSign)];
    signBtn.frame = CGRectMake(rectBgImg.width -25 - sign_wdt, (rectBgImg.height - sign_hgt)/2.0+5 , sign_wdt, sign_hgt);
    [rectBgImg addSubview:signBtn];
    
    
    
    //底部按钮
    UIImageView *rect_btm_view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_btmRect"]];
    rect_btm_view.userInteractionEnabled = YES;
    rect_btm_view.frame = CGRectMake(rectBgImg.left,
                                     rectBgImg.bottom + FIT_SCREEN_HEIGHT(15),
                                     rectBgImg.width,
                                     FIT_SCREEN_HEIGHT(230));
    [self addSubview:rect_btm_view];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Mine" ofType:@"plist"];
     titlesArr = [NSArray arrayWithContentsOfFile:path];
    
    CGFloat wdtItem = rect_btm_view.width/3.0;
    CGFloat coorY = 25;
    CGFloat hgtItem = FIT_SCREEN_WIDTH(35) + 30;
    
    for (int i = 0; i < titlesArr.count; i++) {
        
        if ( i >= 3  && i % 3 == 0) {
            coorY += hgtItem + 10;
        }
        
        UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake( wdtItem*(i%3), coorY, wdtItem, hgtItem)];
        itemView.userInteractionEnabled = YES;
        itemView.tag = 100+i;
        [rect_btm_view addSubview:itemView];
        
        NSDictionary *itemDic = titlesArr[i];
        
        UIImageView *itemImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",itemDic[@"icon"]]]];
        itemImg.frame = CGRectMake((itemView.width - FIT_SCREEN_WIDTH(35))/2.0, 0 , FIT_SCREEN_WIDTH(35), FIT_SCREEN_WIDTH(35));
        [itemView addSubview:itemImg];
        
        UILabel *titleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [itemView addSubview:titleLabel];
        
        titleLabel.frame =CGRectMake(0, itemImg.bottom + 10, itemView.width, 12);
        titleLabel.text = itemDic[@"title"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView:)];
        
        [itemView addGestureRecognizer:tap];
        
    }
    
    rect_btm_view.height = coorY + hgtItem + 25;
    
    [self startLoadingAnimation];
     [self getUserInfo];
}

#pragma mark -- 电子名片
- (void)electricCard {
    [MobClick event:@"我的页面，电子名片"];
    NSData *data = UserDefaultsGet(kUserModel);
    
    UserModel *tmpUserModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (tmpUserModel.myCardUrl) {
        ElectronicCardSuccessViewController *cardInfo = [[ElectronicCardSuccessViewController alloc] init];
        cardInfo.hidesBottomBarWhenPushed = YES;
        cardInfo.templateId = tmpUserModel.templateId;
        cardInfo.generalTemplateImgUrl = tmpUserModel.myCardUrl;
        [self.viewController.navigationController pushViewController:cardInfo animated:YES];
    }else {
         [self getMyCard:tmpUserModel];
    }
   
}

#pragma mark -- 设置
- (void)setting {
    SettingViewController *setting = [[SettingViewController alloc]init];
    setting.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:setting animated:YES];
}

#pragma mark -- 完善个人信息
- (void)editUserInfo {
    [MobClick event:@"我的页面， 个人资料"];
    PerfectInfoViewController *info = [[PerfectInfoViewController alloc]init];
    info.hidesBottomBarWhenPushed = YES;
    info.userModel = userModel;
    TO_WEAK(self, weakSelf);
    info.updateInfoBlock = ^{
        [weakSelf getUserInfo];
    };
    [self.viewController.navigationController pushViewController:info animated:YES];
}

# pragma mark -- 去签到
- (void)toSign {
    [MobClick event:@"我的页面，我的签到"];
    MySignViewController *sign = [[MySignViewController alloc]init];
    
    TO_WEAK(self, weakSelf);
    sign.signDoneBlock = ^{
        [weakSelf getUserInfo];
    };
    
    sign.integralCount = userModel.integralCount;
    sign.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:sign animated:YES];
}

- (void)clickView:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag - 100;
    NSDictionary *itemDic = titlesArr[tag];
    SEL sel  = NSSelectorFromString(itemDic[@"action"]);
    if (sel && [self respondsToSelector:sel]) {
        [self performSelector:sel withObject:nil afterDelay:0];
    }
}

#pragma mark -- 我的培训
- (void)myTrain {
    [MobClick event:@"我的页面，我的培训"];
    MyTrainViewController *train = [[MyTrainViewController alloc]init];
    train.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:train animated:YES];
}

#pragma mark -- 试题回顾
- (void)reviewQuestion {
    [MobClick event:@"我的页面，试题回顾"];
    ReviewQuestionViewController *review = [[ReviewQuestionViewController alloc]init];
    review.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:review animated:YES];
}

#pragma mark -- 线上留言
- (void)leaveMessageOnline {
    [MobClick event:@"我的页面，线上留言"];
    OnlineLeaveViewController *onlineLeave = [[OnlineLeaveViewController alloc]init];
    onlineLeave.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:onlineLeave animated:YES];
}

#pragma mark -- 文章收藏
- (void)articleCollection {
    [MobClick event:@"我的页面， 文章收藏"];
    ArticleCollectListViewController *articleCollect = [[ArticleCollectListViewController alloc]init];
    articleCollect.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:articleCollect animated:YES];
}

#pragma mark -- 分享到好友
- (void)shareToFriends {
    [MobClick event:@"我的页面， 分享好友"];
    ShareView *shareView = [[ShareView alloc] initShareViewBySharePlaform:@[@0,@1,@2] viewTitle:nil shareTitle:@"型动汇" shareDesp:kShareDefaultText shareLogo:kShareDefaultLogo shareUrl:kShareDefaultRespondUrl];
    
    [shareView show];
}

#pragma mark -- 支持我们
- (void)supportUs {
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",@"1300415626"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark -- 我的优惠券
- (void)myCoupon {
    [MobClick event:@"我的页面， 优惠券"];
    DiscountCouponViewController *coupon = [[DiscountCouponViewController alloc] init];
    coupon.hidesBottomBarWhenPushed = YES;
     [self.viewController.navigationController pushViewController:coupon animated:YES];
}

#pragma mark -- 扫码领券
- (void)scanQrGetCoupon {
    QrCodeViewController *qr = [[QrCodeViewController alloc] init];
    qr.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:qr animated:YES];
}

#pragma mark -- 获取用户信息
- (void)getUserInfo {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserGet parms:nil viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            
            strongSelf->userModel = [[UserModel alloc] initWithDictionary:dict[@"detail"] error:nil];
            
            if ([strongSelf->userModel.sex  isEqualToString:@"男"]) {
                strongSelf->sexImg.image = [UIImage imageNamed:@"general_male"];
            }else{
                strongSelf->sexImg.image = [UIImage imageNamed:@"general_female"];
            }
            
            strongSelf->userNameLabel.text = strongSelf->userModel.nickName;
            strongSelf->signLabel.text = strongSelf->userModel.remark;
            [strongSelf->img_head sd_setImageWithURL:[NSURL URLWithString:strongSelf->userModel.headImg] placeholderImage:[UIImage imageNamed:holdFace]];
            strongSelf->numLabel.text = strongSelf->userModel.integralCount;
            
            [strongSelf->numLabel sizeToFit];
            
            strongSelf->tipsLabel.left = strongSelf->numLabel.right + 2;
            
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
        [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
        [weakSelf stopLoadingAnimation];
    }];
}

#pragma mark -- 获取我的电子名片
- (void)getMyCard:(UserModel *)tmpUserModel {
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kMyCardFind parms:nil viewControll:self.viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        
        if ([remindMsg integerValue] == 999) {
            
            NSDictionary *detailDic = dict[@"detail"];
            
            NSString *myCardUrl = detailDic[@"myCardUrl"];
            NSNumber *templateId = detailDic[@"backgroundTemplate"][@"id"];
            if (![Tools isBlankString:myCardUrl]) {
                
                tmpUserModel.myCardUrl = myCardUrl;
                tmpUserModel.templateId = templateId;
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tmpUserModel];
                
                UserDefaultsSet(data, kUserModel);
                
                ElectronicCardSuccessViewController *cardInfo = [[ElectronicCardSuccessViewController alloc] init];
                cardInfo.hidesBottomBarWhenPushed = YES;
                cardInfo.templateId = templateId;
                cardInfo.generalTemplateImgUrl = myCardUrl;
                [self.viewController.navigationController pushViewController:cardInfo animated:YES];
            }else {
                //已选定模板，未创建属性
                ElectronicCardViewController *cardInfo = [[ElectronicCardViewController alloc] init];
                cardInfo.hidesBottomBarWhenPushed = YES;
                cardInfo.templateId = templateId;
                [self.viewController.navigationController pushViewController:cardInfo animated:YES];
//                [weakSelf infoItemTemplateFindAll];
            }
            
        }else if ([remindMsg integerValue] == 440) {
            //未生成名片，请求模板数据
//            [weakSelf getTemplateData];
            ElectronicCardViewController *cardInfo = [[ElectronicCardViewController alloc] init];
            cardInfo.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:cardInfo animated:YES];
        }
        else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
            [weakSelf stopLoadingAnimation];
        }
        
        
    } failed:^(NSError *error) {
        [weakSelf stopLoadingAnimation];
    }];
}

#pragma mark -- 登陆成功
- (void)loginSuccess {
    [self getUserInfo];
}

@end
