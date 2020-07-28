//
//  AppDelegate.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarViewController.h"
#import "WebRequest.h"
#import "LoginViewController.h"
#import "BaseNavigationViewController.h"
#import "GuideViewController.h"//引导页
#import "LaunchView.h"

#import <UMCommon/UMCommon.h>
//#import <AlipaySDK/AlipaySDK.h>//支付宝
#import <SVProgressHUD/SVProgressHUD.h>
 #import <HyphenateLite/HyphenateLite.h>//环信
//#import <UMPush/UMessage.h>//友盟推送
#import <Bugly/Bugly.h>

// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//model
#import "UserModel.h"

@interface AppDelegate () <
    WXApiDelegate,
    WeiboSDKDelegate,
    UITabBarControllerDelegate>

@end

@implementation AppDelegate

void uncaughtExceptionHandler(NSException*exception){
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    // Internal error reporting
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

//    CGSize viewSize = [UIScreen mainScreen].bounds.size;
//    NSString * image = nil;
//    NSArray * array = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
//    for (NSDictionary * dict in array) {
//        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
//        if (CGSizeEqualToSize(imageSize, viewSize)) {
//            image = dict[@"UILaunchImageName"];
//        }
//    }
    
    
    [WebMonitors share];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webChanged2NotReachable) name:WebChangeCanReachable2NotReachable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webChanged2CanReachable) name:WebChangeNotReachable2CanReachable object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        //友盟统计
        [self umengTrack];
        
        //注册微博
        //    [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:SINA_APPKEY];
        
        // 注册微信
        [WXApi registerApp:WEICHAT_APPID universalLink:@""];
        
        //注册环信
        EMOptions *options = [EMOptions optionsWithAppkey:EM_AppKey];
        options.apnsCertName = @"XingDongHr";
        options.isAutoLogin  = YES;
        [[EMClient sharedClient] initializeSDKWithOptions:options];
        
        //注册友盟推送
        [self umengPush:launchOptions];
        
        //bugly
        [Bugly startWithAppId:Bugly_APPID];
        
    });
    
    self.isRotation = NO;
    
    
    
    if (UserDefaultsGet(FIRST_IN_KEY)) {
        [self changeWindowRootViewController];
    }else {
        GuideViewController *guideView = [[GuideViewController alloc] init];
        self.window.rootViewController = guideView;
    }
    
    [self.window makeKeyAndVisible];
    
    //启动页
    [[LaunchView shareLaunchView] show];
    
    return YES;
}

- (void)changeWindowRootViewController {
    TabbarViewController *tabbar = [[TabbarViewController alloc]init];
    tabbar.delegate = self;
    tabbar.selectedIndex = 2;
    self.window.rootViewController = tabbar;
}


#pragma mark -- 友盟统计
- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //注册友盟统计SDK
    [UMConfigure initWithAppkey:UMENG_APPKEY channel:@"App Store"];
//    [UMConfigure setLogEnabled:YES];
//    [MobClick setCrashReportEnabled:YES];
}

#pragma mark -- 友盟推送
- (void)umengPush:(NSDictionary *)launchOptions {
    // Push功能配置
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //设置是否允许SDK自动清空角标
//    [UMessage setBadgeClear:NO];
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
//    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
//    if (([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10)) {
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"打开应用";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"忽略";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
//        actionCategory1.identifier = @"category1";//这组动作的唯一标示
//        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
//        entity.categories=categories;
//    }
//    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
//    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
//        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
//        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
//
//        //UNNotificationCategoryOptionNone
//        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
//        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
//        NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
//        entity.categories=categories;
//    }
//    if (@available(iOS 10.0, *)) {
//        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
//    } else {
//        // Fallback on earlier versions
//    }
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//        }else{
//        }
//    }];
}

//当网络发生变化 由有网跳转到无网时调用
- (void)webChanged2NotReachable
{
    QLLogFunction
    [SVProgressHUD showInfoWithStatus:kTipsNotNet];
}

