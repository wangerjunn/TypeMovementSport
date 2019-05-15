//
//  PositionDetailViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PositionDetailViewController.h"
#import "CompanyRecruitInfoViewController.h"//公司招聘信息
#import "PublishPositionViewController.h"
#import "ChatRoomViewController.h"

//view
#import "PositionDetailTableHeader.h"
#import "PositionDetailCell.h"
#import "PositionDetailRecruiterCell.h"
#import "PositionDetailCompanyCell.h"

//model
#import "PositionModel.h"
#import "UserModel.h"

@interface PositionDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mainTable;
    PositionModel *positionModel;
    UIView *bottomView;
    UIButton *sendResumeBtn;//投递简历
}

@end

@implementation PositionDetailViewController

#pragma mark -- 职位收藏
- (void)positionCollection {
    NSDictionary *para = @{
                           @"positionId":[NSString stringWithFormat:@"%ld",(long)self.positionId]
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kCollectionPositionToggle parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            
            
            TO_STRONG(weakSelf, strongSelf);
            
            strongSelf->positionModel.isCollection = !strongSelf->positionModel.isCollection;
            if (strongSelf->positionModel.isCollection) {
                //收藏简历成功
                [strongSelf setNavItemWithImage:@"HP_applyJob_collected"
                                imageHightLight:@"HP_applyJob_collected"
                                         isLeft:NO
                                         target:strongSelf
                                         action:@selector(positionCollection)];
            }else {
                //收藏简历失败
                [strongSelf setNavItemWithImage:@"HP_applyJob_collecte"
                                imageHightLight:@"HP_applyJob_collecte"
                                         isLeft:NO
                                         target:strongSelf
                                         action:@selector(positionCollection)];
                
            }
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 更新职位信息
- (void)updatePositionInfo {
    PublishPositionViewController *updateInfo = [[PublishPositionViewController alloc] init];
    
    TO_WEAK(self, weakSelf);
    updateInfo.RightBarItemBlock = ^(NSDictionary *dict){
       //更新完成，刷新UI
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->positionModel = [[PositionModel alloc] initWithDictionary:dict error:nil];
        [strongSelf->mainTable reloadData];
    };
    updateInfo.positionModel = positionModel;
    [self.navigationController pushViewController:updateInfo animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:@"职位详情"];
    
    if (self.isSelfPublishPosition) {
        //公司自己发布的职位
        [self setNavItemWithTitle:@"修改"
                           isLeft:NO
                           target:self
                           action:@selector(updatePositionInfo)];
    }else {
        [self setNavItemWithImage:@"HP_applyJob_collecte"
                  imageHightLight:@"HP_applyJob_collecte"
                           isLeft:NO
                           target:self
                           action:@selector(positionCollection)];
        
        if (!UserDefaultsGet(@"firstToastPositionDetail")) {
            [self showToastInfo];
        }
        
    }
    
    
    [self createUI];
}

- (void)createUI {
    
    bottomView = [self createBottomView];
    [self.view addSubview:bottomView];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, bottomView.top)
                                                                                   style:UITableViewStyleGrouped];
    
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    
    if (@available(iOS 11.0,*)) {
        mainTable.estimatedRowHeight = 0;
        mainTable.estimatedSectionHeaderHeight = 0;
        mainTable.estimatedSectionFooterHeight = 0;
        mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [mainTable registerClass:PositionDetailTableHeader.class forHeaderFooterViewReuseIdentifier:@"header"];
    
    [self startLoadingAnimation];
    [self getPositionDetail];

}

- (void)showToastInfo {
    
    NSString *content = @"若用人单位存在提供虚假招聘信息、发布虚假招聘广告，以担保或者其他任何名义向求职者收取财物（如办理卡费、押金、培训费），扣押或以保管为名索要身份证、毕业证及其他证件等行为，均属违法，请您提高警惕并注意保护个人信息！";
    [[CustomAlertView shareCustomAlertView] showTitle:nil content:content buttonTitle:@"确定" block:^(NSInteger index) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"firstToastPositionDetail" forKey:@"firstToastPositionDetail"];
        [userDefaults synchronize];
    }];
}

