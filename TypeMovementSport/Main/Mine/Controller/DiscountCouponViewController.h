//
//  DiscountCouponViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/2.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscountCouponViewController : BaseViewController

@property (nonatomic, copy) NSString *orderID;//订单id，由订单页面选择优惠时传入
@property (nonatomic, copy) void (^SeleCouponBlock)(CouponModel *model);

@end

NS_ASSUME_NONNULL_END
