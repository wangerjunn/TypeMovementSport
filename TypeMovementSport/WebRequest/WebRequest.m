//
//  WebRequest.m
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "WebRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDictionary+Description.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UserModel.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import "TabbarViewController.h"

#define kNetFailTip @"网络开小差了，请稍后重试！"


@interface WebMonitors ()

@property (nonatomic, assign) AFNetworkReachabilityStatus status;

@end

@implementation WebMonitors

static WebMonitors * __shared = nil;


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            self.status = status;
            // 发出通知，各个页面做出相应反应
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)setStatus:(AFNetworkReachabilityStatus)status
{
    if (status != _status) {
        if ((status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) && (_status == AFNetworkReachabilityStatusReachableViaWiFi || _status == AFNetworkReachabilityStatusReachableViaWWAN)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [[NSNotificationCenter defaultCenter]postNotificationName:WebChangeCanReachable2NotReachable object:nil];
                }
            });
        }else if ((_status == AFNetworkReachabilityStatusNotReachable || _status == AFNetworkReachabilityStatusUnknown) && (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [[NSNotificationCenter defaultCenter]postNotificationName:WebChangeNotReachable2CanReachable object:nil];
                }
            });
        }
        
        _status = status;
    }
}

+ (BOOL)webIsOK:(NSError **)error
{
    return [[WebMonitors share]webIsOK:error];
}


- (BOOL)webIsOK:(NSError **)error
{
    if (!([AFNetworkReachabilityManager sharedManager].isReachable || [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)) {
        *error = [NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        return NO;
    }else {
        *error = nil;
        return YES;
    }
}

+ (WebMonitors *)share
{
    @synchronized(self) {
        if (!__shared) {
            __shared = [[WebMonitors alloc]init];
        }
    }
    return __shared;
}
@end

@implementation WebRequest

+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock
{
    
    NSError * err;
    if (![WebMonitors webIsOK:&err]) {
        
        failedBlock(err);
        if (err.code == 100) {
            [SVProgressHUD showErrorWithStatus:kTipsNotNet];
        }
        return;
    }
    if (ViewController) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // responseSerializer把响应原始数据返回，缺省是AFN会自动解析json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:urlString parameters:dict headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSDictionary * responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        NSLog(@"GET:---%@ --\nparams:%@------\n response:%@",urlString,dict.description,responseDict.my_description);
        if (ViewController) {
            [SVProgressHUD dismiss];
        }
        
        NSString * remindMsg = [WebRequest checkMsgWithDict:responseDict];
        if ([responseDict[@"code"] integerValue] == 9999) {
//            [[CustomAlertView shareCustomAlertView] showAlertViewWtihTitle:@"请求失败" viewController:ViewController];
            failedBlock([NSError errorWithDomain:@"请求失败" code:9999 userInfo:nil]);
            return ;
        }
        if ([remindMsg isEqualToString:@"B9999"]) {
//            [[CustomAlertView shareCustomAlertView] showAlertViewWtihTitle:responseDict[@"data"][@"txt"] viewController:ViewController];
            successBlock(responseDict,remindMsg);
        }else{
            successBlock(responseDict,remindMsg);
            
            
            
            //        [self saveLoginSession];
            NSRange range = [remindMsg rangeOfString:@"999"];
            if (range.location != NSNotFound && remindMsg.length == 4) {
                
                if ([remindMsg integerValue] == 9995) {
                   
                }
            }
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"GET:---%@ --\nparams:%@------\n error:%@",urlString,dict,error);
        if (ViewController) {
            [SVProgressHUD dismiss];
        }
        failedBlock(error);
    }];
    
}

