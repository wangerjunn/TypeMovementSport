//
//  Tools.m
//  GoToSchool_Teacher
//
//  Created by 蔡连凤 on 15/4/27.
//  Copyright (c) 2015年 UI. All rights reserved.
//
#define kCookiePath [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Cookie.plist"]
#import "Tools.h"
#import "MBProgressHUD.h"


#import "AliyunOSSiOS.h"
#import "ParamFile.h"
#import "AppDelegate.h"
#import "CustomAlertView.h"
#import "AFNetworking.h"
//#import "RSA.h"
#import <objc/runtime.h>
#import "UserModel.h"
#import <HyphenateLite/HyphenateLite.h>
//static AMapLocationManager *_manager;
@implementation Tools

//监测是否已登录账户
+ (BOOL)isLoginAccount {
    BOOL isLogin = NO;
    
    NSData *data = UserDefaultsGet(kUserModel);
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userModel && userModel.isLogin == YES) {
        isLogin =  YES;
    }
    return isLogin;
}

// 是否有网络
+ (BOOL) IsEnableNet {
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}
/*****
 * 校验用户手机号码
 */
+ (BOOL) validateUserPhone : (NSString *) str
{
    
    //手机号以13， 15，18，17 开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9])|(00[0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    [FSOLoggingUtil print:@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:str];
    
    /*
     NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
     initWithPattern:@"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)"
     options:NSRegularExpressionCaseInsensitive
     error:nil];
     NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
     options:NSMatchingReportProgress
     range:NSMakeRange(0, str.length)];
     
     
     if(numberofMatch > 0)
     {
     return YES;
     }
     
     return NO;
     */
}


/*****
 * 校验用户身份证号码
 */
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/*****
 * 判断是否是空字符串
 */
+ (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

/*****
 * 邮箱正则匹配
 */
#define EMAIl @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"   //邮箱正则表达式
+(BOOL)isEmail:(NSString *)email
{
    NSPredicate * eMailPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIl];
    BOOL isEmail = [eMailPred evaluateWithObject:email];
    return isEmail;
}


+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length == 11 && [[mobileNum substringToIndex:1] isEqualToString:@"1"] == YES) {
        return YES;
    }
    else
        return NO;
}


/*
 计算当前时间
 */
