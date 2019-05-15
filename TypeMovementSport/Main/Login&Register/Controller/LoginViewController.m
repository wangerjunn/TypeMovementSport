//
//  LoginViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/24.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "WXApi.h"
#import <UMengUShare/WeiboSDK.h>

#import "KeyChainStore.h"

//model
#import "UserModel.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    UITextField *userField;
    UITextField *passwordField;
    UITapGestureRecognizer *tap;
    AppDelegate *_appdelegate;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation LoginViewController

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    [self.view addSubview:self.mainScrollView];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    
    CGFloat wdtIconImg = 71;
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - wdtIconImg)/2.0, FIT_SCREEN_HEIGHT(4), wdtIconImg,  89)];
    iconImg.image = [UIImage imageNamed:@"LR_icon"];
    [self.mainScrollView addSubview:iconImg];
    
    UILabel *titleLab = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_12)];
    titleLab.frame = CGRectMake(0, iconImg.bottom +10, kScreenWidth, 12);
    titleLab.text = @"型动汇账号登陆";
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.mainScrollView addSubview:titleLab];
    
    CGSize size = [@"账号" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(K_TEXT_FONT_14),NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth = size.width;
    UILabel *accountTitleLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
    accountTitleLabel.frame = CGRectMake(FIT_SCREEN_WIDTH(40), titleLab.bottom+20, JGlabelContentWidth, 14);
    accountTitleLabel.text = @"账号";
    [self.mainScrollView addSubview:accountTitleLabel];
    
    userField = [[UITextField alloc] initWithFrame:CGRectMake(accountTitleLabel.right + 11.5, accountTitleLabel.y - 4, kScreenWidth - accountTitleLabel.right - 11.5, 22)];
    userField.textColor = k46Color;
    userField.font = Font(14);
    userField.maxCharLength = 11;
    userField.delegate = self;
    userField.keyboardType = UIKeyboardTypeNumberPad;
    userField.placeholder = @"输入手机号";
    [self.mainScrollView addSubview:userField];
    
    UIView *laneOne = [[UIView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(40) - 2, accountTitleLabel.bottom + 8, kScreenWidth - FIT_SCREEN_WIDTH(40) - FIT_SCREEN_WIDTH(43) + 2, 0.5)];
    laneOne.backgroundColor = LaneCOLOR;
    [self.mainScrollView addSubview:laneOne];
    
    UILabel *passwordLabel = [LabelTool createLableWithTextColor:k75Color font:Font(K_TEXT_FONT_14)];
    passwordLabel.frame = CGRectMake(accountTitleLabel.left, laneOne.y + FIT_SCREEN_HEIGHT(35), JGlabelContentWidth, 14);
    passwordLabel.text = @"密码";
    [self.mainScrollView addSubview:passwordLabel];
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(userField.left, passwordLabel.top - 4, userField.width, 22)];
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
    
    CGSize size1 = [@"忘记密码?" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(12),NSFontAttributeName,nil]];
    // label的内容的宽度
    CGFloat JGlabelContentWidth1 = size1.width;
    
    UILabel *forgetPsdLabel = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_12)];
    forgetPsdLabel.frame = CGRectMake(kScreenWidth - FIT_SCREEN_WIDTH(43) - JGlabelContentWidth1, laneTwo.y + 16, JGlabelContentWidth1, 13);
    forgetPsdLabel.text = @"忘记密码?";
    [self.mainScrollView addSubview:forgetPsdLabel];
    forgetPsdLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_fogetPsd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetPassword)];
    [forgetPsdLabel addGestureRecognizer:tap_fogetPsd];
    
    CGFloat distanceBtn = (kScreenWidth - 130 - 142)/3.0;
    UIButton *registerBtn = [ButtonTool createButtonWithTitle:@"注册"
                                                   titleColor:k46Color
                                                    titleFont:Font(K_TEXT_FONT_14)
                                                    addTarget:self
                                                       action:@selector(registerNewUser)];
    registerBtn.frame = CGRectMake(distanceBtn, FIT_SCREEN_HEIGHT(68) + laneTwo.top, 130, 45);
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = registerBtn.height/2.0;
    registerBtn.layer.borderWidth = 1;
    registerBtn.layer.borderColor = k46Color.CGColor;
    
    [self.mainScrollView addSubview:registerBtn];

    //登录
    UIImageView *loginImg = [[UIImageView alloc] initWithFrame:CGRectMake(registerBtn.right+distanceBtn, registerBtn.top, 142, 85)];
    loginImg.image = [UIImage imageNamed:@"LR_login"];
    [self.mainScrollView addSubview:loginImg];
    loginImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_login = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(login)];
    [loginImg addGestureRecognizer:tap_login];
    
    //游客登录
    UIImageView *visitorImg = [[UIImageView alloc] initWithFrame:CGRectMake(FIT_SCREEN_WIDTH(40), loginImg.bottom + 40, FIT_SCREEN_WIDTH(292), FIT_SCREEN_HEIGHT(45))];
    visitorImg.image = [UIImage imageNamed:@"LR_visitor"];
