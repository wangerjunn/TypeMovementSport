//
//  ResumeBasicInfoViewController.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/29.
//  Copyright © 2018年 XDH. All rights reserved.
//

typedef enum : NSUInteger {
    EditResumeHeadInfo = 0,//编辑简历头像信息
    EditResumeJobIntentionInfo,//编辑简历工作意向
    EditResumeJobInfo,//编辑简历工作信息
    EditResumeTrainInfo,//编辑简历培训信息
    EditResumeGameInfo,//编辑简历比赛信息
    EditEnterpriseCertificationInfo,//编辑企业认证企业
} ShowInfoEnum;

#import "BaseViewController.h"

@interface ResumeBasicInfoViewController : BaseViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, assign) ShowInfoEnum showInfoEnum;//
@property (nonatomic, strong) NSDictionary *conDic;
@property (nonatomic, assign) NSInteger itemId;//id
@property (nonatomic, assign) NSInteger resumeId;
@property (nonatomic, copy) void (^RightBarItemBlock)(NSDictionary *dict);
@property (nonatomic, copy) void (^DeleteItemBlock)(void);
@property (nonatomic, copy) NSString *imgUrl;

//EditEnterpriseCertificationInfo时字段
@property (nonatomic, copy) NSString *companyLogo;//公司logo
@property (nonatomic, copy) NSString *companyLicense;//公司营业执照
@end
