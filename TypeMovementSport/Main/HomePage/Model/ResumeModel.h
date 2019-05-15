//
//  ResumeModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/10.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

@interface ResumeModel : BaseModel
/*
 "id": 1,
 "userId": 1,
 "name": "小安",
 "headImg": "http://.....",
 "sex": "女",
 "education": "学前班",
 "major": "体育",
 "school": "大黄蜂幼稚园",
 "phone": "15004375500",
 "workExpYear": "0年",
 "birthday": "2018-12-12",
 "introduction": "我还小",
 "hopePosition": "清闲的",
 "hopeCity": "我家",
 "hopealary": "1亿",
 "hope": "等待",
 "state": "CLOSE",
 "trainExpList": [
         {
         "id": 2,
         "time": "2018-12-12",
         "img": "img",
         "name": "北京马拉松比赛,测试修改",
         "isDelete": false,
         "resume": {
         "id": 1
         }
    ],
 
 "workExpList": [
         {
                 "id": 2,
                 "position": "CTO",
                 "workStartTime": "2014-12-12",
                 "company": "刑动汇科技有限公司,测试修改",
                 "workEndTime": "2018-12-12",
                 "workContent": "技术团队",
                 "isDelete": false,
                 "resume": {
                 "id": 1
                 }
    }]
 
 "matchExpList": [
     {
         "id": 2,
         "time": "2018-12-12",
         "img": "img",
         "name": "北京马拉松比赛,测试修改",
         "project": "长跑",
         "isDelete": false,
         "resume": {
         "id": 1
         }
     }],
 
 user =         {
     birthday = "北京市";
     city = "北京市";
     headImg = "http://img.51gosports.com/upload/201811/29/2/1543458501146.png";
     id = 2;
     integralCount = 3;
     nickName = "Pisces Mrs.";
     phone = 17608883457;
     remark = "我是要成为海贼王的Woman";
     sex = "女性";
     username = 5FD24791753742BCB7CE758656EDF78A;
    };
 }
 */

@property (nonatomic, assign) NSInteger id;//简历id
@property (nonatomic, assign) NSInteger userId;//用户id
@property (nonatomic, copy) NSString *name;//用户姓名
@property (nonatomic, copy) NSString *headImg;//头像
@property (nonatomic, copy) NSString *sex;//性别
@property (nonatomic, copy) NSString *education;//教育程度
@property (nonatomic, copy) NSString *major;//专业
@property (nonatomic, copy) NSString *school;//学校
@property (nonatomic, copy) NSString *phone;//手机号
@property (nonatomic, copy) NSString *workExpYear;//工作经验
@property (nonatomic, copy) NSString *birthday;//生日
@property (nonatomic, copy) NSString *introduction;//简介
@property (nonatomic, copy) NSString *hopePosition;//意向职位
@property (nonatomic, copy) NSString *hopealary;//意向薪资
@property (nonatomic, copy) NSString *hopeCity;//意向城市
@property (nonatomic, copy) NSString *state;//简历状态 CLOSE | OPEN
@property (nonatomic, copy) NSString *hope;//目前状态
@property (nonatomic, copy) NSDictionary *user;//用于环信聊天用户信息
@property (nonatomic, copy) NSDictionary *tips;//提示信息
@property (nonatomic, copy) NSArray *trainExpList;//培训经历
@property (nonatomic, copy) NSArray *workExpList;//工作经历
@property (nonatomic, copy) NSArray *matchExpList;//比赛经历

@end
