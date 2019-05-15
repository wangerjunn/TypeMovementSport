//
//  PayFinishedViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/15.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayFinishedViewController : BaseViewController

@property (nonatomic, strong) NSString *goodsName;//商品名
@property (nonatomic, strong) NSString *goodsPrice;//商品价格
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString *order_type;

@end

NS_ASSUME_NONNULL_END