- (UIView *)createBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavigationBarHeight-50, kScreenWidth, 50)];
    bottomView.backgroundColor = kOrangeColor;
    
    if (self.isSelfPublishPosition) {
        //自己发布的职位
        UIButton *btn = [ButtonTool createButtonWithTitle:@"关闭此职位"
                                               titleColor:[UIColor whiteColor]
                                                titleFont:Font(K_TEXT_FONT_16)
                                                addTarget:self
                                                   action:@selector(updatePositionStatus)];
        btn.frame = CGRectMake(0, 0, bottomView.width, bottomView.height);
        btn.tag = 100;
        [bottomView addSubview:btn];
    }else {
        CGFloat iconSize = 20;
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame = CGRectMake(kScreenWidth/3.0*i, 0, kScreenWidth/3.0-1, bottomView.height);
            btn.tag = i+1;
            [btn addTarget:self action:@selector(clickBottomAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/2.0-10-iconSize, btn.height/2.0-iconSize/2.0, iconSize, iconSize)];
            icon.tag = 100;
            [btn addSubview:icon];
            
            UILabel *label = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(K_TEXT_FONT_12)];
            [btn addSubview:label];
            label.tag = 101;
            label.frame = CGRectMake(icon.right+10, icon.top, btn.width/2.0, icon.height);
            if (i < 2) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.right, btn.height/4.0, 1, btn.height/2.0)];
                line.backgroundColor = [UIColor whiteColor];
                [bottomView addSubview:line];
            }
            
            [bottomView addSubview:btn];
            
            switch (i) {
                case 0:{
                    icon.image = [UIImage imageNamed:@"HP_positionDetail_send"];
                    label.text = @"投简历";
                    sendResumeBtn = btn;
                }
                    break;
                case 1:{
                    icon.image = [UIImage imageNamed:@"HP_positionDetail_chat"];
                    label.text = @"发消息";
                }
                    break;
                case 2:{
                    icon.image = [UIImage imageNamed:@"HP_positionDetail_call"];
                    label.text = @"打电话";
                }
                    break;
                default:
                    break;
            }
        }
    }
    
    return bottomView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 3) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        return FIT_SCREEN_HEIGHT(65);
    }
    if (indexPath.row == 1 && indexPath.section == 0) {
        
        CGFloat coorX = 0;
        CGFloat coorY = 0;
        if (positionModel.company[@"companyWelfare"]) {
            NSArray *tagsArr = [positionModel.company[@"companyWelfare"] componentsSeparatedByString:@","];
            CGFloat wdtView = kScreenWidth - FIT_SCREEN_WIDTH(56);
            
            for (int i = 0; i < tagsArr.count; i++) {
                CGSize size = [tagsArr[i] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName,nil]];
                
                if ((coorX + size.width + 10) > wdtView) {
                    coorX = 0;
                    coorY += FIT_SCREEN_HEIGHT(20) + 20;
                }
                
                coorX += size.width + 10 + 15;
            }
            
            if (tagsArr.count > 0) {
                coorY += 20;
            }
        }
        
//        NSArray *tagsArr = @[@"五险一金",@"美女如云",@"13薪",@"带薪年假",@"具有成长潜力",@"独角兽",@"浪"];
        return 50 + FIT_SCREEN_HEIGHT(60) + coorY;
    }
    NSString *content = @"";
    CGFloat fontSize = K_TEXT_FONT_12;
    switch (indexPath.section) {
        case 0:{
         content = [NSString stringWithFormat:@"地址:%@\n经验:%@   学历:%@   性质:%@   性别:%@   年龄:%@   身高:%@   体重:%@",positionModel.addr,positionModel.exp,positionModel.education,positionModel.property,@"性别",@"年龄",positionModel.height,positionModel.weight];
        }
            break;
        case 1:{
            //工作职责
            fontSize = 13;
            content = positionModel.duty;
        }
            break;
        case 2:{
            //任职要求
            fontSize = 13;
            content = positionModel.demand;
        }
            break;
        case 3:{
            //公司简介
            fontSize = 13;
            content = positionModel.company[@"companyIntroduction"];
        }
            break;
            
            
        default:
            break;
    }