+(NSString *)string_TimeTransformToTimestampByTimeStamp:(NSUInteger)timeStamp
{
    // NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)timeStamp/3600;
    NSUInteger min  = (NSUInteger)(timeStamp%(3600))/60;
    NSUInteger second = (NSUInteger)(timeStamp%60);
    
    NSString *time = [NSString stringWithFormat:@"%02lu小时%02lu分钟%02lu秒",(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
}


+ (NSInteger)isLegalPasaword:(NSString *)password
{
    NSInteger isLegal = -11111;
    if (password.length < 6 || password.length > 16) {
        isLegal = 1;
    }
    else{
        for (NSInteger i = 0; i < password.length ;i++) {

            UniChar  oneChar = [password characterAtIndex:i];
            if (isdigit(oneChar)||isalpha(oneChar)) {
                isLegal = 0;
            }
            else {
                if (oneChar == '_') {
                    isLegal = 0;
                }else{
                    isLegal = -1;
                }
            }
        }
    }
    return isLegal;
}

+ (NSString *)trim:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
 限制小数点后长度
 
 @param length 小数点后几位，默认为2位
 @param currentInputString 键盘输入参数
 @param totalStrin 输入框当前内容
 @return BOOL
 */
+ (BOOL)limitDecimalPointAfterLength:(NSInteger)length
                  currentInputString:(NSString *)currentInputString
                         totalString:(NSString *)totalString {
    // 当前输入的字符是'.'
    if ([currentInputString isEqualToString:@"."]) {
        
        // 已输入的字符串中已经包含了'.'或者""
        if ([totalString rangeOfString:@"."].location != NSNotFound || [totalString isEqualToString:@""]) {
            
            return NO;
        } else {
            
            return YES;
        }
    } else {// 当前输入的不是'.'
        
        // 第一个字符是0时, 第二个不能再输入0
        if (totalString.length == 1) {
            
            unichar str = [totalString characterAtIndex:0];
            if (str == '0' && [currentInputString isEqualToString:@"0"]) {
                
                return NO;
            }
            
            if (str != '0' && str != '1') {// 1xx或0xx
                
                return YES;
            } else {
                
                if (str == '1') {
                    
                    return YES;
                } else {
                    
                    if ([currentInputString isEqualToString:@""]) {
                        
                        return YES;
                    } else {
                        
                        return NO;
                    }
                }
                
                
            }
        }
        
        // 已输入的字符串中包含'.'
        if ([totalString rangeOfString:@"."].location != NSNotFound) {
            
            NSMutableString *str = [[NSMutableString alloc] initWithString:totalString];
//            [str insertString:currentInputString atIndex:range.location];
            [str appendString:currentInputString];
            
            NSLog(@"str.length = %ld, decimalPoint.location = %lu, limitLength = %ld", (unsigned long)str.length, (unsigned long)[str rangeOfString:@"."].location, (long)length);
            if ((str.length - [str rangeOfString:@"."].location - 1) > (length?length:2)) {
                
                return NO;
            }
            
            
            
        }
        
    }
    
    
    return YES;
}



/**货币形式格式化*/
+(NSString *)numberFormat:(NSNumber *)number
{
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = kCFNumberFormatterCurrencyStyle;
    nf.currencySymbol = @"";
    return [nf stringFromNumber:number];
}
/**货币形式格式化*/
+(NSString *)numberFormatWithString:(NSString *)numberStr
{
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = kCFNumberFormatterCurrencyStyle;
    nf.currencySymbol = @"";
    NSNumber * number = [NSNumber numberWithInteger:[numberStr integerValue]];
    return [nf stringFromNumber:number];
}
/**货币形式格式化 带符号*/
+(NSString *)numberFormatWithSymbol:(NSNumber *)number
{
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    nf.numberStyle = kCFNumberFormatterCurrencyStyle;
    nf.currencySymbol = @"￥";
    return [nf stringFromNumber:number];
}
//修改字体颜色
+ (void)modifyFontColorBy:(UILabel*)lbl
           withModifyPart:(NSString*)part
                withColor:(UIColor*)color
{
    /*
     lbl 整段文字
     part 修改部分文字
     color 修改后的颜色
     */
    
    part = [NSString stringWithFormat:@"%@",part];
    
    NSMutableAttributedString *string;
    string = [[NSMutableAttributedString alloc]initWithString:lbl.text];
    
    
    NSRange range = [lbl.text rangeOfString:part];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:color
                   range:range];
    lbl.attributedText = string;
    
}
+(BOOL)isNeedUpdata:(NSString *)locationVersion onLineUpdate:(NSString *)updateVersion{
    NSArray *arr1 = [locationVersion componentsSeparatedByString:@"."];
    NSArray *arr2 = [updateVersion componentsSeparatedByString:@"."];
    
    if ([arr1.firstObject integerValue] > [arr2.firstObject integerValue]) {
        
        return NO;
    }else if ([arr1.firstObject integerValue] == [arr2.firstObject integerValue]){
        if ([arr1[1] integerValue] > [arr2[1] integerValue]) {
            return NO;
        }else if ([arr1[1] integerValue] == [arr2[1] integerValue]) {
            if ([arr1.lastObject integerValue] > [arr2.lastObject integerValue]) {
                return NO;
            }else if ([arr1.lastObject integerValue] == [arr2.lastObject integerValue]) {
                
                return NO;
            }else{
                return YES;
            }
            
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}
#pragma mark -- 取得cookie
/**
 *  取得Cookie
 */
+ (void)updateCookie{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithFile:kCookiePath];
    for (NSHTTPCookie *cookie in cookies) {
        
        [cookieStorage setCookie:cookie];
        
        
    }
    
}
/**
 *  保存cookie
 *
 *
 */
#pragma mark -- 保存cookie
+ (void)saveLoginSession{
    
    NSArray *allCoolkies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    if (allCoolkies.count > 0) {
        
        
        [NSKeyedArchiver archiveRootObject:allCoolkies toFile:kCookiePath];
        
        
    }
    
    
    
    
}
+ (void)removeCookie{
    
    [[NSFileManager defaultManager] removeItemAtPath:kCookiePath error:nil];
    
}
+(NSString *)stringTOjson:(id)temps   //把字典和数组转换成json字符串
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:temps
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
}
+ (BOOL)isUrl:(NSString *)urlString{
    
        if(urlString == nil)
            return NO;
        NSString *url;
        if (urlString.length>4 && [[urlString substringToIndex:4] isEqualToString:@"www."]) {
            url = [NSString stringWithFormat:@"http://%@",self];
        }else{
            url = urlString;
        }
        NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
        NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
        return [urlTest evaluateWithObject:url];
    
}

#pragma mark -- 上传图片
+ (void)uploadImageByImage:(UIImage *)image hudView:(UIView *)view path:(NSString *)path toTargetMb:(NSNumber *)targetzMb uploadCallback:(void (^)(BOOL, NSError *,NSString *))uploadCallback withProgressCallback:(void (^)(float))progressCallback
{
   __block MBProgressHUD *hud;
    if (view) {
        dispatch_async(dispatch_get_main_queue(), ^{
           hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        });
    }
    NSString *endpoint = [NSString stringWithFormat:@"%@",OSSEndPoint];
    
    id<OSSCredentialProvider> credential2 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:OSSSecretKey];
        
        if (signature != nil) {
            *error = nil;
        } else {
            
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@", OSSAccessKey, signature];
    }];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential2];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    NSDate * date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",time * 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    
    NSData *data = UserDefaultsGet(kUserModel);
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //upload/android/2019/01/10/userid/时间戳
    NSString *uploadPath = [NSString stringWithFormat:@"upload/ios/%@/%@/%@/%ld/%@",dateArr.firstObject,dateArr[1],dateArr.lastObject,(long)model.id,timeStr];
    put.bucketName = [NSString stringWithFormat:@"%@",OSSBucketName];
    put.objectKey = uploadPath;
    NSData *imageData;
    if (targetzMb) {
        imageData = [ImageTool compressImage:image toTargetM:[targetzMb floatValue]];
    }else{
        imageData = UIImagePNGRepresentation(image);
    }
     put.uploadingData = imageData; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        float progress = totalByteSent * 1.0 / totalBytesExpectedToSend;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hud) {
                hud.label.text = [NSString stringWithFormat:@"正在上传：%02ld%%",(long)(progress*100)];
            }
            
        });
        if (progressCallback) {
            progressCallback(progress);
        }
        
    };

	//上传图片信息
	NSLog(@"图片路径: %@",uploadPath);
	NSLog(@"bucketName: %@",put.bucketName);
	NSLog(@"endpoint: %@",endpoint);

    // 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
     put.contentType = @"image/png";
    // put.contentMd5 = @"";
    // put.contentEncoding = @"";
    // put.contentDisposition = @"";
    // put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"-----------------------------回调完成-----------------------------");
        if (!task.error) {

            NSLog(@"upload object success!");

            
            OSSTask * tk = [client presignPublicURLWithBucketName:[NSString stringWithFormat:@"%@",OSSBucketName]
                                                         withObjectKey:uploadPath];
            NSString *url;
            if (!tk.error) {
                NSString *result = tk.result;
               url = [result stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
            } else {
                NSLog(@"error: %@", tk.error);

            }

			dispatch_main_async_safe(^{
				if (hud) {
					[hud hideAnimated:YES];
				}

				if (uploadCallback) {
					uploadCallback(!tk.error,tk.error,url);
				}
			})

        } else {
            NSLog(@"upload object failed, error: %@" , task.error);

			dispatch_main_async_safe(^{
				if (hud) {
					[hud hideAnimated:YES];
				}

				if (uploadCallback) {
					uploadCallback(NO,task.error,nil);
				}
			})

        }
        return nil;
    }];

}

