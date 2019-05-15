//
//  UserModel.m
//  TypeMovementSport
//
//  Created by XDH on 2018/10/29.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

//获取短信验证码
+ (void)getSmsSendCodeByPara:(NSDictionary *)info
              viewController:(UIViewController *)viewController
                      result:(void(^)(NSDictionary *data, NSError *error))result {
    [self requestNet:info url:kSendCode viewController:viewController block:^(NSDictionary *data, NSError *error) {
        if (result) {
            result(data, error);
        }
    }];
}

//通过手机号注册
+ (void)registerByPhone:(NSDictionary *)info
         viewController:(UIViewController *)viewController
                 result:(void(^)(NSDictionary *data, NSError *error))result {
    [self requestNet:info url:kRegisterByPhone viewController:viewController block:^(NSDictionary *data, NSError *error) {
        if (result) {
            result(data, error);
        }
    }];
}

//通过手机号登录
+ (void)loginByPhone:(NSDictionary *)info
            viewController:(UIViewController *)viewController
                            result:(void(^)(NSDictionary *data, NSError *error))result {
    [self requestNet:info url:kLoginByPhone viewController:viewController block:^(NSDictionary *data, NSError *error) {
        if (result) {
            result(data, error);
        }
    }];
}

//获取用户列表
+ (void)getUserListInfo:(NSDictionary *)info
         viewController:(UIViewController *)viewController
                 result:(void(^)(NSDictionary *data, NSError *error))result {
    [self requestNet:info url:kUserList viewController:viewController block:^(NSDictionary *data, NSError *error) {
        if (result) {
            result(data, error);
        }
    }];
}

//获取用户详情
+ (void)getUserDetailInfo:(NSDictionary *)info
           viewController:(UIViewController *)viewController
                   result:(void(^)(NSDictionary *data, NSError *error))result {
    [self requestNet:info url:kUserGet viewController:viewController block:^(NSDictionary *data, NSError *error) {
        if (result) {
            result(data, error);
        }
    }];
}

//更新用户信息
+ (void)updateUserInfo:(NSDictionary *)info
        viewController:(UIViewController *)viewController
                result:(void(^)(NSDictionary *data, NSError *error))result {
    
    [self requestNet:info url:kUserUpdate viewController:viewController block:^(NSDictionary *data, NSError *error) {
        if (result) {
            result(data, error);
        }
    }];
}


/**
 请求网络

 @param info 参数信息
 @param url URL路径
 @param viewController viewController可为nil
 @param block 回调
 */
+ (void)requestNet:(NSDictionary *)info
               url:(NSString *)url
    viewController:(UIViewController *)viewController
             block:(void(^)(NSDictionary *data, NSError *error))block {
    
    NSString *urlString = [kBaseUrl stringByAppendingString:url];
    [WebRequest PostWithUrlString:urlString parms:info viewControll:viewController success:^(NSDictionary *dict, NSString *remindMsg) {
        if (block) {
            block(dict,nil);
        }
    } failed:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
    
}

@end