//    NSString *content = @"1、负责会员健身器械的指导与训练\n2、负责健身场馆内汇演的简单的劳动力\n3、为会员指定健身计划，安排课程";
    
    CGSize size = [UITool sizeOfStr:content
                            andFont:Font(fontSize)
                         andMaxSize:CGSizeMake(kScreenWidth-FIT_SCREEN_WIDTH(56), 1000)
                   andLineBreakMode:NSLineBreakByCharWrapping
                          lineSpace:3];
    return size.height+FIT_SCREEN_HEIGHT(5)+6;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 70;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        headerView.backgroundColor = [UIColor whiteColor];
        UIView * _orangeView = [[UIView alloc]initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(26), (70-24)/2.0, 4, 24)];
        [headerView addSubview:_orangeView];
        
        [_orangeView.layer addSublayer:[UIColor setPayGradualChangingColor:_orangeView fromColor:@"FF6B00" toColor:@"F98617"]];
        
        UILabel *titleLabel = [LabelTool createLableWithTextColor:k46Color font:Font(24)];
        titleLabel.frame = CGRectMake(_orangeView.right+12, _orangeView.top, kScreenWidth-_orangeView.right-FIT_SCREEN_WIDTH(83), _orangeView.height);
        [headerView addSubview:titleLabel];
        
        UILabel *rightLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(15)];
        rightLabel.frame = CGRectMake(titleLabel.right, titleLabel.top, kScreenWidth - titleLabel.right, titleLabel.height);
        [headerView addSubview:rightLabel];
        
        titleLabel.text = positionModel.name;
        rightLabel.text = positionModel.hopealary;
        return headerView;
    }
    PositionDetailTableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    header.contentView.backgroundColor = [UIColor whiteColor];
     header.moreIcon.hidden = YES;
    header.rightLabel.hidden = YES;
    header.titleLabel.font = Font(15);
    switch (section) {
        case 1:{
            header.titleLabel.text = @"工作职责";
        }
            break;
        case 2:{
            header.titleLabel.text = @"任职要求";
            header.rightLabel.text = @"10k-20k";
        }
            break;
        case 3:{
            header.titleLabel.text = @"公司信息";
            header.moreIcon.hidden = self.isHidenCompanyInfo;
            if (!self.isHidenCompanyInfo) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                     action:@selector(showCompanyInfo)];
                header.userInteractionEnabled = YES;
                [header addGestureRecognizer:tap];
            }
            
        }
            break;
            
        default:
            break;
    }
   
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        PositionDetailCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companyCell"];
        if (!cell) {
            cell = [[PositionDetailCompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"companyCell"];
        }
        
        cell.companyNameLabel.text = positionModel.company[@"companyName"]?positionModel.company[@"companyName"]:@"----/-----";
        cell.scaleLabel.text = [NSString stringWithFormat:@"%@人",positionModel.company[@"companyScale"]?positionModel.company[@"companyScale"]:@"--/--"];
        [cell.logoImg sd_setImageWithURL:[NSURL URLWithString:positionModel.company[@"companLogo"]] placeholderImage:[UIImage imageNamed:holdImage]];
        return cell;
    }
    if (indexPath.row == 1 && indexPath.section == 0) {
        PositionDetailRecruiterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headCell"];
        if (!cell) {
            cell = [[PositionDetailRecruiterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headCell"];
        }
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:positionModel.company[@"headImg"]]
    placeholderImage:[UIImage imageNamed:holdFace]];
        cell.recruiterLabel.text = positionModel.company[@"name"];
        cell.positionLabel.text = positionModel.company[@"position"];
//        cell.statusLabel.text = @"刚刚活跃";
        cell.statusLabel.hidden = YES;
        if (positionModel.company[@"companyWelfare"]) {
//            cell.tagsArr = @[@"五险一金",@"美女如云",@"13薪",@"带薪年假",@"具有成长潜力",@"独角兽",@"浪"];
            cell.tagsArr = [positionModel.company[@"companyWelfare"] componentsSeparatedByString:@","];
        }else{
            cell.tagsArr = nil;
        }
        
        
        return cell;
    }
    PositionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PositionDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *content = @"";
    CGFloat fontSize = K_TEXT_FONT_12;
    switch (indexPath.section) {
        case 0:{
            content = [NSString stringWithFormat:@"地址:%@\n经验:%@   学历:%@   性质:%@   性别:%@   年龄:%@   身高:%@   体重:%@",
                       positionModel.addr,
                       positionModel.exp,
                       positionModel.education,
                       positionModel.property,
                       positionModel.sex?positionModel.sex:@"不限",
                       positionModel.age?positionModel.age:@"不限",
                       positionModel.height?positionModel.height:@"不限",
                       positionModel.weight?positionModel.weight:@"不限"];
        }
            break;
        case 1:{
            //工作职责
            fontSize = 13;
            content = positionModel.duty;
        }
            break;
        case 2:{
            //任职要求
            fontSize = 13;
            content = positionModel.demand;
        }
            break;
        case 3:{
            //公司简介
            fontSize = 13;
            content = positionModel.company[@"companyIntroduction"];
        }
            break;
            
            
        default:
            break;
    }
