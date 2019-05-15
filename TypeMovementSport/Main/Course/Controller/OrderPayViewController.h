//
//  OrderPayViewController.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    OrderTypeClasses,
    OrderTypeTrain
} OrderTypeEnum;

@interface OrderPayViewController : BaseViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *orderName;
@property (nonatomic, assign) CGFloat orderAmount;//订单金额
@property (nonatomic, copy) NSString *goodsId;//商品id
@property (nonatomic, copy) NSString *orderBodyInfo;//订单信息
@property (nonatomic, assign) OrderTypeEnum orderEnum;//订单类型(CLASSES:类别, TRAIN:增值培训)
@property (nonatomic, copy) void (^PaySuccessBlock)(void);//支付成功的回调

@end