#pragma mark -- 上传数据
+ (void)uploadData:(NSData *)data hudView:(UIView *)view path:(NSString *)path uploadCallback:(void (^)(BOOL, NSError *,NSString *))uploadCallback withProgressCallback:(void (^)(float))progressCallback
{
    
    __block MBProgressHUD *hud;
    if (view) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        });
    }
    NSString *endpoint = [NSString stringWithFormat:@"%@",OSSEndPoint];
    
    id<OSSCredentialProvider> credential2 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:OSSSecretKey];
        
        if (signature != nil) {
            *error = nil;
        } else {
            
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@", OSSAccessKey, signature];
    }];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential2];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];

    put.bucketName = [NSString stringWithFormat:@"%@",OSSBucketName];
    put.objectKey = path;
    
    put.uploadingData = data; // 直接上传NSData
    // 可选字段，可不设置
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        float progress = totalByteSent * 1.0 / totalBytesExpectedToSend;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hud) {
                hud.label.text = [NSString stringWithFormat:@"正在上传：%02ld%%",(long)(progress*100)];
            }
        });
        if (progressCallback) {
            progressCallback(progress);
        }
        
    };
    // 以下可选字段的含义参考： https://docs.aliyun.com/#/pub/oss/api-reference/object&PutObject
    put.contentType = @"video/quicktime";
    // put.contentMd5 = @"";
    // put.contentEncoding = @"";
    // put.contentDisposition = @"";
    // put.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil]; // 可以在上传时设置元信息或者其他HTTP头部
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
            NSLog(@"upload object success!");
            
            OSSTask * tk = [client presignPublicURLWithBucketName:[NSString stringWithFormat:@"%@",OSSBucketName]
                                                    withObjectKey:path];
            NSString *url;
            if (!tk.error) {
                NSString *result = tk.result;
                url = [result stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
            } else {
                NSLog(@"error: %@", tk.error);
            }

			dispatch_main_async_safe(^{
				if (hud) {
					[hud hideAnimated:YES];
				}

				if (uploadCallback) {
					uploadCallback(!tk.error,tk.error,url);
				}
			})

        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
			dispatch_main_async_safe(^{
				if (hud) {
					[hud hideAnimated:YES];
				}

				if (uploadCallback) {
					uploadCallback(NO,task.error,nil);
				}
			})
        }
        return nil;
    }];

}
#pragma mark --清楚登陆信息
+ (void)clearLoginData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [userDefaults objectForKey:kUserModel];
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    userModel.isLogin = NO;
    userModel.Authorization = nil;
    userModel.markup = nil;
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
    data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
    [userDefaults setObject:data forKey:kUserModel];
    
    [userDefaults removeObjectForKey:@"teacherId"];
    [userDefaults removeObjectForKey:@"wechatPayOpen"];
    [userDefaults removeObjectForKey:@"instalmentPayOpen"];
    [userDefaults removeObjectForKey:@"password"];
