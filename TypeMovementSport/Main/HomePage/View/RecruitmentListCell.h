//
//  RecruitmentListCell.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/19.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeModel.h"

@interface RecruitmentListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImg;//用户头像
@property (nonatomic, strong) UILabel *nameLabel;//用户姓名
@property (nonatomic, strong) UILabel *positionLabel;//职位
@property (nonatomic, strong) UILabel *salaryLabel;//薪资
@property (nonatomic, strong) UILabel *placeLabel;//工作场地
@property (nonatomic, strong) UILabel *experienceLabel;//工作经验
/**学历*/
@property (nonatomic, strong) UILabel *eduLevelLabel;
/**状态*/
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) ResumeModel *model;

@end
