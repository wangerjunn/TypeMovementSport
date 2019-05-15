//
//  MySignView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/14.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface MySignView : BaseView

- (instancetype)initMySignViewByFrame:(CGRect)frame integralCount:(NSString *)integralCount;
@property (nonatomic, copy) void (^signCallbackBlock)(void);

@end
