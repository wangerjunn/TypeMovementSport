//
//  ActOpeListViewController.h
//  TypeMovementSport
//
//  Created by 小二郎 on 2019/5/4.
//  Copyright © 2019年 小二郎. All rights reserved.
//

#import "BaseViewController.h"
#import "CourseViewController.h"
#import "QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActOpeListViewController : BaseViewController

@property (nonatomic, assign) NSInteger videoTypeId;
@property (nonatomic, copy) NSString *viewTitle;
@property (nonatomic, assign) CourseVideoEnum videoEnum;

@end

NS_ASSUME_NONNULL_END
