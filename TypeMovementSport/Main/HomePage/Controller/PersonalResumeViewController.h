//
//  PersonalResumeViewController.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/29.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeModel.h"

@interface PersonalResumeViewController : BaseViewController

@property (nonatomic, strong) ResumeModel *resumeModel;
@property (nonatomic, copy) void (^UpdateResumeInfoBlock)(ResumeModel *model);

@end
