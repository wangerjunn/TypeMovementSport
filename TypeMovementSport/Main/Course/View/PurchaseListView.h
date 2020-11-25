//
//  PurchaseListView.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface PurchaseListView : BaseView

@property (nonatomic, copy) void (^purchaseClickBlock)(NSArray *seleCon, CGFloat totalMoney);
@property (nonatomic, copy) void (^ PurchaseTotalVideoBlock)(void);//购买整套视频
- (instancetype)initPurchaseViewByTitle:(NSString *)viewTitle dataArr:(NSArray *)dataArr purchaseBlock:(void (^)(NSArray *seleCon, CGFloat totalMoney))block;

- (void)isShowPdfTips:(BOOL)isShow;

- (void)show;

@end
