//
//  ResumeDetailViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "ResumeDetailViewController.h"
#import "PersonalResumeViewController.h"
#import "ChatRoomViewController.h"
#import "BaseNavigationViewController.h"

//view
#import "ResumeUserInfoCell.h"
#import "PositionDetailTableHeader.h"
#import "ResumeInfoCell.h"
#import "MWPhotoBrowser.h"

//model
#import "ResumeModel.h"
#import "UserModel.h"

@interface ResumeDetailViewController () <
    MWPhotoBrowserDelegate,
    UITableViewDelegate,
    UITableViewDataSource> {
    UITableView *resumeTable;
    ResumeModel *resumeModel;
}

@property (nonatomic, strong) BaseNavigationViewController *photoNavigationController;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@end

@implementation ResumeDetailViewController

# pragma mark -- 修改
- (void)updateReusme {
    PersonalResumeViewController *personalResume = [[PersonalResumeViewController alloc] init];
    personalResume.resumeModel = resumeModel;
    TO_WEAK(self, weakSelf);
    personalResume.UpdateResumeInfoBlock = ^(ResumeModel *model) {
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->resumeModel = model;
        [strongSelf->resumeTable reloadData];
        if (strongSelf.UpdateResumeBlock) {
            strongSelf.UpdateResumeBlock(strongSelf->resumeModel);
        }
    };
    [self.navigationController pushViewController:personalResume animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.resumeEnum) {
        case EditPersonalResume: {
            [self setMyTitle:@"个人简历"];
            [self setNavItemWithTitle:@"修改"
                               isLeft:NO
                               target:self
                               action:@selector(updateReusme)];
        }
            break;
        case BrowseRecruitmentResume: {
            [self setMyTitle:@"简历详情"];
            [self setNavItemWithImage:@"HP_applyJob_collecte"
                      imageHightLight:@"HP_applyJob_collecte"
                               isLeft:NO
                               target:self
                               action:@selector(resumeCollection)];
        }
            break;
        case BrowseOwnResume: {
            [self setMyTitle:@"个人简历"];
        }
            break;
            
        default:
            break;
    }
    
    [self createUI];
}

- (void)createUI {
    resumeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
    resumeTable.delegate = self;
    resumeTable.dataSource = self;
    resumeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0,*)) {
        resumeTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        resumeTable.estimatedRowHeight = 0;
        resumeTable.estimatedSectionHeaderHeight = 0;
        resumeTable.estimatedSectionFooterHeight = 0;
    }
    [resumeTable registerClass:PositionDetailTableHeader.class forHeaderFooterViewReuseIdentifier:@"header"];
    [self.view addSubview:resumeTable];
    
    switch (self.resumeEnum) {
        case BrowseRecruitmentResume: {
            //显示底部按钮 发消息 | 打电话
            UIView *bottomView = [self createBottomView];
            [self.view addSubview:bottomView];
            resumeTable.height = bottomView.top;
        }
            break;
        case EditPersonalResume:{
            //修改简历状态 开放|关闭简历
            UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavigationBarHeight-50, kScreenWidth, 50)];
            sendBtn.backgroundColor = kOrangeColor;
            [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sendBtn setTitle:@"开放简历" forState:UIControlStateNormal];
            [sendBtn addTarget:self
                        action:@selector(updateResumeStatus)
              forControlEvents:UIControlEventTouchDown];
            sendBtn.tag = 100;
            [self.view addSubview:sendBtn];
            resumeTable.height = sendBtn.top;
        }
            break;
            
        default:
            break;
    }
    
    [self startLoadingAnimation];
    [self getResumeDetail];

}

