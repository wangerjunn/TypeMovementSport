//
//  QuestionListViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/9/15.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "QuestionModel.h"

@interface QuestionListViewController : BaseViewController

@property (nonatomic, copy) void (^PaySuccessCallbackBlock)(void);
@property (nonatomic, strong) QuestionModel *questionModel;

@end
