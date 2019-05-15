//
//  ResumeManagementView.h
//  TypeMovementSport
//
//  Created by XDH on 2018/11/27.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "BaseView.h"
typedef enum : NSUInteger {
    ReceiveResume,//公司收到的简历
    CollectionResume,//收藏的简历
} ResumeManamentEnum;
@interface ResumeManagementView : BaseView

- (instancetype)initResumeManagementView:(ResumeManamentEnum)resumeEnum frame:(CGRect)frame requestPara:(NSDictionary *)requestPara;
@property (nonatomic, assign) ResumeManamentEnum resumeEnum;

- (void)setTableHeight:(CGFloat)height;

@end