//    cell.contentStr = content;
    [cell setContentStr:content fontSize:fontSize];
    return cell;
}

# pragma mark -- 显示公司信息
- (void)showCompanyInfo {
    CompanyRecruitInfoViewController *companyInfo = [[CompanyRecruitInfoViewController alloc]init];
    companyInfo.companyId = positionModel.companyId;
    [self.navigationController pushViewController:companyInfo animated:YES];
}

#pragma mark -- 点击底部action 投递简历 | 发消息 | 打电话
- (void)clickBottomAction:(UIButton *)btn {
    
    NSData *data = UserDefaultsGet(kUserModel);
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *senderId = [NSString stringWithFormat:@"%@",positionModel.user[@"id"]];
    
    BOOL isSelfSender = [[NSString stringWithFormat:@"%zi",model.id] isEqualToString:senderId];
    switch (btn.tag) {
        case 1:{
                //投递简历
            if (isSelfSender) {
                //自己发布的职位不能和自己聊天
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"不能投递自己发布的职位哦！" buttonTitle:nil block:nil];
                return;
            }
            [self sendResume];
            }
            break;
        case 2:{
            //发消息
            if (isSelfSender) {
                //自己发布的职位不能和自己聊天
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"不能与自己发布的职位私信哦！" buttonTitle:nil block:nil];
                return;
            }
            [self immediatelyCommunicate:model];
        }
            break;
        case 3:{
            //打电话
            
            if (isSelfSender) {
                //自己发布的职位不能和自己聊天
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"不能与自己发布的职位私信哦！" buttonTitle:nil block:nil];
                return;
            }
            if (positionModel.company[@"phone"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",positionModel.company[@"phone"]]]];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 投递简历
- (void)sendResume {
    NSDictionary *para = @{
                           @"positionId":@(positionModel.id?positionModel.id:0)
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kDeliveryPositionCreate parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            
            TO_STRONG(weakSelf, strongSelf);
            //已投递简历
            UIImageView *icon = (UIImageView *)[strongSelf->sendResumeBtn viewWithTag:100];
            icon.image = [UIImage imageNamed:@"HP_positionDetail_sendDone"];
            UILabel *label = (UILabel *)[strongSelf->sendResumeBtn viewWithTag:101];
            label.text = @"已投递";
            label.textColor = k210Color;
            strongSelf->sendResumeBtn.userInteractionEnabled = NO;
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 立即沟通
- (void)immediatelyCommunicate:(UserModel *)model {
//获取简历用户信息，连接环信，进入聊天室
    
    
    [SVProgressHUD showWithStatus:nil];
    
    
    TO_WEAK(self, weakSelf);
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    
    NSLog(@"isConnected = %d",[EMClient sharedClient].isConnected);
    NSLog(@"isLoggedIn = %d",[EMClient sharedClient].isLoggedIn);
    
    if (!isAutoLogin) {
        [[EMClient sharedClient] loginWithUsername:model.username password:model.username completion:^(NSString *aUsername, EMError *aError) {
            
            [SVProgressHUD dismiss];
            if (!aError) {
                TO_STRONG(weakSelf, strongSelf);
                NSString *chatId = [NSString stringWithFormat:@"%@",strongSelf->positionModel.user[@"username"]];
                ChatRoomViewController *cell = [[ChatRoomViewController alloc] initWithConversationChatter:chatId   conversationType:EMConversationTypeChat];
                cell.userInfoDic = strongSelf->positionModel.user;
                cell.flag = @"0";
                [self.navigationController pushViewController:cell animated:YES];
            } else {
                [[CustomAlertView shareCustomAlertView] showTitle:nil content:aError.errorDescription buttonTitle:nil block:nil];
                
            }
        }];
    } else {
        [SVProgressHUD dismiss];
        NSString *friendId = [NSString stringWithFormat:@"%@",self->positionModel.user[@"username"]];
        ChatRoomViewController *cell = [[ChatRoomViewController alloc] initWithConversationChatter:friendId   conversationType:EMConversationTypeChat];
        cell.flag = @"0";
        cell.userInfoDic = self->positionModel.user;
        [self.navigationController pushViewController:cell animated:YES];
    }
    
}

#pragma mark -- 获取职位详情
- (void)getPositionDetail {
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kPositionGet parms:@{@"id":[NSString stringWithFormat:@"%ld",self.positionId]} viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSDictionary *detail = dict[@"detail"];
            
            strongSelf->positionModel = [[PositionModel alloc] initWithDictionary:detail error:nil];
            strongSelf->positionModel.user =  detail[@"user"];
            
            if (weakSelf.isSelfPublishPosition) {
                //根据信息获取职位状态：打开|关闭
                UIButton *btn = [strongSelf->bottomView viewWithTag:100];
                if ([strongSelf->positionModel.state isEqualToString:@"CLOSE"]) {
                    [btn setTitle:@"打开此职位" forState:UIControlStateNormal];
                }else {
                    [btn setTitle:@"关闭此职位" forState:UIControlStateNormal];
                }
            }else {
                
                if (strongSelf->positionModel.isDelivery) {
                    //已投递简历
                    UIImageView *icon = (UIImageView *)[strongSelf->sendResumeBtn viewWithTag:100];
                    icon.image = [UIImage imageNamed:@"HP_positionDetail_sendDone"];
                    UILabel *label = (UILabel *)[strongSelf->sendResumeBtn viewWithTag:101];
                    label.text = @"已投递";
                    label.textColor = k210Color;
                    strongSelf->sendResumeBtn.userInteractionEnabled = NO;
                }
                if (strongSelf->positionModel.isCollection) {
                    [strongSelf setNavItemWithImage:@"HP_applyJob_collected"
                                    imageHightLight:@"HP_applyJob_collected"
                                             isLeft:NO
                                             target:strongSelf
                                             action:@selector(positionCollection)];
                }
            }
           
            [strongSelf->mainTable reloadData];
          
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
         [weakSelf stopLoadingAnimation];
    }];
}

#pragma mark -- 更新职位状态：打开|关闭职位
- (void)updatePositionStatus {
    NSString *url = kPositionUpdate;
    
    NSString *state = @"CLOSE";
    if ([positionModel.state isEqualToString:@"CLOSE"]) {
        state = @"OPEN";
    }
    NSDictionary *para = @{
                           @"id":@(_positionId?_positionId:0),
                           @"state":state
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:url parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            TO_STRONG(weakSelf, strongSelf);
            UIButton *btn = [strongSelf->bottomView viewWithTag:100];
            if ([state isEqualToString:@"CLOSE"]) {
                [btn setTitle:@"打开此职位" forState:UIControlStateNormal];
            }else {
                [btn setTitle:@"关闭此职位" forState:UIControlStateNormal];
            }
        }else {
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
