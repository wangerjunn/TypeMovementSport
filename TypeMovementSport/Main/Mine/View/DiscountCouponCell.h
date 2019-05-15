//
//  DiscountCouponCell.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/2.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiscountCouponCell : UITableViewCell

@property (nonatomic, strong) UIView *discountCouponStatusView;//是否可用状态
@property (nonatomic, strong) UILabel *statusTextLabel;//状态文字
@property (nonatomic, strong) UILabel *couponIdenLabel;//折扣标识
@property (nonatomic, strong) UILabel *discountContentLabel;//折扣内容
@property (nonatomic, strong) UILabel *validityTitleLabel;//有效期
@property (nonatomic, strong) UILabel *userConditionLabel;//使用条件
@property (nonatomic, strong) UIView *conView;

@property (nonatomic, strong) CouponModel *model;

@end

NS_ASSUME_NONNULL_END