+ (void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock
{
    
    NSError * err;
    if (![WebMonitors webIsOK:&err]) {
        
        failedBlock(err);
        if (err.code == 100) {
            [SVProgressHUD showErrorWithStatus:kTipsNotNet];
        }
        return;
    }
    
    if (ViewController) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD show];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",nil];
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    // 添加请求头
    if ([urlString containsString:@"api"]) {
        NSData *data = UserDefaultsGet(kUserModel);
        UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString *Authorization = [NSString stringWithFormat:@"%@ %@",userModel.token_type?userModel.token_type:@"",userModel.Authorization?userModel.Authorization:@""];
        [manager.requestSerializer setValue:Authorization
                                 forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:userModel.markup?userModel.markup:@""
                                 forHTTPHeaderField:@"markup"];
    }
//    [manager.requestSerializer setValue:@"Bearer eyJhbGciOiJIUzI1NiJ9.eyJwcmluY2lwYWwiOiJINHNJQUFBQUFBQUFBSlZTdjJcL1RRQmo5SEZJS3FnUXRFa2dNUlVpVURUbmtaNmt5eFdtQ2hLd1dOV1FwRXVoaVg4MjE1enR6ZDI2ZEJXV0NvVU1SVUFtSmxiSFwvQ1N6OEFRZ0cxczZzZkpjMmRXQ3BPSG13dm50KzczM3YrZWdZWnJTQ2FxUUk0OXBOZUJveDRlcEVNUkZwR3FTS21hR2JhcXBDYXNhSWgyTmdIeWR3Y3B3Q09ENFVXR2pnbXI5TmRrbUpFeEdWMWdmYk5ERE5URUZGcXVpVWNVdVJtTzVKdGVPZWNRZFMwYjhFY21ybmN3Rm1OMkdCQklGTWhWbVRvcE1sVE5Gd0UrYnptUytESFR1Nkh1QU5GWVlScnFlaHMxU1FBYWVoRDNNa05TOGtxaktxRFZ3OU1ac2F4a3M5YXBvK1hFcUkxdWp1bjAxNnhscTM5OWFtd0ExZXdpc29ab21EQjdPN2E2R3U1WEhia25QY21rbWhsXC9vaWxpSGJZbFljK1VlTDc3NGRmQnIxQ3dDWXliM3p2OG5uTnowWWZYbjIrOVk0YUNjd2NHUEtlZzVyWmdtNldjaVpueWhxbGI5XC9mUHorOFBqTjB3dW9iQkhkXC8rOWpxWFdhM0xBdDQ0UW9ZdVJVUjBpN1Y3VHZTTzZkVHo1cFllajJXSnh3aW4rVU1EUThrOGlKY2QyaWtueVN0NEhMRyt0KzUzbVwvMTluSURGd3NWNnI0R0xoZDl4cVZScmZWcnRTWHZacFhLM3ZMSytWdVk3VlZXMzF3ZjZYZXFxS3ZLK05ZYkordUw3SE5cL1Y5dnZ4N2MrWUVhajJCbWxcL0NVWWl2ek9XZ3RqUWRVdlQ0NlhKejc4SE5cL3ZPUGtmXC84RE1NanRSak1EQUFBPSIsInN1YiI6IjVCNjI2RkFDMjU3QjRCNDFCNzkxRjZEQTREODA5NUEzIiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sImV4cCI6MTU0NzM4NzE5OCwiaWF0IjoxNTM5NjExMTk4fQ.BIuFCwdaHwivq0tzNsTmc1RnaU0yxzln2ildspNbOWE" forHTTPHeaderField:@"Authorization"];
//    [manager.requestSerializer setValue:@"09B1621E8ADD4A65A99C1A1F4AA1A2F6" forHTTPHeaderField:@"markup"];
    
    if (![urlString containsString:@"http"]) {
        urlString = [kBaseUrl stringByAppendingString:urlString];
    }
    
    [manager POST:urlString parameters:dict headers:nil   progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        NSDictionary *responseDict = responseObject;
        NSLog(@"POST:---%@ --\nparams:%@------\n response:%@",urlString,dict.my_description,(NSDictionary *)responseDict.my_description);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ViewController) {
                [SVProgressHUD dismiss];
            }
            
        });
        
        
        NSString *remindMsg = [NSString stringWithFormat:@"%@",responseDict[@"code"]];
        if (responseDict[kSuccess] && [responseDict[kSuccess] integerValue] == 1) {
            successBlock(responseDict[@"data"],@"999");
        }else if ([remindMsg integerValue] == 401) {
            //登录失效，需要重新登录
            [self toLoginView];
            successBlock(responseDict,remindMsg);
        }else{
            successBlock(responseDict,remindMsg);
        }
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"POST:---%@ --\nparams:%@------\n error:%@",urlString,dict,error);
        [SVProgressHUD showErrorWithStatus:kRequestFailTip];
        failedBlock(error);
    }];
    
}

//  带上传功能
+ (void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict photoArr:(NSArray *)photoArr viewControll:(UIViewController *)ViewController success:(DownloadSuccessBlock)successBlock failed:(DownloadFailedBlock)failedBlock
{
    
    NSError * err;
    if (![WebMonitors webIsOK:&err]) {
        
        failedBlock(err);
        if (err.code == 100) {
            [SVProgressHUD showErrorWithStatus:kTipsNotNet];
        }
        return;
    }
    
    if (ViewController) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }
    
    NSString * contentStr = @"application/json";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:contentStr,nil];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager POST:urlString parameters:dict headers:nil  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        for (UIImage * image in photoArr) {
            NSData * imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"anyImage_%d",i]fileName:[NSString stringWithFormat:@"anyImage_%d.jpg",i] mimeType:@"image/jpeg"];
            i++;
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功回调
        NSDictionary *dict = responseObject;
        NSString * remindMsg = [WebRequest checkMsgWithDict:dict];
        if ([dict[@"code"] integerValue] == 9999) {
//            [[CustomAlertView shareCustomAlertView] showAlertViewWtihTitle:@"请求失败" viewController:ViewController];
            failedBlock([NSError errorWithDomain:@"请求失败" code:9999 userInfo:nil]);
            return ;
        }
        successBlock(dict,remindMsg);
        //        [self saveLoginSession];
        NSRange range = [remindMsg rangeOfString:@"999"];
        if (range.location != NSNotFound && remindMsg.length == 4) {
            
            if ([remindMsg integerValue] == 9995) {
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败回调
        failedBlock(error);
    }];
    
}

+ (NSString *)checkMsgWithDict:(NSDictionary *)dict
{
    NSString * str;
    if ([dict[@"code"] isEqualToString:@"0000"]) {
        
        NSDictionary *data = dict[@"data"];
        
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            str = @"999";
        } else {
            str = data[@"status"];
        }
    } else {
        str = dict[@"code"];
    }
    return str;
}

+(void)toLoginView{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [Tools clearLoginData];
        LoginViewController *login = [[LoginViewController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:login];
        if ([delegate.window.rootViewController isKindOfClass:[TabbarViewController class]]) {
            TabbarViewController *tabbar =(TabbarViewController *)delegate.window.rootViewController;
            tabbar.selectedIndex = 2;
            [delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        
    });
}

+ (AFSecurityPolicy *)customSecurityPolicy {
    
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    return securityPolicy;
}


@end
