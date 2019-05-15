//
//  CouponModel.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/3.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponModel : BaseModel

/*
 "id": 1,
 "name": "10元优惠券",
 "createTime": 1530374400000,
 "startValidTime": 1530374400000,
 "expireTime": 1561910400000,
 "type": "CASH_COUPON，DISCOUNT_COUPON//折扣优惠",
 "conditions": null,
 "content": "1000",
 "remark": "<p>1、每次服务限使用一张；</p>\n<p>2、红包可用于海福兔服务专区内容抵扣；</p>\n<p>3、最终解释权归海福兔健康所有</p>"
 "userId": 1,
 "useTime": null,
 "receiveTime": null
 */


@property (nonatomic, assign) NSInteger status;//0:可用，1:已过期，2:已使用
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *createTime;//时间戳
@property (nonatomic, copy) NSString *startValidTime;//时间戳
@property (nonatomic, copy) NSString *expireTime;//时间戳
@property (nonatomic, copy) NSString *type;//CASH_COUPON现金优惠，DISCOUNT_COUPON折扣优惠，值为0 - 100,计算使用金额时需要 /100

@property (nonatomic, copy) NSString *content;//type = CASH_COUPON，现金优惠单位是分
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *conditions;//使用条件
@property (nonatomic, assign) CGFloat conditionsHeight;

@property (nonatomic, copy) NSString *useTime;
@property (nonatomic, copy) NSString *receiveTime;

@property (nonatomic, copy) NSString *startTimeStr;
@property (nonatomic, copy) NSString *endTimeStr;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
NS_ASSUME_NONNULL_END