- (UIView *)createBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavigationBarHeight-50, kScreenWidth, 50)];
    bottomView.backgroundColor = kOrangeColor;
    
    CGFloat iconSize = 20;
    NSArray *titles = @[@"发消息",@"打电话"];
    NSArray *icons = @[@"HP_positionDetail_chat",@"HP_positionDetail_call"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(kScreenWidth/titles.count*i, 0, kScreenWidth/titles.count-1, bottomView.height);
        btn.tag = i+1;
        [btn addTarget:self action:@selector(clickBottomAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(btn.width/2.0-10-iconSize, btn.height/2.0-iconSize/2.0, iconSize, iconSize)];
        [btn addSubview:icon];
        
        UILabel *label = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(K_TEXT_FONT_12)];
        [btn addSubview:label];
        label.frame = CGRectMake(icon.right+10, icon.top, btn.width/2.0, icon.height);
        if (i < 2) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.right, btn.height/4.0, 1, btn.height/2.0)];
            line.backgroundColor = [UIColor whiteColor];
            [bottomView addSubview:line];
        }
        
        [bottomView addSubview:btn];
        
        icon.image = [UIImage imageNamed:icons[i]];
        label.text = titles[i];
    }
    return bottomView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (resumeModel && section > 2) {
        switch (section) {
            case 3:
                //工作经历
                 return resumeModel.workExpList.count;
            case 4:
                //培训经历
                return resumeModel.trainExpList.count;
            case 5:
                //比赛经历
                return resumeModel.matchExpList.count;
            default:
                break;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 65;
    }
    
    if (indexPath.section == 0) {
        CGSize size = [UITool sizeOfStr:resumeModel.introduction?resumeModel.introduction:@""
                                andFont:Font(K_TEXT_FONT_12)
                             andMaxSize:CGSizeMake(kScreenWidth - FIT_SCREEN_WIDTH(83) - 70, MAXFLOAT)
                       andLineBreakMode:NSLineBreakByCharWrapping];
        
        if (size.height > 20) {
            return 110 + size.height - 20;
        }
        return 110;
    }
    
    
    NSString *con;
    
    switch (indexPath.section) {
        case 2:{
            //求职意向
            con = [NSString stringWithFormat:@"%@",resumeModel.hope?resumeModel.hope:@""];
        }
            break;
        case 3:{
            //工作经历
            NSDictionary *dic = resumeModel.workExpList[indexPath.row];
            con = [NSString stringWithFormat:@"%@\n%@",dic[@"position"],dic[@"workContent"]];
        }
            break;
        case 4:{
            //培训经历
                NSDictionary *dic = resumeModel.trainExpList[indexPath.row];
                con = [NSString stringWithFormat:@"%@",dic[@"time"]];
            }
            break;
        case 5:{
            //比赛经历
            NSDictionary *dic = resumeModel.matchExpList[indexPath.row];
            con = [NSString stringWithFormat:@"%@",dic[@"project"]];
        }
            break;
            
        default:
            break;
    }
    CGSize size = [UITool sizeOfStr:con
                            andFont:Font(K_TEXT_FONT_12)
                         andMaxSize:CGSizeMake(kScreenWidth - FIT_SCREEN_WIDTH(60), 1000)
                   andLineBreakMode:NSLineBreakByCharWrapping
                          lineSpace:3];
    
    return FIT_SCREEN_HEIGHT(10) + 24 + size.height + 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 1) {
        return 45;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section > 1) {
        PositionDetailTableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        header.contentView.backgroundColor = [UIColor whiteColor];
        
        header.moreIcon.hidden = YES;
        header.rightLabel.hidden = YES;
        switch (section) {
            case 2:{
                header.titleLabel.text = @"求职意向";
            }
                break;
            case 3:{
                header.titleLabel.text = @"工作经历";
            }
                break;
            case 4:{
                header.titleLabel.text = @"培训经历";
            }
                break;
            case 5:{
                header.titleLabel.text = @"比赛经历";
                
            }
                break;
                
            default:
                break;
        }
        
        return header;
    }
    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat coorX = FIT_SCREEN_WIDTH(30);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(coorX, 0, kScreenWidth-coorX*2, footerView.height)];
    line.backgroundColor = LaneCOLOR;
    [footerView addSubview:line];
    
    return footerView;
