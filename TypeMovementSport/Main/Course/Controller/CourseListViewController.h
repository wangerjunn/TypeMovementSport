//
//  CourseListViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/12/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseViewController.h"
#import "QuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CourseListViewController : BaseViewController

@property (nonatomic, assign) NSInteger videoTypeId;
@property (nonatomic, copy) NSString *viewTitle;
@property (nonatomic, copy) NSString *EnglishTitle;
@property (nonatomic, assign) CGFloat totalPrice;//整套题的价格
@property (nonatomic, assign) CourseVideoEnum videoEnum;
@property (nonatomic, copy) void (^PaySuccessCallbackBlock)(void);
- (void)setModel:(QuestionModel *)model;

@end

NS_ASSUME_NONNULL_END