//    [userDefaults removeObjectForKey:kHaveLogin];
    [userDefaults removeObjectForKey:@"userName"];
    [userDefaults removeObjectForKey:@"RealName"];
    [userDefaults removeObjectForKey:@"OtherContact"];
    [userDefaults removeObjectForKey:@"mobile"];
    [userDefaults removeObjectForKey:@"UserModel"];
    [userDefaults removeObjectForKey:@"audit"];
    [userDefaults removeObjectForKey:@"teacherNo"];
    [userDefaults removeObjectForKey:@"schoolId"];
    [userDefaults removeObjectForKey:@"email"];
    [[NSFileManager defaultManager] removeItemAtPath:kCookiePath error:nil];
    
    [userDefaults removeObjectForKey:kUserModel];
    
    
    //设置标签
    /*
    [JPUSHService setTags:[NSSet setWithObject:KJpusTag] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
        NSLog(@"iResCode = %d,iTags = %@,iAlias = %@",iResCode,iTags,iAlias);
        
    }];
    */
    [userDefaults synchronize];
    
}

//+(void)requestLocationWithReGeocode:(BOOL)iswithReGeocode desiredAccuracy:(CLLocationAccuracy)desiredAccuracy locationTimeout:(NSTimeInterval)locationTimeout reGeocodeTimeout:(NSTimeInterval)reGeocodeTimeout completionBlock:(void(^)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error))completionBlock{
//    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
//        [[CustomAlertView shareCustomAlertView]showAlertViewWtihTitle:@"请到设置->隐私->定位服务->帮帮妙招中打开相应权限" viewController:nil];
//        completionBlock(nil,nil,[NSError errorWithDomain:@"请到设置->隐私->定位服务->帮帮妙招中打开相应权限" code:4444 userInfo:nil]);
//        return;
//
//    }
//    if (!_manager) {
//            _manager = [[AMapLocationManager alloc]init];
//    }
//    [_manager setDesiredAccuracy:desiredAccuracy];
//
//    _manager.locationTimeout = locationTimeout;
//    _manager.reGeocodeTimeout = reGeocodeTimeout;
//    [_manager requestLocationWithReGeocode:iswithReGeocode completionBlock:completionBlock];
//
//}

+(NSString *)URLEncodedString:(NSString *)str{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

+(NSString *)URLDecodedString:(NSString *)str{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

@end
