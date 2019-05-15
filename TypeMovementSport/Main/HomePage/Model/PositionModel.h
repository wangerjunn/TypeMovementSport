//
//  PositionModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/10.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

@interface PositionModel : BaseModel

/*
 "id": 1,
 "companyId": 1,
 "name": "教练111111111111",
 "city": "北京",
 "addr": "北京",
 "property": "自由发挥",
 "exp": "自由发挥",
 "duty": "自由发挥",
 "demand": "自由发挥",
 "hopealary": "自由发挥",
 "education": "自由发挥",
 isCollection: 是否收藏职位 1:收藏，0：未收藏
 "height": "自由发挥",
 "weight": "自由发挥",
 age = "<null>";
 sex = "<null>";
 "state": "OPEN",
 "tips": {
     "name": "职位名称",
     "city": "工作城市",
     "addr": "工作地点",
     "property": "工作性质",
     "exp": "工作经验",
     "duty": "工作职责",
     "demand": "任职要求",
     "hopealary": "薪资要求",
     "education": "学历要求",
     "height": "身高要求",
     "weight": "体重要求",
     age 年龄
     sex 性别
     "state": "状态  OPEN | CLOSE"
 "company":{
             "id": 1,
             "userId": 1,
             "headImg": "http://pmp.ywyh.top/%E5%9B%B0%E6%AD%BB%E4%BA%86.png",
             "name": "小安1111111111",
             "phone": "15088888888",
             "position": "人事",
             "companyName": "刑动汇",
             "companyScale": "50 - 10000",
             "companyWelfare": "什么都有,什么都有",
             "companyIntroduction": "我们公司是世界上最好的",
             "companLogo": "http://pmp.ywyh.top/%E5%9B%B0%E6%AD%BB%E4%BA%86.png",
             "companyLicense": "http://pmp.ywyh.top/%E5%9B%B0%E6%AD%BB%E4%BA%86.png",
             "state": "PASS",
             "tips": {
                     "userId": "用户id",
                     "headImg": "头像",
                     "name": "姓名",
                     "phone": "手机号",
                     "position": "职位",
                     "companyName": "公司名称",
                     "companyScale": "公司规模",
                     "companyWelfare": "公司福利",
                     "companyIntroduction": "公司简介",
                     "companLogo": "公司logo",
                     "companyLicense": "公司执照",
                     "state": "审核状态     NEW | PASS | NOT"
                }
             },
 
 user =             {
     birthday = "2018-12-12";
     city = "北京";
     headImg = "https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2972650687,1971995716&fm=173&app=25&f=JPEG?w=600&h=338&s=12ABFA050A531BC00E99A7A70300A007";
     id = 1;
     integralCount = 5;
     nickName = "昵称";
     phone = 15811110000;
     remark = "我是一个纯洁的孩子";
     sex = 1;
     username = 5B626FAC257B4B41B791F6DA4D8095A3;
     };
     weight = "自由发挥";
    };
 }
 */
@property (nonatomic, assign) NSInteger id;//职位id
@property (nonatomic, assign) NSInteger companyId;//公司id
@property (nonatomic, assign) BOOL isCollection;//是否收藏职位 1:收藏,0:未收藏
@property (nonatomic, assign) BOOL isDelete;//是否删除职位 1:删除,0:未删除
@property (nonatomic, assign) BOOL isDelivery;//是否投递简历 1:已投递,0:未投递
@property (nonatomic, copy) NSString *name;//职位名称
@property (nonatomic, copy) NSString *city;//城市
@property (nonatomic, copy) NSString *addr;//具体地址
@property (nonatomic, copy) NSString *property;//工作性质
@property (nonatomic, copy) NSString *duty;//工作职责
@property (nonatomic, copy) NSString *demand;//任职要求
@property (nonatomic, copy) NSString *education;//学历要求
@property (nonatomic, copy) NSString *exp;//工作经验
@property (nonatomic, copy) NSString *height;//身高要求
@property (nonatomic, copy) NSString *age;//年龄要求
@property (nonatomic, copy) NSString *sex;//性别要求
@property (nonatomic, copy) NSString *weight;//体重要求
@property (nonatomic, copy) NSString *hopealary;//薪资要求
@property (nonatomic, copy) NSString *state;//状态 CLOSE | OPEN
@property (nonatomic, copy) NSDictionary *company;//公司信息
@property (nonatomic, copy) NSDictionary *user;//用户信息，环信聊天
@property (nonatomic, copy) NSDictionary *tips;//提示信息

@end