//当网络发生变化 由无网跳转到有网时调用
- (void)webChanged2CanReachable
{
    QLLogFunction
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


# pragma mark -- APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

# pragma mark -- // APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma mark -- 注册推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    //    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

# pragma mark -- 注册推送成功
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    NSLog(@"deviceToken == %@", deviceToken);
//    [UMessage registerDeviceToken:deviceToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}



//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
//    [UMessage setAutoAlert:YES];
//    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
//        [UMessage didReceiveRemoteNotification:userInfo];
//    }
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//            [UMessage setAutoAlert:NO];
//            //应用处于前台时的远程推送接受
//            //必须加这句代码
//            [UMessage didReceiveRemoteNotification:userInfo];
        }else{
            //应用处于前台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    /*
     {
         aps =     {
                 alert =         {
                     body = "\U578b\U52a8\U6c47\U795d\U60a8\U5728\U65b0\U7684\U4e00\U5e74\U91cc\U2019\Ud83d\Udc37\U2018\U4e8b\U5927\U5409\Uff01\Uff01\Uff01\Uff01";
                     subtitle = "\U73e0\U8054\U74a7\U5408";
                     title = "\U732a\U5e74\U5feb\U5230\U54af";
                     };
                 badge = 2;
                 "mutable-content" = 1;
                 sound = default;
                 url = "https://www.baidu.com";
             };
         d = uueo5hb154823224624610;
         diyKey = diyValue;
         p = 0;
     }
     */
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            //必须加这句代码
//            [UMessage didReceiveRemoteNotification:userInfo];
        }else{
            //应用处于后台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//
//            NSLog(@"支付宝支付结果result = %@",resultDic);
//            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFBPAYSUCCESS" object:nil];
//            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
//                NSLog(@"用户中途取消");
//                [SVProgressHUD showErrorWithStatus:@"您已取消支付"];
//            }
//
//        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self] || [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self] || [WeiboSDK handleOpenURL:url delegate:self];
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//
//            NSLog(@"支付宝支付结果result = %@",resultDic);
//            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"ZFBPAYSUCCESS" object:nil];
//            } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
//                NSLog(@"用户中途取消");
//                [SVProgressHUD showErrorWithStatus:@"您已取消支付"];
//            }
//
//        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self] || [WeiboSDK handleOpenURL:url delegate:self];
    
}

#pragma mark -- 微博回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if (self.SinaWBCallBackResultBlock) {
        self.SinaWBCallBackResultBlock(response);
    }
    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:response.userInfo];
//
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
//        NSLog(@"你做的微博分享");
//        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        NSString * wbtoken = [sendMessageToWeiboResponse.authResponse accessToken];
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        [userDefault setObject:wbtoken forKey:@"wbtoken"];
//        [userDefault synchronize];
//
//        if (response.statusCode == 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiXinFenXiangChengGong" object:nil];
//
//        }else{
//            NSLog(@"分享失败");
//        }
//
//    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
//        NSString * wbtoken = [(WBAuthorizeResponse *)response accessToken];
////        NSString *uid = [User LoginUserId];
//        NSString *uid = [(WBAuthorizeResponse *)response userID];
//        if (uid) {//分享时授权
//            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//            [userDefault setObject:wbtoken forKey:@"wbtoken"];
//            [userDefault synchronize];
//
//        }else{//微博登陆
//            // 因为已经判断了没有微博APP就不显示微博登录了，所以不用判断网页登录
//            if(![WeiboSDK isCanSSOInWeiboApp]){//网页登陆
//
//                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboLogin" object:userInfo];
//
//            }else{
//                if ((int)response.statusCode == 0) {
//                    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"weboUserInfo"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboLogin" object:nil];
//                }
//
//            }
//        }
//    }
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}


#pragma mark -- 微信回调
- (void)onResp:(BaseResp *)resp {
    
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    
    if (self.WXCallBackResultBlock) {
        self.WXCallBackResultBlock(resp);
    }
    
//    if([resp isKindOfClass:[SendAuthResp class]]) { // 微信登录
//
//
//    } else if([resp isKindOfClass:[PayResp class]]) {
//        // 微信支付
//        if (self.WXCallBackResultBlock) {
//            self.WXCallBackResultBlock(resp);
//        }
//    }
//    else if ([resp isKindOfClass:[SendMessageToWXResp class]]){ // 微信分享
//        if (self.WXCallBackResultBlock) {
//            self.WXCallBackResultBlock(resp);
//        }
//        SendMessageToWXResp *res = (SendMessageToWXResp *)resp;
//        if(res.errCode == 0){
//            NSLog(@"用户分享成功");
//        } else if (res.errCode == -4) {
//            NSLog(@"用户取消分享");
//        }
//    }
}

//  每次试图切换的时候都会走的方法,用于控制设备的旋转方向.
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (_isRotation) {
        
        return UIInterfaceOrientationMaskLandscape;
        
    }else {
        
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

# pragma mark -- UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:BaseNavigationViewController.class]) {
        BaseNavigationViewController *nav = (BaseNavigationViewController*)viewController;
        NSString *className = NSStringFromClass(nav.viewControllers.firstObject.class);
        if ([className isEqualToString:@"CourseViewController"] || [className isEqualToString:@"MineViewController"] || [className isEqualToString:@"LoseFatViewController"]) {
            if (![Tools isLoginAccount]) {
                
                LoginViewController *login = [[LoginViewController alloc] init];
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
                [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
                return NO;
            }
        }
    }
    
    return YES;
}

-(void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController {
    self.isRotation = NO;
}

@end
