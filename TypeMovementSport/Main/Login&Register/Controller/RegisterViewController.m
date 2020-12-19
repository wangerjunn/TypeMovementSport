//
//  RegisterViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/24.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebViewController.h"

//model
#import "UserModel.h"

static int countdown = 60;

@interface RegisterViewController () <UITextFieldDelegate>
{
    UITextField *userField;//手机号
    UITextField *passwordField;//密码
    UITextField *verifiCodeField;//邀请码
    UILabel *getVerifiCodeLabel;//倒计时
    UITextField *inviterField;//邀请人
    BOOL isAgreeProtocol;//是否同意协议
    UIImageView *protocolStatusIcon;//协议状态
    NSTimer *_timer;//定时器
    UITapGestureRecognizer *tap;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    [self.view addSubview:self.mainScrollView];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    
    CGSize size = [@"验证码" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(K_TEXT_FONT_14),NSFontAttributeName,nil]];
    
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width;
    UILabel *accountTitleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
    accountTitleLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(40), 45, JGlabelContentWidth, 14);
    accountTitleLabel.text = @"手机";
    [self.mainScrollView addSubview:accountTitleLabel];
    
    userField = [[UITextField alloc] initWithFrame:CGRectMake(accountTitleLabel.right + 11.5, accountTitleLabel.y - 4, kScreenWidth - accountTitleLabel.right - 11.5, 22)];
    userField.textColor = k46Color;
    userField.font = Font(14);
    userField.maxCharLength = 11;
    userField.keyboardType = UIKeyboardTypeNumberPad;
    userField.placeholder = @"中国大陆11位手机号";
    [self.mainScrollView addSubview:userField];
    
    UIView *laneOne = [[UIView alloc] initWithFrame:CGRectMake(accountTitleLabel.left - 2, accountTitleLabel.bottom + 8, kScreenWidth - accountTitleLabel.left - FIT_SCREEN_WIDTH(43) + 2, 0.5)];
    laneOne.backgroundColor = LaneCOLOR;
    [self.mainScrollView addSubview:laneOne];
    
    UILabel *passwordLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
    passwordLabel.frame = CGRectMake(accountTitleLabel.left, laneOne.top + FIT_SCREEN_HEIGHT(35), JGlabelContentWidth, 14);
    passwordLabel.text = @"密码";
    [self.mainScrollView addSubview:passwordLabel];
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(userField.x, passwordLabel.top - 4, userField.width, 22)];
    passwordField.textColor = k46Color;
    passwordField.font = Font(K_TEXT_FONT_14);
    passwordField.maxCharLength = 16;
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    passwordField.placeholder = @"6-16位字符，区分大小写";
    [self.mainScrollView addSubview:passwordField];
    
    UIView *laneTwo = [[UIView alloc] initWithFrame:CGRectMake(laneOne.left, passwordLabel.bottom + 8, laneOne.width, laneOne.height)];
    laneTwo.backgroundColor = LaneCOLOR;
    [self.mainScrollView addSubview:laneTwo];
    
    
    // label的内容的宽度
    UILabel *verifiCodeLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
    verifiCodeLabel.frame = CGRectMake(passwordLabel.left, laneTwo.top +  FIT_SCREEN_HEIGHT(35), JGlabelContentWidth, 14);
    verifiCodeLabel.text = @"验证码";
    [self.mainScrollView addSubview:verifiCodeLabel];
    
    getVerifiCodeLabel = [LabelTool createLableWithTextColor:[UIColor whiteColor] font:Font(K_TEXT_FONT_12*proportation)];
    getVerifiCodeLabel.frame = CGRectMake(laneTwo.right-FIT_SCREEN_WIDTH(80), verifiCodeLabel.bottom - FIT_SCREEN_HEIGHT(25), FIT_SCREEN_WIDTH(80), FIT_SCREEN_HEIGHT(25));
    getVerifiCodeLabel.backgroundColor = kOrangeColor;
    getVerifiCodeLabel.textAlignment = NSTextAlignmentCenter;
    getVerifiCodeLabel.text = @"获取验证码";
    [getVerifiCodeLabel setCornerRadius:12.5];
    [self.mainScrollView addSubview:getVerifiCodeLabel];
    getVerifiCodeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_getVertifiCode = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(getVertifiCode)];
    [getVerifiCodeLabel addGestureRecognizer:tap_getVertifiCode];
    
    verifiCodeField = [[UITextField alloc] initWithFrame:CGRectMake(passwordField.left,
                                                                    verifiCodeLabel.top,
                                                                    getVerifiCodeLabel.left - verifiCodeLabel.right,
                                                                    verifiCodeLabel.height)];
    verifiCodeField.textColor = k46Color;
    verifiCodeField.textAlignment = NSTextAlignmentLeft;
    verifiCodeField.font = Font(K_TEXT_FONT_14);
    verifiCodeField.delegate = self;
    verifiCodeField.placeholder = @"输入4位验证码";
    verifiCodeField.maxCharLength = 4;
    [self.mainScrollView addSubview:verifiCodeField];
    
    UIView *laneThree = [[UIView alloc] initWithFrame:CGRectMake(laneTwo.left, verifiCodeLabel.bottom + 8,  laneTwo.width, laneTwo.height)];
    laneThree.backgroundColor = LaneCOLOR;
    [self.view addSubview:laneThree];
    
    //找回密码
    if (self.isFoundPaddword) {
        userField.placeholder = @"请输入手机号";
        passwordLabel.text = @"新密码";
        
        UIImageView *foundPsdImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -  262)/2.0, laneThree.y + 135, 262, 85)];
        foundPsdImg.image = [UIImage imageNamed:@"general_confirm"];
        [self.mainScrollView addSubview:foundPsdImg];
        foundPsdImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_register = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setNewPassword)];
        [foundPsdImg addGestureRecognizer:tap_register];
        
    }else{
        UILabel *inviterLabel = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
        inviterLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(40), laneThree.y + FIT_SCREEN_HEIGHT(35), JGlabelContentWidth, 14);
        inviterLabel.text = @"邀请人";
        [self.mainScrollView addSubview:inviterLabel];
        
        inviterField = [[UITextField alloc] initWithFrame:CGRectMake(verifiCodeField.left, inviterLabel.y - 4, passwordField.width  , 22)];
        inviterField.textColor = k46Color;
        inviterField.textAlignment = NSTextAlignmentLeft;
        inviterField.font = Font(K_TEXT_FONT_14);
        inviterField.delegate = self;
        inviterField.placeholder = @"输入邀请人账号，没有不填";
        [self.mainScrollView addSubview:inviterField];
        
        UIView *laneFour = [[UIView alloc] initWithFrame:CGRectMake(laneThree.left, inviterLabel.bottom + 8, laneThree.width, laneThree.height)];
        laneFour.backgroundColor = LaneCOLOR;
        [self.mainScrollView addSubview:laneFour];
        
        CGSize size9 = [@"阅读并同意《型动用户协议》" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(K_TEXT_FONT_12),NSFontAttributeName,nil]];
        // label的内容的宽度
        CGFloat JGlabelContentWidth9 = size9.width;
        UILabel* protocolLabel = [LabelTool createLableWithTextColor:kOrangeColor font:Font(K_TEXT_FONT_12)];
        protocolLabel.frame = CGRectMake(kScreenWidth - JGlabelContentWidth9 - FIT_SCREEN_WIDTH(40) - 2, laneFour.y + FIT_SCREEN_HEIGHT(31), JGlabelContentWidth9, 13);
        protocolLabel.text = @"阅读并同意《型动用户协议》";
        [self.mainScrollView addSubview:protocolLabel];
        protocolLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_proCon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browseProtocolContent)];
        [protocolLabel addGestureRecognizer:tap_proCon];
        
        protocolStatusIcon = [[UIImageView alloc] initWithFrame:CGRectMake(protocolLabel.left - 13 - 8, protocolLabel.y, 14, 14)];
        protocolStatusIcon.image = [UIImage imageNamed:@"btn_no_select"];
        [self.mainScrollView addSubview:protocolStatusIcon];
        
        UIButton *seleBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - JGlabelContentWidth9 - FIT_SCREEN_WIDTH(40) - 2 - 80, protocolStatusIcon.y, 80, 30)];
        [self.mainScrollView addSubview:seleBtn];
        [seleBtn addTarget:self action:@selector(isAgreeProtocol) forControlEvents:UIControlEventTouchDown];
        
        
        UIImageView *registerImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -  FIT_SCREEN_WIDTH(262))/2.0, laneFour.y + 135, 262, 85)];
        registerImg.image = [UIImage imageNamed:@"LR_register"];
        [self.mainScrollView addSubview:registerImg];
        registerImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_register = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerNewUser)];
        [registerImg addGestureRecognizer:tap_register];
        
        UILabel *titLab = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_12)];
        titLab.frame = CGRectMake(registerImg.x - 8, registerImg.y + registerImg.height + 6, registerImg.width - 8, 30);
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.text = @"您的手机号码仅限于登录，我们不会在任何地方泄漏您的信息";
        titLab.numberOfLines = 0;
        [self.mainScrollView addSubview:titLab];
        
        [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.width, titLab.bottom+50)];
    }
    
    [self.mainScrollView openAdjustLayoutWithKeyboard];
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        [_mainScrollView setContentSize:CGSizeMake(kScreenWidth * 3, _mainScrollView.height)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.userInteractionEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    
    return _mainScrollView;
}

