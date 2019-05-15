//
//  CerOrRecordQueryViewController.m
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

static NSString *kTitle = @"title";
static NSString *kIsEnableEdit = @"isEnableEdit";
static NSString *kType = @"type";
static NSString *kContent = @"content";
static NSString *kTitles = @"titles";
static NSString *kElements = @"element";
static NSString *kIsMultiple = @"isMultiple";

#import "CerOrRecordQueryViewController.h"
#import "RecruitmentViewController.h"
#import "ApplyJobViewController.h"
#import "CerOrRecordQueryResultViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "ResumeBasicInfoViewController.h"

//model
#import "UserModel.h"

@interface CerOrRecordQueryViewController () <UITextFieldDelegate>{
    UITextField *nameField;
    UITextField *idCardField;
    UIButton *searchBtn;
    UILabel *nameTitleLabel;
    UILabel *psdTitleLabel;
    UITextField *phoneField;
    UILabel *vertifiCodeLabel;
    UIButton *getVertifiCodeBtn;
    NSNumber *duration;
    NSTimer *waitTimer;
    NSTimeInterval currentTime;
    int code;
    int randomNumber;
    NSString *strTime;
    
    UITextField *vertifiCodeField;
}

@end

@implementation CerOrRecordQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMyTitle:_navTitle?_navTitle:@""];
    
    [self createUI];
}

- (void)createUI{
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 20, kScreenWidth - 20, 50)];
    view1.backgroundColor = [UIColor colorWithRed:247/256.0 green:247/256.0 blue:247/256.0 alpha:1];
    view1.userInteractionEnabled = YES;
    [self.view addSubview:view1];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, view1.top, kScreenWidth - 40, view1.height)];
    nameField.placeholder = @"请输入真实姓名";
    nameField.font =Font(K_TEXT_FONT_12);
    nameField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nameField];
    nameField.delegate = self;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(view1.left, view1.bottom+20, view1.width, view1.height)];
    view2.backgroundColor = [UIColor colorWithRed:247/256.0 green:247/256.0 blue:247/256.0 alpha:1];
    view2.userInteractionEnabled = YES;
    [self.view addSubview:view2];
    idCardField = [[UITextField alloc] initWithFrame:CGRectMake(nameField.left, view2.top, nameField.width, nameField.height)];
    idCardField.textColor = [UIColor blackColor];
    idCardField.placeholder = @"点击输入身份证号";
    idCardField.maxCharLength = 18;
