//
//  VersionInfoViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "VersionInfoViewController.h"
#import "WebViewController.h"

@interface VersionInfoViewController ()

@end

@implementation VersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyTitle:@"版本信息"];
    
    [self createUI];
}

- (void)createUI {
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 -52, 40, 104, 104)];
    
    UIImageView *views = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 -52, 40, 104, 104)];
    
    views.image = [UIImage imageNamed:@"icon1024"];
    [self.view addSubview:views];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imgView.frame.origin.y + 114, kScreenWidth - 40, 12)];
    titleLabel.text = @"型动汇";
    titleLabel.font = Font(K_TEXT_FONT_12);
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y + 22, kScreenWidth - 40, 12)];
    versionLabel.text = [NSString stringWithFormat:@"版本号: %@", kVersion];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = Font(K_TEXT_FONT_12);
    versionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.view addSubview:versionLabel];
    
    CGSize rect =[UITool sizeOfStr:@"用户协议" andFont:Font(K_TEXT_FONT_12) andMaxSize:CGSizeMake(kScreenWidth, MAXFLOAT) andLineBreakMode:NSLineBreakByClipping];
    
    UILabel *peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, versionLabel.frame.origin.y + 22, kScreenWidth - 40, 12)];
    peopleLabel.text = @"用户协议";
    peopleLabel.textColor = [UIColor colorWithHexString:@"1e68e3"];
    peopleLabel.textAlignment = NSTextAlignmentCenter;
    peopleLabel.font = Font(12);
    peopleLabel.userInteractionEnabled = YES;
    [self.view addSubview:peopleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementAction)];
    [peopleLabel addGestureRecognizer:tap];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - rect.width / 2, peopleLabel.frame.origin.y + 12, rect.width, 1)];
    
    line2.backgroundColor = [UIColor colorWithHexString:@"1e68e3"];
    
    [self.view addSubview:line2];
    UIButton *quitLog = [UIButton buttonWithType:UIButtonTypeCustom];
    quitLog.frame = CGRectMake(0, kScreenHeight - kNavigationBarHeight-50, kScreenWidth, 50);
    quitLog.backgroundColor = [UIColor colorWithRed:255/256.0 green:107/256.0 blue:0 alpha:1];
    [quitLog setTitle:@"检测更新" forState:UIControlStateNormal];
    [quitLog setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:quitLog];
    [quitLog addTarget:self action:@selector(checkVersionUpdate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)agreementAction {
    
    NSLog(@"用户协议");
    WebViewController *adWebVc = [[WebViewController alloc] init];
    adWebVc.httpUrl = kUserAgreement;
    adWebVc.httpTitle = @"用户协议";
    [self.navigationController pushViewController:adWebVc animated:YES];
    
}

#pragma mark -- 更新app
- (void)updateApp:(NSString *)updateUrl {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:updateUrl]]) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
    }
}

#pragma mark -- 版本更新
- (void)checkVersionUpdate {
    NSDictionary *para = @{
                           @"versionNum":kVersion,
                           @"type":kFrom
                           };
    
    TO_WEAK(self, weakSelf);
    [WebRequest PostWithUrlString:kVersionUpdate parms:para viewControll:self success:^(NSDictionary *dict, NSString *remindMsg) {
        if ([remindMsg integerValue] == 999) {
            /*
             detail =         {
                 remark = "";
                     tips =             {
                     remark = "提示信息";
                     type = "1:无更新, 2:非强制更新, 3:强制更新";
                     updateUrl = "下载地址";
                     versionNum = "最新的版本号";
                 };
                 type = 1;
                 updateUrl = "";
                 versionNum = "";
             };
             */
            
            NSDictionary *detailDict = dict[@"detail"];
//            NSString *versionNum = detailDict[@"versionNum"];
            NSString *updateUrl = detailDict[@"updateUrl"];
            NSString *remark = detailDict[@"remark"];
            
            switch ([detailDict[@"type"] integerValue]) {
                case 1:{
//                    NSString *content = @"已经是最新的版本啦~~~~";
                     [[CustomAlertView shareCustomAlertView] showTitle:nil content:remark buttonTitle:nil block:nil];
                }
                    break;
                case 2:{
                    //非强制更新
                    [[CustomAlertView shareCustomAlertView] showTitle:nil content:remark leftButtonTitle:nil rightButtonTitle:@"去更新" block:^(NSInteger index) {
                        if (index == 1) {
                            [weakSelf updateApp:updateUrl];
                        }
                    }];
                }
                    break;
                case 3:{
                    //强制更新
                    [[CustomAlertView shareCustomAlertView] showTitle:nil content:remark buttonTitle:@"更新" block:^(NSInteger index) {
                        [weakSelf updateApp:updateUrl];
                    }];
                }
                    break;
                default:
                    break;
            }
            
        }else {
            [[CustomAlertView shareCustomAlertView] showTitle:nil content:dict[kMessage] buttonTitle:nil block:nil];
        }
    } failed:^(NSError *error) {
        
    }];
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