//    [self.mainScrollView addSubview:visitorImg];
    visitorImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_visitor = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(visitorLogin)];
    [visitorImg addGestureRecognizer:tap_visitor];
    
    UILabel *otherLoginWayLabel = [LabelTool createLableWithTextColor:k210Color font:Font(K_TEXT_FONT_12)];
    otherLoginWayLabel.frame = CGRectMake(0, visitorImg.bottom+FIT_SCREEN_HEIGHT(20), kScreenWidth, 12);
    otherLoginWayLabel.text = @"其他登录方式";
    otherLoginWayLabel.textAlignment = NSTextAlignmentCenter;
//    [self.mainScrollView addSubview:otherLoginWayLabel];
    
    UIImageView *wxImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 39*2-84)/2.0, otherLoginWayLabel.bottom+FIT_SCREEN_HEIGHT(30), 39, 38)];
    wxImg.image = [UIImage imageNamed:@"LR_wx"];
    [self.mainScrollView addSubview: wxImg];
    wxImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_wxLogin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wxLogin)];
    [wxImg addGestureRecognizer:tap_wxLogin];
    
    UIImageView *wbImg = [[UIImageView alloc] initWithFrame:CGRectMake(wxImg.right+84, wxImg.top, wxImg.width, wxImg.height)];
    wbImg.image = [UIImage imageNamed:@"LR_wb"];
    [self.mainScrollView addSubview: wbImg];
    wbImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_wbLogin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wbLogin)];
    [wbImg addGestureRecognizer:tap_wbLogin];
    
    
    
    //苹果审核时如果未安装相应app，依然显示相应的第三方登录会被拒
//    if ( ![WXApi isWXAppInstalled]) {
        wxImg.hidden = YES;
//    }
    
// if(![WeiboSDK isWeiboAppInstalled]){
        wbImg.hidden = YES;
//    }
    
    userField.delegate = self;
    passwordField.delegate = self;
    userField.tag = 101;
    passwordField.tag = 102;
    
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.width, wxImg.bottom+50);
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

# pragma mark -- 忘记密码
- (void)forgetPassword {
    RegisterViewController *registerVc = [[RegisterViewController alloc]init];
    registerVc.isFoundPaddword = YES;
    [self.navigationController pushViewController:registerVc animated:YES];
}

# pragma mark -- 注册新用户
- (void)registerNewUser {
    RegisterViewController *registerVc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

# pragma mark -- 登录
- (void)login {
    
    [self.view endEditing:YES];
    
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
    
    NSString *uuidStr = [KeyChainStore getUUID];
    NSDictionary *para = @{
                           @"phone":userField.text,
                           @"pwd":passwordField.text,
                           @"imei":uuidStr?uuidStr:@""
                           };
    
    [WebRequest PostWithUrlString:kLoginByPhone parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            UserModel *model = [[UserModel alloc] initWithDictionary:dict[@"user"] error:nil];
            NSDictionary *authDic = dict[@"auth"];
            model.Authorization = authDic[@"access_token"];
            model.markup = authDic[@"markup"];
            model.token_type = authDic[@"token_type"];
            model.isLogin = YES;
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            [userDefault setObject:data forKey:kUserModel];
            [userDefault synchronize];
           
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            }];
        }else{
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
}

# pragma mark -- 微信登录
- (void)wxLogin {
    [self.view endEditing:YES];
    SendAuthReq* req = [[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.openID = WEICHAT_APPID ;
    if (!_appdelegate) {
        _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    _appdelegate.WXCallBackResultBlock = ^(BaseResp *resp) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        if(temp.errCode == 0) {
           //授权成功
//            temp.code
        }
    };
    
    [WXApi sendReq:req];
}

# pragma mark -- 微博登录
- (void)wbLogin {
    [self.view endEditing:YES];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
    
    if (!_appdelegate) {
        _appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    _appdelegate.SinaWBCallBackResultBlock = ^(WBBaseResponse *response) {
        if ([response isKindOfClass:WBAuthorizeResponse.class]) {
            WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
            if ((int)response.statusCode == 0) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:authResp.userInfo];
                NSLog(@"%@",userInfo);
            }
            /**
             认证口令
             */
//            @property (nonatomic, strong) NSString *accessToken;
            
            /**
             认证过期时间
             */
//            @property (nonatomic, strong) NSDate *expirationDate;
            
            /**
             当认证口令过期时用于换取认证口令的更新口令
             */
//            @property (nonatomic, strong) NSString *refreshToken;
        }
        
    };

}

# pragma mark -- 游客登录
- (void)visitorLogin {
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
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
