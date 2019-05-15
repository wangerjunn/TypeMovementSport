//
//  EmptyPlaceholderTipsView.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/1.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseView.h"

//NS_ASSUME_NONNULL_BEGIN

@interface EmptyPlaceholderTipsView : BaseView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title info:(NSString *)info block:(void (^)(void))block;

@property (nonatomic, copy) void (^ClickPlaceholderViewBlock)(void);
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *bgView;

@end

//NS_ASSUME_NONNULL_END
