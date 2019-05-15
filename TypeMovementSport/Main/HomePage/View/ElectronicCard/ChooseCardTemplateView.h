//
//  ChooseCardTemplateView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/26.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"

@interface ChooseCardTemplateView : BaseView

@property (nonatomic, copy) void (^seleTemplateBlock)(NSInteger index);
@property (nonatomic, copy) void (^clickBgViewBlock)(void);

- (instancetype)initTemplateViewByFrame:(CGRect)frame
                                 conArr:(NSArray *)conArr
                                  block:( void (^)(NSInteger index))block;
@end
