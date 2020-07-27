//
//  SettingViewController.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "SettingViewController.h"
#import "VersionInfoViewController.h"
#import "BaseNavigationViewController.h"
#import "LoginViewController.h"
#import "TabbarViewController.h"
#import "DevelopmentViewController.h"
#import <HyphenateLite/HyphenateLite.h>
#import <Photos/PHPhotoLibrary.h>//相册权限
#import <SDWebImage/SDImageCache.h>

@interface SettingViewController () <
    UIAlertViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource> {
        UITableView *settingTable;
}
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setMyTitle:@"设置"];
    
    [self createUI];
}

- (void)createUI {
    
    UIButton *logOutBtn = [ButtonTool createButtonWithTitle:@"退出登录"
                                                 titleColor:[UIColor whiteColor]
                                                  titleFont:Font(16)
                                                  addTarget:self
                                                     action:@selector(logoutAccount)];
    logOutBtn.frame = CGRectMake(0, kScreenHeight-kNavigationBarHeight-50, kScreenWidth, 50);
    logOutBtn.backgroundColor = kOrangeColor;
    [self.view addSubview:logOutBtn];
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(enterIntoDevelopmentEnvironment)];
    longPressGesture.minimumPressDuration = 5;
    [logOutBtn addGestureRecognizer:longPressGesture];
    
    settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, logOutBtn.top) style:UITableViewStyleGrouped];
    settingTable.delegate = self;
    settingTable.dataSource = self;
//    settingTable.bounces = NO;
    if (@available(iOS 11.0,*)) {
        settingTable.estimatedRowHeight = 0;
        settingTable.estimatedSectionHeaderHeight = 0;
        settingTable.estimatedSectionFooterHeight = 0;
        settingTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:settingTable];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    UILabel *label = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_14)];
    label.frame = CGRectMake(15, 0, headerView.width-20, headerView.height);
    if (section == 0) {
        label.text = @"偏好";
    }else{
        label.text = @"支持";
    }
    [headerView addSubview:label];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [LabelTool createLableWithTextColor:k46Color font:Font(K_TEXT_FONT_16)];
        label.tag = 100;
        label.frame = CGRectMake(25, 0, kScreenWidth-105, 50);
        [cell.contentView addSubview:label];
        CGFloat hgt_sw = 31;
        UISwitch *sw = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-51-25, (45-hgt_sw)/2.0, 51, hgt_sw)];
        sw.tag = 101;
        sw.onTintColor = kOrangeColor;
        sw.hidden = YES;
        [cell.contentView addSubview:sw];
        
        [sw addTarget:self action:@selector(changeSwitachStatus:) forControlEvents:UIControlEventValueChanged];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    UISwitch *sw = (UISwitch*)[cell.contentView viewWithTag:101];
    
    label.text = @"";
    sw.hidden = YES;
    if (indexPath.section == 0) {
        sw.hidden = NO;
        if (indexPath.row == 0) {
            label.text = @"保存相册";
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusAuthorized) {
                //已授权
                 [sw setOn:YES];
            }else{
                //无权限
                 [sw setOn:NO];
            }
        } else {
            label.text = @"开启推送";
            BOOL result = [self isAllowedNotification];
            if (result == YES) {
                [sw setOn:YES];
            }else {
                [sw setOn:NO];
            }
        }
    } else {
        
        
        if (indexPath.row == 0) {
            label.text = @"版本信息";
        } else if (indexPath.row == 1) {
            CGFloat size = (CGFloat)[[SDImageCache sharedImageCache] getSize]/1024/1024;
            NSString *tmp =[NSString stringWithFormat:@"%f",size];
            label.text = [NSString stringWithFormat:@"清除缓存(%@MB)",[tmp substringWithRange:NSMakeRange(0,4)]];
        } else {
            label.text = @"联系客服";
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //保存相册
        }else {
            //开启推送
        }
    }else{
        switch (indexPath.row) {
            case 0: {
                //版本信息
                VersionInfoViewController *versionInfo = [[VersionInfoViewController alloc] init];
                [self.navigationController pushViewController:versionInfo animated:YES];
            }
                break;
            case 1: {
                //清楚缓存
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    //清楚缓存成功回调
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
                break;
            case 2: {
                //联系客服
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"客服电话" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"15001338854", nil];
//                [alert show];
//                return;
//                [[CustomAlertView shareCustomAlertView] showTitle:@"客服电话" content:kServiceTele leftButtonTitle:@"呼叫" rightButtonTitle:@"取消" block:^(NSInteger index) {
//                    if (index == 0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"15001338854"]]];
//                    }
//                }];
            }
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"%ld",(long)buttonIndex);
    
    NSString *tele = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"%@", tele);
    if (buttonIndex != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tele]]];
    }
}

# pragma mark -- 更改开关状态
- (void)changeSwitachStatus:(UISwitch *)sw {
    
    UITableViewCell *cell = sw.superview.tableviewCell;
    
    if (cell) {
        NSIndexPath *indexPath = [settingTable indexPathForCell:cell];
        
        if (indexPath.row == 1) {
            //推送设置
            if (sw.isOn) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ispush"];
            }else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispush"];
            }
        }else{
            //保存相册
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusAuthorized) {
                //已授权
            }
        }
        
        //打开权限设置
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
}

# pragma mark -- 退出登录
- (void)logoutAccount {
    
    TO_WEAK(self, weakSelf);
    [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"是否退出当前账号" leftButtonTitle:@"是" rightButtonTitle:@"否" block:^(NSInteger index) {
        if (index == 0) {
            [Tools clearLoginData];
            
//            TabbarViewController *tabbar = (TabbarViewController *)self.tabBarController;
//            tabbar.selectedIndex = 2;
            [weakSelf.navigationController.tabBarController setSelectedIndex:2];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)isAllowedNotification {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
    //
    //#else
    //    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    //
    //    if(UIRemoteNotificationTypeNone != type)
    //        return YES;
    //#endif
    return NO;
}

- (void)changeServiceInterface {
    
#ifdef DEBUG
    //开发者模式
    NSLog(@"-------------");
#else
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTriggerTheTrigger)];
    longPressGesture.minimumPressDuration = 3;
    [self.view addGestureRecognizer:longPressGesture];
    
#endif
    
}

# pragma mark -- 长按进入开发者模式
- (void)enterIntoDevelopmentEnvironment {
    
    TO_WEAK(self, weakSelf);
    [[CustomAlertView shareCustomAlertView] showTitle:nil content:@"确认进入开发者模式" leftButtonTitle:nil rightButtonTitle:nil block:^(NSInteger index) {
        if (index == 1) {
            DevelopmentViewController *development = [[DevelopmentViewController alloc] init];
            [weakSelf.navigationController pushViewController:development animated:YES];
        }
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