//    idCardField.secureTextEntry = YES;
    idCardField.keyboardType = UIKeyboardTypeASCIICapable;
    idCardField.font = Font(K_TEXT_FONT_12);
    idCardField.delegate = self;
    idCardField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:idCardField];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(view2.left, view2.bottom+20, view2.width, view2.height)];
    view3.backgroundColor = [UIColor colorWithRed:247/256.0 green:247/256.0 blue:247/256.0 alpha:1];
    view3.userInteractionEnabled = YES;
    [self.view addSubview:view3];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(idCardField.left, view3.top, idCardField.width, idCardField.height)];
    phoneField.textColor = [UIColor blackColor];
    phoneField.placeholder = @"请输入手机号";
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.font = Font(K_TEXT_FONT_12);
    phoneField.maxCharLength = 11;
    phoneField.delegate = self;
    phoneField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:phoneField];
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(view3.left, view3.bottom+20, view3.width, view3.height)];
    view5.backgroundColor = [UIColor colorWithRed:247/256.0 green:247/256.0 blue:247/256.0 alpha:1];
    view5.userInteractionEnabled = YES;
    [self.view addSubview:view5];
    
    vertifiCodeField = [[UITextField alloc] initWithFrame:CGRectMake(phoneField.left, view5.top, phoneField.width, phoneField.height)];
    vertifiCodeField.textColor = [UIColor blackColor];
    vertifiCodeField.placeholder = @"输入验证码";
    vertifiCodeField.keyboardType = UIKeyboardTypeASCIICapable;
    vertifiCodeField.font = Font(K_TEXT_FONT_12);
    vertifiCodeField.delegate = self;
    vertifiCodeField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:vertifiCodeField];
    
    //线
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(20 + kScreenWidth - 140, 240, 1, 30)];
    view4.backgroundColor = [UIColor colorWithRed:204/256.0 green:204/256.0 blue:204/256.0 alpha:1];
    [self.view addSubview:view4];
    getVertifiCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(view4.left + 12.5, view4.top, 85, 30)];
    getVertifiCodeBtn.backgroundColor = [UIColor colorWithRed:255/256.0 green:107/256.0 blue:0 alpha:1];
    getVertifiCodeBtn.titleLabel.font = Font(K_TEXT_FONT_12);
    [getVertifiCodeBtn setCornerRadius:2];
    [getVertifiCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVertifiCodeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlState)UIControlStateNormal];
    [getVertifiCodeBtn addTarget:self action:@selector(getVertifiCode) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:getVertifiCodeBtn];
    vertifiCodeLabel = [[UILabel alloc] initWithFrame:getVertifiCodeBtn.frame];
    vertifiCodeLabel.textColor = [UIColor whiteColor];
    vertifiCodeLabel.backgroundColor = [UIColor clearColor];
    vertifiCodeLabel.textAlignment = NSTextAlignmentCenter;
    vertifiCodeLabel.font = Font(K_TEXT_FONT_12);
    [self.view addSubview:vertifiCodeLabel];
    searchBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 63) / 2.0, vertifiCodeField.bottom+ 29, 63, 63)];
    [searchBtn addTarget:self action:@selector(searchView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:searchBtn];
    UIImageView *Imgview = [[UIImageView alloc] initWithFrame:searchBtn.frame];
    Imgview.image = [UIImage imageNamed:@"HP_cer_query"];
    
    [self.view addSubview:Imgview];
    
    UIView *lane1One = [[UIView alloc] initWithFrame:CGRectMake(10, searchBtn.bottom + 19 + 10, 127.5, 1)];
    lane1One.backgroundColor = LaneCOLOR;
    [self.view addSubview:lane1One];
    
    UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, searchBtn.bottom + 19 + 5, kScreenWidth, 10)];
    recommendLabel.textColor = k210Color;
    recommendLabel.text = @"更多功能推荐";
    recommendLabel.textAlignment = NSTextAlignmentCenter;
    recommendLabel.font = Font(K_TEXT_FONT_10);
    [self.view addSubview:recommendLabel];
    
    UIView *lane2One = [[UIView alloc] initWithFrame:CGRectMake(recommendLabel.width - 10 - 127.5, searchBtn.bottom + 19 + 10, 127.5, 1)];
    lane2One.backgroundColor = LaneCOLOR;
    [self.view addSubview:lane2One];
    
    UILabel *recruimentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 280 - 30)/2.0, recommendLabel.bottom + 30, 140, 40)];
    recruimentLabel.text = @"去招聘";
    recruimentLabel.textAlignment = NSTextAlignmentCenter;
    recruimentLabel.layer.cornerRadius = 20;
    recruimentLabel.textColor = k46Color;
    recruimentLabel.font = Font(13);
    recruimentLabel.layer.masksToBounds = YES;
    recruimentLabel.layer.borderWidth = 1;
    recruimentLabel.layer.borderColor = k46Color.CGColor;
    [self.view addSubview:recruimentLabel];
    recruimentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toRecruit)];
    [recruimentLabel addGestureRecognizer:tap];
    
    UILabel *applyJobLabel = [[UILabel alloc] initWithFrame:CGRectMake(recruimentLabel.x+recruimentLabel.width + 30, recommendLabel.bottom + 30, 140, 40)];
    applyJobLabel.text = @"去求职";
    applyJobLabel.textAlignment = NSTextAlignmentCenter;
    applyJobLabel.layer.cornerRadius = 20;
    applyJobLabel.textColor = k46Color;
    applyJobLabel.font = Font(13);
    applyJobLabel.layer.masksToBounds = YES;
    applyJobLabel.layer.borderWidth = 1;
    applyJobLabel.layer.borderColor = k46Color.CGColor;
    [self.view addSubview:applyJobLabel];
    applyJobLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toApplyJob)];
    [applyJobLabel addGestureRecognizer:tap1];
    [self.view openAdjustLayoutWithKeyboard];
}

#pragma mark -- 我要招聘
- (void)toRecruit {
    
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

#pragma mark -- 我要求职
- (void)toApplyJob{
    [MobClick event:@"我要求职"]; //友盟统计
    ApplyJobViewController *applyJob = [[ApplyJobViewController alloc] init];
    applyJob.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:applyJob animated:YES];
}

