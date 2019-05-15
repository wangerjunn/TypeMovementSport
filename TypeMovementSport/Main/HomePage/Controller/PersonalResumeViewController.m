//
//  PersonalResumeViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/29.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "PersonalResumeViewController.h"
#import "ResumeBasicInfoViewController.h"
#import "PersonalResumeIntrViewController.h"//个人简介
#import "ResumeDetailViewController.h"

//view
#import "PositionDetailCompanyCell.h"

static NSString *kTitle = @"title";
static NSString *kIsEnableEdit = @"isEnableEdit";
static NSString *kType = @"type";
static NSString *kContent = @"content";
static NSString *kTitles = @"titles";
static NSString *kElements = @"element";
static NSString *kIsMultiple = @"isMultiple";

@interface PersonalResumeViewController () <
    UITableViewDelegate,
    UITableViewDataSource> {
    UITableView *resumeTable;
        NSMutableArray *workArr;
        NSMutableArray *trainArr;
        NSMutableArray *matchArr;
        
        BOOL isUpdateResume;
}

@end

@implementation PersonalResumeViewController

- (void)goBack {
    if (isUpdateResume) {
        TO_WEAK(self, weakSelf);
        if (self.UpdateResumeInfoBlock) {
            
            weakSelf.UpdateResumeInfoBlock(weakSelf.resumeModel);
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"个人简历"];
    
    [self createUI];
}

- (void)createUI {
    
    UIButton *bottomBtn = [ButtonTool createButtonWithTitle:@"查看简历" titleColor:[UIColor whiteColor] titleFont:Font(K_TEXT_FONT_16) addTarget:self action:@selector(browseResume)];
    bottomBtn.frame = CGRectMake(0, kScreenHeight-kNavigationBarHeight-50, kScreenWidth, 50);
    bottomBtn.backgroundColor = kOrangeColor;
    [self.view addSubview:bottomBtn];
    resumeTable = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, kScreenWidth, bottomBtn.top)
                                             style:UITableViewStyleGrouped];
    resumeTable.delegate = self;
    resumeTable.dataSource = self;
    resumeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    resumeTable.backgroundColor = [UIColor whiteColor];
    resumeTable.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0,*)) {
        resumeTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        resumeTable.estimatedRowHeight = 0;
        resumeTable.estimatedSectionHeaderHeight = 0;
        resumeTable.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:resumeTable];
    
    if (self.resumeModel) {
        workArr = [NSMutableArray arrayWithArray:self.resumeModel.workExpList];
        
        trainArr = [NSMutableArray arrayWithArray:self.resumeModel.trainExpList];
        
        matchArr = [NSMutableArray arrayWithArray:self.resumeModel.matchExpList];
    }else{
        workArr = [NSMutableArray array];
        trainArr = [NSMutableArray array];
        matchArr = [NSMutableArray array];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    
    switch (section) {
        case 1:
            return workArr.count;
        case 2:
            return trainArr.count;
        case 3:
            return matchArr.count;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.section == 0) {
        if (indexPath.row == 0 && self.resumeModel) {
            return FIT_SCREEN_HEIGHT(65);
        }
        
        return 60;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.5;
    }
    
    return 90;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(26), 0, footerView.width-FIT_SCREEN_WIDTH(52), 0.5)];
        line.backgroundColor = LaneCOLOR;
        
        [footerView addSubview:line];
        return footerView;
    }
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    
    UIButton *btn = [ButtonTool createButtonWithTitle:@"" titleColor:k46Color titleFont:Font(K_TEXT_FONT_14) addTarget:self action:@selector(supplementaryInformation:)];
    
    btn.tag = 100+section;
    btn.layer.masksToBounds =YES;
    btn.layer.cornerRadius = 15;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = k46Color.CGColor;
    btn.frame = CGRectMake(footerView.width/2.0-100, footerView.height/2.0-15, 200, 30);
    [footerView addSubview:btn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(26), footerView.height-1, footerView.width-FIT_SCREEN_WIDTH(52), 0.5)];
    line.backgroundColor = LaneCOLOR;
    
    [footerView addSubview:line];
    
    switch (section) {
        case 1:{
            //工作经历
            [btn setTitle:@"+ 工作经历" forState:UIControlStateNormal];
        }
            break;
        case 2:{
            //培训经历
            [btn setTitle:@"+ 培训经历(选填)" forState:UIControlStateNormal];
        }
            break;
        case 3:{
            //比赛经历
            [btn setTitle:@"+ 比赛经历(选填)" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0 && self.resumeModel) {
            PositionDetailCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[PositionDetailCompanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.companyNameLabel.text = self.resumeModel.name;
            cell.scaleLabel.text = [NSString stringWithFormat:@"%@.%@",self.resumeModel.sex,self.resumeModel.birthday];
            [cell.logoImg sd_setImageWithURL:[NSURL URLWithString:_resumeModel.headImg] placeholderImage:[UIImage imageNamed:holdFace]];
            
            return cell;
        }
        
    
        static NSString *iden = @"basicInfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *label = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
            label.tag = 100;
            [cell.contentView addSubview:label];
            CGFloat coorX = FIT_SCREEN_WIDTH(26);
            label.frame = CGRectMake(coorX, 0, kScreenWidth - coorX*3, 60);
            
        }
        
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
            label.text = @"";
        
            switch (indexPath.row) {
                case 0:{
                    label.text = @"编辑个人信息";
                }
                    break;
                case 1:{
                    label.text = @"添加求职意向";
                }
                    break;
                case 2:{
                    label.text = @"个人简介";
                }
                    break;
                    
                default:
                    break;
            }
            return cell;
    }
    static NSString *iden = @"cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *label = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
        label.tag = 100;
        [cell.contentView addSubview:label];
        CGFloat coorX = FIT_SCREEN_WIDTH(26);
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(coorX, 0, kScreenWidth - coorX*6, 40);
        
        UILabel *conLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_12)];
        conLabel.frame = CGRectMake(label.right, label.top, kScreenWidth - label.right - coorX-5, label.height);
        conLabel.textAlignment = NSTextAlignmentRight;
        conLabel.tag = 101;
        conLabel.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:conLabel];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = @"";
    
    UILabel *conLabel = (UILabel *)[cell.contentView viewWithTag:101];
    conLabel.text = @"";
    
    switch (indexPath.section) {
        case 1:{
            //工作经历
            NSDictionary *dic = workArr[indexPath.row];
            label.text = dic[@"company"];
            conLabel.text = [NSString stringWithFormat:@"%@-%@",
                             dic[@"workStartTime"]?dic[@"workStartTime"]:@"",
                             dic[@"workEndTime"]?dic[@"workEndTime"]:@""];
        }
            break;
        case 2:{
            //培训经历
            NSDictionary *dic = trainArr[indexPath.row];
            label.text = dic[@"name"];
            conLabel.text = [NSString stringWithFormat:@"%@",dic[@"time"]?dic[@"time"]:@""];
        }
            break;
        case 3:{
            //比赛经历
            NSDictionary *dic = matchArr[indexPath.row];
            label.text = dic[@"name"];
            conLabel.text = dic[@"time"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            //顶部
            switch (indexPath.row) {
                case 0: {
                        //用户头像栏
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"PopDataConfig" ofType:@"plist"];
                    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
                       NSArray *titles = @[  @{
                                     kTitle:@"姓名",
                                     kIsEnableEdit:@"1",
                                     kContent:_resumeModel.name?_resumeModel.name:@"",
                                     },@{
                                     kTitle:@"性别",
                                     kIsEnableEdit:@"0",
                                     kContent:_resumeModel.sex?_resumeModel.sex:@"",
                                     kElements:@[@"男",@"女"]
                                     },@{
                                     kTitle:@"学历",
                                     kIsEnableEdit:@"0",
                                     kContent:_resumeModel.education?_resumeModel.education:@"",
                                     kElements:dic[kEducation]
                                     },@{
                                     kTitle:@"专业",
                                     kContent:_resumeModel.major?_resumeModel.major:@"",
                                     kIsEnableEdit:@"1"
                                     },@{
                                     kTitle:@"毕业院校",
                                     kContent:_resumeModel.school?_resumeModel.school:@"",
                                     kIsEnableEdit:@"1"
                                     },@{
                                     kTitle:@"工作经验",
                                     kContent:_resumeModel.workExpYear?_resumeModel.workExpYear:@"",
                                     kIsEnableEdit:@"0",
                                     kElements:dic[kWorkExpYears]
                                     },@{
                                     kTitle:@"出生日期",
                                     kContent:_resumeModel.birthday?_resumeModel.birthday:@"",
                                     kIsEnableEdit:@"0"
                                     },@{
                                     kTitle:@"手机号",
                                     kContent:_resumeModel.phone?_resumeModel.phone:@"",
                                     kIsEnableEdit:@"1"
                                     },@{
                                     kTitle:@"验证码",
                                     kContent:@"",
                                     kIsEnableEdit:@"1"
                                         }];
                    
                    [self editResumeInfo:@"0" showContents:titles id:_resumeModel?_resumeModel.id:-1 row:indexPath.row];
                    }
                    break;
                case 1:{
                    //求职意向
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"PopDataConfig" ofType:@"plist"];
                    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
                    NSArray *titles = @[  @{
                                              kTitle:@"期望职位",
                                              kIsEnableEdit:@"1",
                                              kContent:_resumeModel.hopePosition?_resumeModel.hopePosition:@"",
                                              },@{
                                              kTitle:@"期望城市",
                                              kContent:_resumeModel.hopeCity?_resumeModel.hopeCity:@"",
                                              kIsEnableEdit:@"0"
                                              },@{
                                              kTitle:@"期望薪资",
                                              kIsEnableEdit:@"0",
                                              kContent:_resumeModel.hopealary?_resumeModel.hopealary:@"",
                                              kElements:dic[kHopeSalary]
                                              },@{
                                              kTitle:@"目前状态",
                                              kIsEnableEdit:@"0",
                                              kContent:_resumeModel.hope?_resumeModel.hope:@"",
                                              kElements:dic[kCurrentState]
                                              }];
                    [self editResumeInfo:@"1" showContents:titles id:_resumeModel?_resumeModel.id:-1 row:indexPath.row];
                }
                    break;
                case 2:{
                    //个人简介
                    PersonalResumeIntrViewController *introduce = [[PersonalResumeIntrViewController alloc] init];
                    if (self.resumeModel) {
                        introduce.resumeModel = self.resumeModel;
                    }
                    TO_WEAK(self, weakSelf);
                    introduce.RightBarItemBlock = ^(NSString *intro){
                        TO_STRONG(weakSelf, strongSelf);
                        strongSelf.resumeModel.introduction = intro;
                        strongSelf->isUpdateResume = YES;
                    };
                    [self.navigationController pushViewController:introduce animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:{
            //工作经历
            [self configWorkData:NO row:indexPath.row];
        }
            break;
        case 2:{
            //培训经历
            [self configTrainData:NO row:indexPath.row];
        }
            break;
        case 3:{
            //比赛经历
            [self configMatchData:NO row:indexPath.row];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 配置比赛item
- (void)configMatchData:(BOOL)isAdd row:(NSInteger)row {
    
    NSDictionary *dic;
    NSInteger itemId = -1;
    if (row != -1) {
        dic = matchArr[row];
        itemId = [dic[@"id"] integerValue];
    }
    
    NSArray *titles = @[  @{
                              kTitle:@"比赛名称",
                              kIsEnableEdit:@"1",
                              kContent:dic[@"name"]?dic[@"name"]:@""
                              },@{
                              kTitle:@"比赛项目",
                              kIsEnableEdit:@"1",
                              kContent:dic[@"project"]?dic[@"project"]:@""
                              },@{
                              kTitle:@"比赛时间",
                              kIsEnableEdit:@"0",
                              kContent:dic[@"time"]?dic[@"time"]:@""
                              }];
    [self editResumeInfo:@"4" showContents:titles id:itemId row:row];
}

#pragma mark -- 配置培训item
- (void)configTrainData:(BOOL)isAdd row:(NSInteger)row {
    NSDictionary *dic;
    NSInteger itemId = -1;
    if (row != -1) {
        dic = trainArr[row];
         itemId = [dic[@"id"] integerValue];
    }
    NSArray *titles = @[  @{
                              kTitle:@"培训名称",
                              kIsEnableEdit:@"1",
                              kContent:dic[@"name"]?dic[@"name"]:@""
                              },@{
                              kTitle:@"培训时间",
                              kIsEnableEdit:@"0",
                              kContent:dic[@"time"]?dic[@"time"]:@""
                              }];
    [self editResumeInfo:@"3" showContents:titles id:itemId row:row];
}

#pragma mark -- 配置工作经历item
- (void)configWorkData:(BOOL)isAdd row:(NSInteger)row {
    NSDictionary *dic;
    NSInteger itemId = -1;
    if (row != -1) {
        dic = workArr[row];
         itemId = [dic[@"id"] integerValue];
    }
    
    NSString *workTime = @"";
    if (dic[@"workStartTime"] &&  dic[@"workEndTime"]) {
        workTime = [NSString stringWithFormat:@"%@-%@",
                    dic[@"workStartTime"]?dic[@"workStartTime"]:@"",
                    dic[@"workEndTime"]?dic[@"workEndTime"]:@""];
    }
    NSArray *titles = @[  @{
                              kTitle:@"公司名称",
                              kIsEnableEdit:@"1",
                              kContent:dic[@"company"]?dic[@"company"]:@""
                              },@{
                              kTitle:@"职位名称",
                              kIsEnableEdit:@"1",
                              kContent:dic[@"position"]?dic[@"position"]:@""
                              },@{
                              kTitle:@"任职时间",
                              kIsEnableEdit:@"0",
                              kContent:workTime
                              },@{
                              kTitle:@"工作内容",
                              kIsEnableEdit:@"1",
                              kContent:dic[@"workContent"]?dic[@"workContent"]:@""
                              }];
    [self editResumeInfo:@"2" showContents:titles id:itemId row:row];
}

# pragma mark -- 补充信息 工作经历 | 培训经历 | 比赛经历
- (void)supplementaryInformation:(UIButton *)btn {
    switch (btn.tag) {
        case 101:{
            //工作经历
            [self configWorkData:YES row:-1];
        }
            break;
        case 102:{
            //培训经历
            [self configTrainData:YES row:-1];
        }
            break;
        case 103:{
            //比赛经历
            [self configMatchData:YES row:-1];
        }
            break;
            
        default:
            break;
    }
}


/**
 简历信息列表

 @param type    EditResumeHeadInfo = 0,//编辑简历头像信息
                             EditResumeJobIntentionInfo,//编辑简历工作意向
                             EditResumeJobInfo,//编辑简历工作信息
                             EditResumeTrainInfo,//编辑简历培训信息
                             EditResumeGameInfo,//编辑简历比赛信息
                             EditEnterpriseCertificationInfo,//编辑企业认证企业
                             EditSendResumeInfo//编辑简历发布信息
 @param contents data数组
 @param itemId 编辑已存在的item的id
 
 
 */
- (void)editResumeInfo:(NSString *)type
                showContents:(NSArray *)contents
                    id:(NSInteger)itemId
                                  row:(NSInteger)row {
    
    ResumeBasicInfoViewController *resumeBasicInfo = [[ResumeBasicInfoViewController alloc]init];
    if (itemId != -1) {
        resumeBasicInfo.itemId = itemId;
    }
    if (_resumeModel) {
        resumeBasicInfo.resumeId = _resumeModel.id;
        switch ([type integerValue]) {
            case 0:{
                //头像url
                resumeBasicInfo.imgUrl = _resumeModel.headImg?_resumeModel.headImg:@"";
                break;
            }case 3:{
                //培训证书url
                if (trainArr.count > row && row != -1) {
                    NSDictionary * dic = trainArr[row];
                    resumeBasicInfo.imgUrl = [NSString stringWithFormat:@"%@",dic[@"img"]?dic[@"img"]:@""];
                }
                break;
            }case 4:{
                //比赛证书url
                if (matchArr.count > row && row != -1) {
                    NSDictionary * dic = matchArr[row];
                    resumeBasicInfo.imgUrl = [NSString stringWithFormat:@"%@",dic[@"img"]?dic[@"img"]:@""];
                }
                break;
            }
                
            default:
                break;
        }
    }
    TO_WEAK(self, weakSelf);
    resumeBasicInfo.RightBarItemBlock = ^(NSDictionary *dict ){
       //点击保存回调
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->isUpdateResume = YES;
        if (dict) {
            
            switch ([type integerValue]) {
                case 0:{
                    //编辑个人信息
                    if (dict) {
                        strongSelf.resumeModel = [[ResumeModel alloc] initWithDictionary:dict error:nil];
                        strongSelf.resumeModel.workExpList = strongSelf->workArr;
                        strongSelf.resumeModel.trainExpList = strongSelf->trainArr;
                        strongSelf.resumeModel.matchExpList = strongSelf->matchArr;
                        [strongSelf->resumeTable reloadData];
                    }
                }
                    break;
                case 1:{
                    //编辑求职意向
                    if (dict) {
                        strongSelf.resumeModel = [[ResumeModel alloc] initWithDictionary:dict error:nil];
                        strongSelf.resumeModel.workExpList = strongSelf->workArr;
                        strongSelf.resumeModel.trainExpList = strongSelf->trainArr;
                        strongSelf.resumeModel.matchExpList = strongSelf->matchArr;
                        [strongSelf->resumeTable reloadData];
                    }
                    break;
                }
                    
                case 2:{
                    //工作经历
                    if (dict) {
                        if (row != -1) {
                            [strongSelf->workArr replaceObjectAtIndex:row withObject:dict];
                        }else {
                            [strongSelf->workArr addObject:dict];
                        }
                        
                        strongSelf.resumeModel.workExpList = strongSelf->workArr;
                        [strongSelf->resumeTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
                    break;
                case 3:{
                    //培训经历
                    if (row != -1) {
                        [strongSelf->trainArr replaceObjectAtIndex:row withObject:dict];
                    }else {
                        [strongSelf->trainArr addObject:dict];
                    }
                    strongSelf.resumeModel.trainExpList = strongSelf->trainArr;
                    [strongSelf->resumeTable reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                }
                    break;
                case 4:{
                    //比赛经历
                    if (row != -1) {
                        [strongSelf->matchArr replaceObjectAtIndex:row withObject:dict];
                    }else {
                        [strongSelf->matchArr addObject:dict];
                    }
                    strongSelf.resumeModel.matchExpList = strongSelf->matchArr;
                    [strongSelf->resumeTable reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                }
                    break;
                    
                default:
                    break;
            }
        }
    };
    
    resumeBasicInfo.DeleteItemBlock = ^{
        TO_STRONG(weakSelf, strongSelf);
        strongSelf->isUpdateResume = YES;
       //删除回调
        switch ([type integerValue]) {
            case 2:{
                //工作经历
                [strongSelf->workArr removeObjectAtIndex:row];
                strongSelf.resumeModel.workExpList = strongSelf->workArr;
            }
                break;
            case 3:{
                //培训经历
                [strongSelf->trainArr removeObjectAtIndex:row];
                strongSelf.resumeModel.trainExpList = strongSelf->trainArr;
            }
                break;
            case 4:{
                //比赛经历
                [strongSelf->matchArr removeObjectAtIndex:row];
                strongSelf.resumeModel.matchExpList = strongSelf->matchArr;
            }
                break;
                
            default:
                break;
        }
        
        [strongSelf->resumeTable reloadData];
    };
    
    NSMutableArray *conArr = [NSMutableArray array];
    for (int i = 0; i < contents.count; i++) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        NSDictionary *dic = contents[i];
        [mDic setObject:dic[kTitle] forKey:kTitle];
        [mDic setObject:dic[kIsEnableEdit] forKey:kIsEnableEdit];
        [mDic setObject:dic[kContent] forKey:kContent];
        if (dic[kElements]) {
            [mDic setObject:dic[kElements] forKey:kElements];
        }
        
        [conArr addObject:mDic];
    }
    
    NSDictionary *tmpDic = @{
                             kTitles:conArr,
//                             kType:type?type:@""
                             };
    
    resumeBasicInfo.conDic = tmpDic;
    resumeBasicInfo.showInfoEnum = [type integerValue];
    
    [self.navigationController pushViewController:resumeBasicInfo animated:YES];
}
# pragma mark -- 查看简历
- (void)browseResume {
    ResumeDetailViewController *detail = [[ResumeDetailViewController alloc] init];
    detail.resumeEnum = BrowseOwnResume;
    detail.resumeId = self.resumeModel.id;
    [self.navigationController pushViewController:detail animated:YES];
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
