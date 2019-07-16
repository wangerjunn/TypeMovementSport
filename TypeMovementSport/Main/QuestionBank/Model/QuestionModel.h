//
//  QuestionModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/28.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

@interface QuestionModel : BaseModel
/*
 "id": 5,
 "name": "第一章",
 "mark": null,
 "price": 0,
 "img": "EXAM",
 "examMinute": 100,
 "passScore": 60,
 "expireTime": 0,
 "payCount": 1,
 "count": 0,
 "examCount": 1,
 "successCount": -1,
 "videoList": [
         {
                 attemptSecond = 300;
                 id = 1;
                 isAttempt = 1;
                 name = "公共理论  第1章";
                 tips =                         {
                     attemptSecond = "允许试看时间(如果不允许试看,不需要再判断此字段)";
                     isAttempt = "是否允许试看";
                     name = "视频名称";
                     url = "路径";
                 };
                 url = "http://v.sport-osta.cn/75e175eada4f429c818618ba39f322e4/d9563ed5c6c543f2af0e2ef6fe609818-1a3ecb63ef4bbe4c94a51c65730cf704.mp4";
        }
 ],
 "tips": {
     "name": "名称",
     "price": "价格,为0时表示免费",
     "img": "封面图",
     "examMinute": "考试时间(分钟)",
     "passScore": "及格分数",
     "expireTime": "购买的过期时间(0:未购买或已过期 | 大于0:过期时间)",
     "type": "类别类型(VIDEO:视频 | EXAM:考试题)",
     "mark": "英文",
     "examCount": "练习次数",
     "successCount": "最后一次练习得分" "successCount": "正确的数量",
    "errorCount": "错误的数量"
     "payCount":"购买次数"
     "count":"共多少套题"
     "videoList": "如果type==video时,为视频列表"
 }
 */

@property (nonatomic, assign) NSInteger id;//简历id
@property (nonatomic, assign) CGFloat price;//价格
@property (nonatomic, copy) NSString *title;//"国职认证-初级"
@property (nonatomic, copy) NSString *name;//右上角第几套题
@property (nonatomic, copy) NSString *img;//封面
@property (nonatomic, assign) NSInteger examMinute;//考试时间(分钟)
@property (nonatomic, copy) NSString *mark;//英文
@property (nonatomic, assign) NSInteger passScore;//及格分数
@property (nonatomic, assign) NSTimeInterval expireTime;//购买的过期时间(0:未购买或已过期 | 大于0:过期时间)
@property (nonatomic, assign) NSInteger payCount;//购买次数
@property (nonatomic, copy) NSString *count;//共多少套题
@property (nonatomic, copy) NSString *classesCount;//判断是否大于0，大于0展示多层列表
@property (nonatomic, assign) NSInteger examCount;//练习次数
@property (nonatomic, assign) NSInteger browseCount;//浏览数量
@property (nonatomic, assign) NSInteger shareCount;//分享数量
@property (nonatomic, assign) NSInteger successCount;//最后一次练习得分
@property (nonatomic, assign) NSInteger errorCount;//错误的数量
@property (nonatomic, assign) BOOL isShowPrice;//是否显示价格
@property (nonatomic, copy) NSArray *videoList;//视频列表
@property (nonatomic, assign) BOOL isOnline;//即将上线 0:即将上线，1：已经上线
@property (nonatomic, copy) NSString *pdf;//购买全套课程后赠送PDF文档

@property (nonatomic, assign) BOOL isPurchase;//弹框列表时使用
@end

