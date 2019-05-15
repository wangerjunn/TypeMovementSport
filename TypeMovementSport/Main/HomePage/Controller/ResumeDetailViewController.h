//
//  ResumeDetailViewController.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeModel.h"

typedef enum : NSUInteger {
    EditPersonalResume,//编辑个人简历
    BrowseRecruitmentResume,//浏览招聘简历
    BrowseOwnResume,//浏览自己简历
} ResumeEnum;

@interface ResumeDetailViewController : BaseViewController

@property (nonatomic, assign) NSInteger resumeId;//简历id
@property (nonatomic, copy) void (^UpdateResumeBlock)(ResumeModel *model);
@property (nonatomic, assign) ResumeEnum resumeEnum;//简历枚举

@end
