//
//  UserModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/10/29.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"


@interface UserModel : BaseModel

/*
 "id":1,
 "phone":"15811110000",
 "nickName":null,
 "sex":null,
 "birthday":null,
 "headImg":null,
 "integralCount"
 
 
 birthday = "<null>";
 city = "北京";
 headImg = "http://gosportsbj.oss-cn-beijing.aliyuncs.com/teacher/avatar/head_1545916860260.png";
 id = 43;
 integralCount = 5;
 nickName = "xiaoErLang ";
 phone = 13126551433;
 remark = "To be or not to be , that is a question";
 sex = 1;
 username = 5AB1741F36844E838840B004F0565FD6;
 */

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *phone;//手机号
@property (nonatomic, copy) NSString *nickName;//昵称
@property (nonatomic, copy) NSString *sex;//性别 男，女
@property (nonatomic, copy) NSString *birthday;//生日
@property (nonatomic, copy) NSString *headImg;//头像
@property (nonatomic, copy) NSString *city;//城市
@property (nonatomic, copy) NSString *remark;//备注
@property (nonatomic, copy) NSString *Authorization;
@property (nonatomic, copy) NSString *markup;
@property (nonatomic, copy) NSString *token_type;
@property (nonatomic, copy) NSString *integralCount;//签到积分
@property (nonatomic, copy) NSString *username;//登录环信账号
@property (nonatomic, assign) BOOL isLogin;

//我的名片
@property (nonatomic, strong) NSNumber *templateId;//模板id
@property (nonatomic, copy) NSString *myCardUrl;//模板图片链接地址

//是否注册企业
@property (nonatomic, assign) BOOL isRegisterEnterprise;

////获取短信验证码
//+ (void)getSmsSendCodeByPara:(NSDictionary *)info
//              viewController:(UIViewController *)viewController
//                      result:(void(^)(NSDictionary *data, NSError *error))result;
//
////通过手机号注册
//+ (void)registerByPhone:(NSDictionary *)info
//         viewController:(UIViewController *)viewController
//                 result:(void(^)(NSDictionary *data, NSError *error))result;
//
////通过手机号登录
//+ (void)loginByPhone:(NSDictionary *)info
//      viewController:(UIViewController *)viewController
//              result:(void(^)(NSDictionary *data, NSError *error))result;
//
////获取用户列表
//+ (void)getUserListInfo:(NSDictionary *)info
//         viewController:(UIViewController *)viewController
//                 result:(void(^)(NSDictionary *data, NSError *error))result;
//
////获取用户详情
//+ (void)getUserDetailInfo:(NSDictionary *)info
//           viewController:(UIViewController *)viewController
//                   result:(void(^)(NSDictionary *data, NSError *error))result;
//
////更新用户信息
//+ (void)updateUserInfo:(NSDictionary *)info
//        viewController:(UIViewController *)viewController
//                result:(void(^)(NSDictionary *data, NSError *error))result;



@end
