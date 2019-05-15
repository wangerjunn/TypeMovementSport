//
//  ResumeManagementViewController.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/26.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseViewController.h"
#import "ResumeModel.h"
#import "PositionModel.h"

@interface ResumeManagementViewController : BaseViewController

@property (nonatomic, assign) BOOL isEnterpriseManagement;//企业管理

@property (nonatomic, strong) ResumeModel *resumeModel;
@property (nonatomic, copy) NSDictionary *companyInfoDic;


@end
