//
//  Tools.h
//  GoToSchool_Teacher
//
//  Created by 蔡连凤 on 15/4/27.
//  Copyright (c) 2015年 UI. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AFNetworkReachabilityManager.h"
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>

@interface Tools : NSObject

//监测是否已登录账户
+ (BOOL)isLoginAccount;

// 是否有网络
+ (BOOL) IsEnableNet;
/*****
 * 校验用户邮箱
 */
+(BOOL)isEmail:(NSString *)email;


/*****
 * 校验用户手机号码
 */
+ (BOOL) validateUserPhone : (NSString *) str;

/*****
 * 判断是否是空字符串
 */
+ (BOOL) isBlankString:(NSString *)string;

/*****
 * 校验用户身份证号码
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**检验是否是是手机号*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*
 计算当前时间
 */
+(NSString *)string_TimeTransformToTimestampByTimeStamp:(NSUInteger)timeStamp;
/**是否是合法密码*/
+ (NSInteger)isLegalPasaword:(NSString *)password;

/**去掉首位空格*/
+ (NSString *)trim:(NSString *)str;


/**
 限制小数点后长度

 @param length 小数点后几位，默认为2位
 @param currentInputString 键盘输入参数
 @param totalStrin 输入框当前内容
 @return BOOL
 */
+ (BOOL)limitDecimalPointAfterLength:(NSInteger)length
                  currentInputString:(NSString *)currentInputString
                         totalString:(NSString *)totalStrin;

/**货币形式格式化*/
+(NSString *)numberFormat:(NSNumber *)number;

+(NSString *)numberFormatWithString:(NSString *)numberStr;

/**货币形式格式化 带符号*/
+(NSString *)numberFormatWithSymbol:(NSNumber *)number;
//修改字体颜色
/*
 lbl 整段文字
 part 修改部分文字
 color 修改后的颜色
 */

+ (void)modifyFontColorBy:(UILabel*)lbl
           withModifyPart:(NSString*)part
                withColor:(UIColor*)color;
/**
 *  是否需要更新
 *
 *  @param locationVersion 本地版本
 *  @param updateVersion   显示版本
 *
 *  @return
 */
+(BOOL)isNeedUpdata:(NSString *)locationVersion onLineUpdate:(NSString *)updateVersion;
+(NSString *)stringTOjson:(id)temps;   //把字典和数组转换成json字符串

//保存登录session
+ (void)saveLoginSession;

//更新cookie
+ (void)updateCookie;

#pragma mark -清除cookie
+ (void)removeCookie;

/**
 是否为url

 @param urlString url
 @return result
 */
+ (BOOL)isUrl:(NSString *)urlString;

/**
 上传图片

 @param image image
 @param path path
 @param uploadCallback uploadCallback 
 @param progressCallback progressCallback
 */

+ (void)uploadImageByImage:(UIImage *)image hudView:(UIView *)view path:(NSString *)path toTargetMb:(NSNumber *)targetzMb uploadCallback:(void (^)(BOOL isSuccess, NSError * error,NSString * url))uploadCallback withProgressCallback:(void (^)(float progress))progressCallback;
///上传文件数据
+ (void)uploadData:(NSData *)data hudView:(UIView *)view path:(NSString *)path uploadCallback:(void (^)(BOOL isSuccess, NSError * error,NSString * url))uploadCallback withProgressCallback:(void (^)(float progress))progressCallback;
//清楚登陆信息
+ (void)clearLoginData;
//获取老是个人信息
//+ (void)getTeacherInfoWithCompletion:(void(^)(NSError *error,NSDictionary *data))comletion AutoConnectRCIM:(BOOL)autoConnect connectSuccess:(void (^)(NSString *userId))successBlock
//                               error:(void (^)(RCConnectErrorCode status))errorBlock
//                      tokenIncorrect:(void (^)())tokenIncorrectBlock;

/**
 单次定位

 @param iswithReGeocode 是否反编码
 @param desiredAccuracy 精度
 @param locationTimeout 定位超时时间
 @param reGeocodeTimeout 反编码超时时间
 @param completionBlock 完成回调
 */
//+(void)requestLocationWithReGeocode:(BOOL)iswithReGeocode desiredAccuracy:(CLLocationAccuracy)desiredAccuracy locationTimeout:(NSTimeInterval)locationTimeout reGeocodeTimeout:(NSTimeInterval)reGeocodeTimeout completionBlock:(void(^)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error))completionBlock;

/**
 URLEncodedString url 编码

 @param str 需要编码的url
 @return 编码后的url
 */
+(NSString *)URLEncodedString:(NSString *)str;

/**
 URLDecodedString url解码

 @param str 需要解码的url
 @return 解码后的url
 */
+(NSString *)URLDecodedString:(NSString *)str;
@end
