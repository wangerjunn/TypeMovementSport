//
//  CourseHeaderCommonView.h
//  TypeMovementSport
//
//  Created by XDH on 2019/1/17.
//  Copyright © 2019年 XDH. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseHeaderCommonView : BaseView

@property (nonatomic, copy) void (^CancelBlock)(void);


- (instancetype)initHeaderCommonViewByFrame:(CGRect)frame
                               EnglishTitle:(NSString *)EnglishTitle
                                   conTitle:(NSString *)conTitle
                                      block:(void (^)(void))cancelBlock;


@end

NS_ASSUME_NONNULL_END
