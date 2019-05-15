//
//  ResumeUserInfoCell.h
//  BeStudent_Teacher
//
//  Created by XDH on 2018/9/21.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumeModel.h"

@interface ResumeUserInfoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImg;//头像
@property (nonatomic, strong) UIImageView *sexImg;//性别
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *experienceLabel;//经验
@property (nonatomic, strong) UILabel *ageLabel;//年龄
@property (nonatomic, strong) UILabel *eduLevelLabel;//教育程度
@property (nonatomic, strong) UILabel *introLabel;//简介
@property (nonatomic, strong) UILabel *maritalStatusLabel;//婚姻状态
@property (nonatomic, copy) void (^ClickHeadBlock)(void);

@property (nonatomic, copy) ResumeModel *model;


@end