//    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_10)];
        CGFloat coorX = FIT_SCREEN_WIDTH(30);
        titleLabel.frame = CGRectMake(coorX, 5, (kScreenWidth - coorX*2)/2.0, 20);
        titleLabel.text = @"专业";
        [cell.contentView addSubview:titleLabel];
        
        
        //专业内容
        UILabel *conLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
        conLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, 35);
        conLabel.numberOfLines = 0;
        conLabel.lineBreakMode = NSLineBreakByCharWrapping;
        conLabel.text = resumeModel.major;
        [cell.contentView addSubview:conLabel];
        
        
        UILabel *rightTitleLabel = [LabelTool createLableWithTextColor:kOrangeColor
                                                                  font:Font(K_TEXT_FONT_10)];
        
        rightTitleLabel.frame = CGRectMake(titleLabel.right,
                                           titleLabel.top,
                                           titleLabel.width,
                                           titleLabel.height);
        rightTitleLabel.text = @"毕业院校";
        [cell.contentView addSubview:rightTitleLabel];
        
        UILabel *rightConLabel = [LabelTool createLableWithTextColor:k46Color
                                                                font:Font(K_TEXT_FONT_14)];
        
        rightConLabel.frame = CGRectMake(rightTitleLabel.left,
                                         conLabel.top,
                                         conLabel.width,
                                         conLabel.height);
        rightConLabel.numberOfLines = 0;
        rightConLabel.lineBreakMode = NSLineBreakByCharWrapping;
        rightConLabel.text = resumeModel.school;
        [cell.contentView addSubview:rightConLabel];
        
        
        return cell;
    }
    
    if (indexPath.section == 0) {
        static NSString *iden = @"cell";
        
        ResumeUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[ResumeUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        
        cell.model = resumeModel;
        
        TO_WEAK(self, weakSelf);
        cell.ClickHeadBlock = ^{
            [weakSelf presentViewController:weakSelf.photoNavigationController animated:YES completion:nil];
        };
        return cell;
    }
    
    static NSString *iden = @"resumeInfo";
    
    ResumeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[ResumeInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    
    switch (indexPath.section) {
        case 2:{
            //求职意向
            cell.subTitleLabel.textColor = kOrangeColor;
            cell.subTitleLabel.font = Font(K_TEXT_FONT_12);
            
            //期望行业
            cell.titleNameLabel.text = resumeModel.hopePosition;
            //期望薪资
            cell.subTitleLabel.text = [NSString stringWithFormat:@"%@",resumeModel.hopealary?resumeModel.hopealary:@""];
            //目前状态
            cell.conLabel.text = [NSString stringWithFormat:@"%@",resumeModel.hope?resumeModel.hope:@""];
        }
            break;
        case 3:{
            //工作经历
            
            NSDictionary *dic = resumeModel.workExpList[indexPath.row];
            cell.titleNameLabel.text = dic[@"company"];
            cell.subTitleLabel.textColor = k75Color;
            cell.subTitleLabel.font = Font(K_TEXT_FONT_10);
            cell.subTitleLabel.text = [NSString stringWithFormat:@"%@-%@",
                                       dic[@"workStartTime"]?dic[@"workStartTime"]:@"",
                                       dic[@"workStartTime"]?dic[@"workStartTime"]:@""];
            cell.conLabel.text = [NSString stringWithFormat:@"%@\n%@",dic[@"position"]?dic[@"position"]:@"",dic[@"workContent"]?dic[@"workContent"]:@""];
        }
            break;
        case 4:{
            //培训经历
            NSDictionary *dic = resumeModel.trainExpList[indexPath.row];
            cell.titleNameLabel.text = dic[@"name"];
            cell.conLabel.text = [NSString stringWithFormat:@"%@",dic[@"time"]?dic[@"time"]:@""];
        }
            break;
        case 5:{
            //比赛经历
            NSDictionary *dic = resumeModel.matchExpList[indexPath.row];
            cell.titleNameLabel.text = dic[@"name"];
            cell.conLabel.text = [NSString stringWithFormat:@"%@",dic[@"project"]?dic[@"project"]:@""];
        }
            break;
            
        default:
            break;
    }
    
    if (indexPath.section < 4) {
        cell.subTitleLabel.hidden = NO;
        
    }else {
        cell.subTitleLabel.hidden = YES;
    }
    
    
    [UITool label:cell.conLabel andLineSpacing:3 andColor:cell.conLabel.textColor];
    
    NSString *con = [NSString stringWithFormat:@"%@", cell.conLabel.text];
    CGSize size = [UITool sizeOfStr:con
                            andFont:Font(K_TEXT_FONT_12)
                         andMaxSize:CGSizeMake(kScreenWidth - FIT_SCREEN_WIDTH(60), 1000)
                   andLineBreakMode:NSLineBreakByCharWrapping
                          lineSpace:3];
    
    cell.conLabel.frame = CGRectMake(cell.conLabel.left,
                                     cell.conLabel.top,
                                     cell.conLabel.width,
                                     size.height+5);
    return cell;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = NO;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}

- (BaseNavigationViewController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[BaseNavigationViewController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

//@protocol MWPhotoBrowserDelegate <NSObject>

#pragma mark -- MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}


- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [MWPhoto photoWithURL:[NSURL URLWithString:resumeModel.headImg]];
}

#pragma mark -- 发消息 | 打电话
- (void)clickBottomAction:(UIButton *)btn {
    if (btn.tag == 1) {
        //发消息
        
        [SVProgressHUD showWithStatus:nil];
        //获取简历用户信息，连接环信，进入聊天室
        NSData *data = UserDefaultsGet(kUserModel);
        UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        TO_WEAK(self, weakSelf);
        
        BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
        NSLog(@"isConnected = %d",[EMClient sharedClient].isConnected);
        NSLog(@"isLoggedIn = %d",[EMClient sharedClient].isLoggedIn);
        if (!isAutoLogin) {
            [[EMClient sharedClient] loginWithUsername:model.username password:model.username completion:^(NSString *aUsername, EMError *aError) {
                [SVProgressHUD dismiss];
                TO_STRONG(weakSelf, strongSelf);
                if (!aError) {
                    
                    NSString *friendId = [NSString stringWithFormat:@"%@",strongSelf->resumeModel.user[@"nickName"]];
                    ChatRoomViewController *cell = [[ChatRoomViewController alloc] initWithConversationChatter:friendId   conversationType:EMConversationTypeChat];
                    cell.flag = @"0";
                    cell.userInfoDic = strongSelf->resumeModel.user;
                    [strongSelf.navigationController pushViewController:cell animated:YES];
                } else {
                    [[CustomAlertView shareCustomAlertView] showTitle:nil content:aError.errorDescription buttonTitle:nil block:nil];
                    
                }
            }];
        }else {
            [SVProgressHUD dismiss];
            NSString *friendId = [NSString stringWithFormat:@"%@",self->resumeModel.user[@"username"]];
            ChatRoomViewController *cell = [[ChatRoomViewController alloc] initWithConversationChatter:friendId   conversationType:EMConversationTypeChat];
            cell.flag = @"0";
            cell.userInfoDic = self->resumeModel.user;
            [self.navigationController pushViewController:cell animated:YES];
        }
        
    } else {
        //打电话
        if (resumeModel.phone) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",resumeModel.phone]]];
        }
    }
}
    
# pragma mark -- 更新简历状态
- (void)updateResumeStatus {
    NSDictionary *para = @{
                           @"id":[NSString stringWithFormat:@"%ld",(long)self.resumeId]
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kResumeOpenOrClose parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            NSDictionary *data = dict[@"resume"];
            strongSelf->resumeModel.state = data[@"state"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *sendBtn = (UIButton *)[strongSelf.view viewWithTag:100];
                if ([strongSelf->resumeModel.state isEqualToString:@"CLOSE"]) {
                    [sendBtn setTitle:@"开放简历" forState:UIControlStateNormal];
                }else {
                    [sendBtn setTitle:@"关闭简历" forState:UIControlStateNormal];
                }
            });
            
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- 获取简历详情
- (void)getResumeDetail {
    NSDictionary *para = @{
                           @"id":[NSString stringWithFormat:@"%ld",(long)self.resumeId]
                           };
    
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kResumeGet parms:para viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        
        if ([remindMsg integerValue] == 999) {
            NSDictionary *data = dict[@"resume"];
            strongSelf->resumeModel = [[ResumeModel alloc] initWithDictionary:data error:nil];
            strongSelf->resumeModel.workExpList = dict[@"workExpList"];
            strongSelf->resumeModel.matchExpList = dict[@"matchExpList"];
            strongSelf->resumeModel.trainExpList = dict[@"trainExpList"];
            strongSelf->resumeModel.user = dict[@"user"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIButton *sendBtn = (UIButton *)[strongSelf.view viewWithTag:100];
                if ([strongSelf->resumeModel.state isEqualToString:@"CLOSE"]) {
                    [sendBtn setTitle:@"开放简历" forState:UIControlStateNormal];
                }else {
                    [sendBtn setTitle:@"关闭简历" forState:UIControlStateNormal];
                }
                
                 [strongSelf->resumeTable reloadData];
            });
           
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
        
         [weakSelf stopLoadingAnimation];
    } failed:^(NSError *error) {
         [weakSelf stopLoadingAnimation];
    }];
}

#pragma mark -- 简历收藏
- (void)resumeCollection {
    NSDictionary *para = @{
                           @"id":[NSString stringWithFormat:@"%ld",(long)self.resumeId]
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kUserResumeToggle parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            
            TO_STRONG(weakSelf, strongSelf);
            if ([[dict[@"bool"] stringValue] isEqualToString:@"1"]) {
                //收藏简历成功
                [strongSelf setNavItemWithImage:@"HP_applyJob_collected"
                          imageHightLight:@"HP_applyJob_collected"
                                   isLeft:NO
                                   target:strongSelf
                                   action:@selector(resumeCollection)];
            }else {
                //收藏简历失败
                [strongSelf setNavItemWithImage:@"HP_applyJob_collecte"
                          imageHightLight:@"HP_applyJob_collecte"
                                   isLeft:NO
                                   target:strongSelf
                                   action:@selector(resumeCollection)];
                
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
