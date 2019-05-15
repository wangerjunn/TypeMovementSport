//
//  TrainModel.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/18.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrainModel : BaseModel
/*
 "img":"图片"
 "id": 2,
 "title": "培训1",
 "city": "东北",
 "browseCount": 0,
 "price": 10000,
 "organizers": "dasdf",
 "startTime": null,
 "endTime": null,
 "phone": "123123123",
 "addr": "大连",
 "content": "维吾尔文二",
 "isDelete": false,
 "isPay":false,
 earnest = "定金";
 "tips": {
     "title": "标题",
     "city": "城市",
     "browseCount": "浏览数量",
     "price": "金额",
     "organizers": "举办方",
     "startTime": "开始时间",
     "endTime": "结束时间",
     "phone": "联系电话",
     "addr": "详细地址",
     "content": "详细内容",
     "isDelete": "是否已删除"
     url = "分享链接";
    "isPay";是否购买
 }
 */

@property (nonatomic, assign) NSInteger id;//培训id
@property (nonatomic, assign) NSInteger browseCount;//浏览数量
@property (nonatomic, assign) BOOL isDelete;//是否删除 1:删除,0:未删除
@property (nonatomic, assign) BOOL isPay;//是否购买 1:购买,0:未购买
@property (nonatomic, copy) NSString *img;//图片logo
@property (nonatomic, copy) NSString *title;//名称
@property (nonatomic, copy) NSString *city;//城市
@property (nonatomic, assign) CGFloat price;//"金额"
@property (nonatomic, copy) NSString *organizers;//举办方
@property (nonatomic, copy) NSString *startTime;//开始时间
@property (nonatomic, copy) NSString *endTime;//结束时间
@property (nonatomic, copy) NSString *phone;//联系电话
@property (nonatomic, copy) NSString *addr;//详细地址
@property (nonatomic, copy) NSString *content;//详细内容
@property (nonatomic, assign) CGFloat earnest;//定金
@property (nonatomic, copy) NSString *url;//分享链接
@property (nonatomic, copy) NSDictionary *tips;//提示信息

@end

NS_ASSUME_NONNULL_END
