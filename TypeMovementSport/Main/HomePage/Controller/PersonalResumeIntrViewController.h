//
//  PersonalResumeIntrViewController.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/23.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeModel.h"

@interface PersonalResumeIntrViewController : BaseViewController

@property (nonatomic, copy) void (^RightBarItemBlock)(NSString *introduce);
@property (nonatomic, copy) ResumeModel *resumeModel;

@end