#pragma mark -- 获取验证码
- (void)getVertifiCode {
    
    [self.view resignFirstResponder];
    [self.view endEditing:YES];
    if(phoneField.text.length != 11){
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"手机号码不正确" buttonTitle:nil block:nil];
        return;
    }
}


#pragma mark -- 去登录
- (void)displayLoginView {
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
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


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing: YES];
}

#pragma mark -- 查询结果
- (void)searchView{
    [self.view endEditing:YES];
    
    
//    nameField.text = @"王立石";
//    phoneField.text = @"17600901695";
//    idCardField.text = @"110101195302082559";
    if (nameField.text.length == 0) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"请输入姓名" buttonTitle:nil block:nil];
        return;
    }
    if (idCardField.text.length == 0 || idCardField.text.length < 18) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"请输入身份证号" buttonTitle:nil block:nil];
        
        return;
    }
    if (vertifiCodeField.text.length == 0) {
         [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"请输入验证码" buttonTitle:nil block:nil];
        return;
    }
   
    [self cerOrRecordQurayInterface];
}

- (void)updateTimer {
    
    __block NSInteger time = 59;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    TO_WEAK(self, weakSelf);
    dispatch_source_set_event_handler(_timer, ^{
        
        TO_STRONG(weakSelf, strongSelf);
        if(time <= 0){
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                strongSelf->vertifiCodeLabel.hidden = YES;
                [strongSelf->getVertifiCodeBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
                
                strongSelf->getVertifiCodeBtn.userInteractionEnabled = YES;
                strongSelf->phoneField.enabled = YES;
                
            });
            
        }else{
            
            int seconds = time % 60;
            strongSelf->strTime = [NSString stringWithFormat:@"%d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf->vertifiCodeLabel.hidden = NO;
                
                strongSelf->vertifiCodeLabel.text =[NSString stringWithFormat:@"%2d秒后获取",[strongSelf->strTime intValue] ];
                [strongSelf->getVertifiCodeBtn setTitle:@"" forState:UIControlStateNormal];
                
                strongSelf->getVertifiCodeBtn.userInteractionEnabled = NO;
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
    
}

#pragma mark -- 证书，成绩查询
- (void)cerOrRecordQurayInterface {
    
    
    NSDictionary *para = @{
                           @"name":nameField.text,
                           @"cardNo":idCardField.text,
                           @"phone":phoneField.text,
                           @"code":vertifiCodeField.text
                           };
    
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kOutsideConnectQuery parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            
            TO_STRONG(weakSelf, strongSelf);
            NSDictionary *detailDic = dict[@"detail"];
            /*
             certList =             (
             {
             birthdate = "1953-02-08";
             cardNo = "<null>";
             certdate = "2006-11-28";
             certno = 0664003001500265;
             gender = "男";
             llscore = 60;
             name = "王立石";
             result = "合格";
             scscore = 70;
             zhiyedengji = "社会体育指导员（游泳）五级";
             },
             {
             birthdate = "1953-02-08";
             cardNo = "<null>";
             certdate = "2011-12-30";
             certno = 1164003001400151;
             gender = "男";
             llscore = 63;
             name = "王立石";
             result = "合格";
             scscore = 74;
             zhiyedengji = "游泳救生员四级";
             }
             );
             scoreList =             (
             {
             birthdate = "1953-02-08";
             cardNo = "<null>";
             gender = "男";
             llscore = 63;
             name = "<null>";
             result = "合格";
             scscore = 74;
             zhiyedengji = "游泳救生员四级";
             },
             {
             birthdate = "1953-02-08";
             cardNo = "<null>";
             gender = "男";
             llscore = 60;
             name = "<null>";
             result = "合格";
             scscore = 70;
             zhiyedengji = "社会体育指导员（游泳）五级";
             }
             );
             */
            NSArray *certList = detailDic[@"certList"];
            NSArray *scoreList = detailDic[@"scoreList"];
            CerOrRecordQueryResultViewController *result = [[CerOrRecordQueryResultViewController alloc] init];
            result.certList = certList;
            result.scoreList = scoreList;
            result.name = strongSelf->nameField.text;
            [weakSelf.navigationController pushViewController:result animated:YES];
            
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