# pragma mark -- 获取验证码
- (void)getVertifiCode {
    
    [self.view endEditing:YES];
    
    if (userField.text.length == 0) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"请填写手机号码" buttonTitle:nil block:nil];
        return;
    }
    if (userField.text.length < 11) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"手机号码位数错误" buttonTitle:nil block:nil];
        return;
    }
    
    TO_WEAK(self, weakSelf);
    
    [WebRequest PostWithUrlString:kSendCode parms:@{@"phone":userField.text}  viewControll:nil success:^(NSDictionary *dict, NSString *remindMsg) {
        
        TO_STRONG(weakSelf, strongSelf);
        if ([remindMsg integerValue] == 999) {
            if (!strongSelf->_timer) {
                strongSelf->_timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                      target:self
                                                                    selector:@selector(updateCountdown)
                                                                    userInfo:nil
                                                                     repeats:YES];
            }
            strongSelf->getVerifiCodeLabel.userInteractionEnabled = NO;
            strongSelf->getVerifiCodeLabel.backgroundColor = k210Color;
            [strongSelf->_timer fire];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

# pragma mark -- 浏览协议内容
- (void)browseProtocolContent{
    [self.view endEditing:YES];
    
    WebViewController *adWebVc = [[WebViewController alloc] init];
    adWebVc.httpUrl = kUserAgreement;
    adWebVc.httpTitle = @"用户协议";
    [self.navigationController pushViewController:adWebVc animated:YES];
}

# pragma mark -- 是否同意协议
- (void)isAgreeProtocol {
    [self.view endEditing:YES];
    
    isAgreeProtocol = !isAgreeProtocol;
    if (isAgreeProtocol) {
        protocolStatusIcon.image = [UIImage imageNamed:@"btn_select"];
    }else {
        protocolStatusIcon.image = [UIImage imageNamed:@"btn_no_select"];
    }
}

# pragma mark -- 注册新用户
- (void)registerNewUser {
    [self.view endEditing:YES];
    
    [self checkInfo:NO];
}

# pragma mark -- 设置新密码
- (void)setNewPassword {
    [self.view endEditing:YES];
    
    [self checkInfo:YES];
}

#pragma mark -- 更新倒计时
- (void)updateCountdown {
    countdown -= 1;
    getVerifiCodeLabel.text = [NSString stringWithFormat:@"%2d秒后获取",countdown];
    
    if (countdown == 0) {
        getVerifiCodeLabel.userInteractionEnabled = YES;
        getVerifiCodeLabel.backgroundColor = kOrangeColor;
        getVerifiCodeLabel.text = [NSString stringWithFormat:@"获取验证码"];
        countdown = 60;
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)checkInfo:(BOOL)isFoundPassword {
    if (userField.text.length == 0) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"请填写手机号码" buttonTitle:nil block:nil];
        return;
    }
    if (userField.text.length < 11) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"手机号码位数错误" buttonTitle:nil block:nil];
        return;
    }
    
    if (passwordField.text.length < 6) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"密码位数不符合要求" buttonTitle:nil block:nil];
        return;
        
    }
    
    if (verifiCodeField.text.length < 1) {
        [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"请填写手机4位验证码" buttonTitle:nil block:nil];
        return;
    }
    
    NSMutableDictionary *para = [@{
                                   @"phone":userField.text,
                                   @"pwd":passwordField.text,
                                   @"code":verifiCodeField.text
                                   } mutableCopy];
    
    if (inviterField.text.length > 0) {
        [para setObject:inviterField.text forKey:@""];
    }
    
    NSString *url = kRegisterByPhone;
    if (isFoundPassword) {
        //找回密码
        url = kUserForgetPwd;
    }else{
        //注册新用户
        if (!isAgreeProtocol) {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"未遵从协议" buttonTitle:nil block:nil];
            return;
        }
    }
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:url parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            UserModel *model = [[UserModel alloc] initWithDictionary:dict[@"user"] error:nil];
            NSDictionary *authDic = dict[@"auth"];
            model.Authorization = authDic[@"access_token"];
            model.markup = authDic[@"markup"];
            model.token_type = authDic[@"token_type"];
            model.isLogin = YES;
            
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:YES error:nil];

            UserDefaultsSet(data, kUserModel);
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            }];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.mainScrollView addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.mainScrollView removeGestureRecognizer:tap];
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
