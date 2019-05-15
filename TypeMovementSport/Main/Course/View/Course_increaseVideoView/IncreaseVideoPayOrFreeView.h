//
//  IncreaseVideoPayOrFreeView.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/3.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncreaseVideoPayOrFreeView : BaseView

- (instancetype)initViewByFrame:(CGRect)frame dataArr:(NSArray *)dataArr isFreeTypeVideo:(BOOL)isFree;

- (void)showInView:(UIView *)view;

- (void)dismissView;

@end

NS_ASSUME_NONNULL_END
