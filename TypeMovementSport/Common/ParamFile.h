//
//  ParamFile.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#ifndef ParamFile_h
#define ParamFile_h

#import "WebRequest.h"
#import "UITool.h"
#import "Tools.h"
#import "DeveloperConfig.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"
#import "UIView+UIViewController.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#import <UMAnalytics/MobClick.h>
#import "JSONKit.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSObject+isNotEmpty.h"

#define kPerfectInfoTip @"请完善信息"
#define kRequestFailTip @"请求失败"
#define kTipsNotNet @"网络开小差了o(╯□╰)o"
#define kPlaceHolderHead @"无头像"
#define kServiceTele @"010-57794818"  //客服电话
#define kShareDefaultLogo @"http://img.xingdongsport.com/file/WechatIMG6500.png"
#define kShareDefaultText @"我在使用型动汇观看各类健身视频，快来下载型动汇看看吧"
#define kShareDefaultRespondUrl @"http://www.xingdongsport.com/SportsServicePlatform/share/trainCourseShare/v-share.html?videoType=3&videoId="
#define FIRST_IN_KEY @"FIRST_IN_KEY"
#define kLoginSuccessNotification @"loginSuccessNotification"

//弹出框本地数据key值
#define kCurrentState @"currentState"
#define kHopeSalary @"hopeSalary"
#define kWorkExpYears @"workExpYears"
#define kEducation @"education"
#define kWelfare @"welfare"
#define kCompanyScale @"companyScale"

#define kUserModel @"userMOdel"

#define messageURL @"API_SS_SEND_PHONE_MS_BY_TEL_AND_RANDOM"
#define apiPath @"NvSportStar/API"

#define basicName @"Authorization"
#define basicPass @"5Z6L5Yqo5L2T6IKy"

#define KSecretKey @"5Z6L5Yqo5L2T6IKyXD"


//  OSSConfig
#define OSSBucketHostId    [DeveloperConfig getStringConfigurationForKey:@"OSSBucketHostId"]
#define OSSAccessKey       [DeveloperConfig getStringConfigurationForKey:@"OSSAccessKey"]
#define OSSSecretKey       [DeveloperConfig getStringConfigurationForKey:@"OSSSecretKey"]
#define OSSBucketName      [DeveloperConfig getStringConfigurationForKey:@"OSSBucketName"]

#define OSSEndPoint [DeveloperConfig getStringConfigurationForKey:@"OSSEndPoint"]

//新浪
#define SINA_APPKEY [DeveloperConfig getStringConfigurationForKey:@"SINA_APPKEY"]

// 友盟appkey
#define UMENG_APPKEY [DeveloperConfig getStringConfigurationForKey:@"UMENG_APPKEY"]
#define UMENG_SECRET [DeveloperConfig getStringConfigurationForKey:@"UMENG_SECRET"]


//微信
#define WEICHAT_APPID [DeveloperConfig getStringConfigurationForKey:@"WEICHAT_APPID"]
#define WEICHAT_SECRET [DeveloperConfig getStringConfigurationForKey:@"WEICHAT_SECRET"]

//环信
#define EM_AppKey [DeveloperConfig getStringConfigurationForKey:@"EM_AppKey"]

//Bugly
#define Bugly_APPID [DeveloperConfig getStringConfigurationForKey:@"Bugly_APPID"]
#define Bugly_APPKEY [DeveloperConfig getStringConfigurationForKey:@"Bugly_APPKEY"]

//
//极光
//#define KJpushAppKey [DeveloperConfig getStringConfigurationForKey:@"KJpushAppKey"]
//#define KJpusIsProduction [DeveloperConfig getBoolConfigurationForKey:@"KJpusIsProduction"]   //极光环境-开发环境

//微博
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"


#define holdFace @"placeholdHead"
#define holdImage @"图片"
#define holdLogo @"loadTableHeader.jpg"
#define kTestHoldImgUrl @"http://upload-images.jianshu.io/upload_images/1692043-7eeeae6f30d1aab4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"//测试占位图片路径


#define V1_flage 34 //判断是否审核时支付的flag
#define version_nameSVR @"2.4.3"//判断是否审核时是否有登录拦截的flag

#define UserDefaultsGet(a)  [[NSUserDefaults standardUserDefaults] objectForKey:a]
#define UserDefaultsSet(a,b) [[NSUserDefaults standardUserDefaults] setObject:a forKey:b]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 颜色(RGB)
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//和6的比例
#define proportation  (kScreenWidth / 375)

#define FIT_SCREEN_WIDTH(x) x*kScreenWidth/375.0
#define FIT_SCREEN_HEIGHT(x) x*kScreenHeight/667.0
#define AUTO_FONT(x) [UIFont systemFontOfSize:FIT_SCREEN_WIDTH(x)]

//字体
#define Font(x) [UIFont systemFontOfSize:x]
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]

//常用颜色
#define kViewBgColor UIColorFromRGB(0xF5F5F5)
#define k75Color [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1]
#define k46Color [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1]
#define kOrangeColor UIColorFromRGB(0xFF6B00)
#define LaneCOLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]
#define k210Color [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]
#define k255Color RGBACOLOR(255, 107, 0, 1)
#define k52Color UIColorFromRGB(0x525252)

//字体大小
#define K_TEXT_FONT_10 10
#define K_TEXT_FONT_12 12
#define K_TEXT_FONT_14 14
#define K_TEXT_FONT_16 16

#define TO_WEAK(origin,weak)  __weak typeof(origin)weak = origin;
#define TO_STRONG(weak,strong)  __strong typeof(weak)strong = weak;

#define kSuccess @"success"
#define kMessage @"message"
#define kFrom       @"iOS"
#define kVersion    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//url列表
#define kParamHead [NSString stringWithFormat:@"?from=ios&version=%@",kVersion]

#endif /* ParamFile_h */
